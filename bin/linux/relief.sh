#!/bin/bash

tileName=`echo $1 | tr '[:lower:]' '[:upper:]'`
binDir="/vagrant/bin/linux/"
scratchDir="/tmp/"
sqlDir="/vagrant/source/sql/"
osTileDir="/vagrant/source/os-terrain/"
eaTileDir="/vagrant/source/eagg/"
targetDir="/vagrant/source/terrain-composite/"
currentDir=`pwd`
workingDir="contours"

if [[ "$tileName"="LGND" ]]; then
	convert -size 100x100 xc:white "${binDir}/Mapnik/relief/ReliefGeo.tif"
	exit 0
fi

rm -rf "${scratchDir}/${workingDir}"
cd $scratchDir
mkdir $workingDir

echo "--> Storing spatial extent..."
#tileExtent=`gdalinfo $osTileDir/${tileName}.asc | awk '/(Lower Left)|(Upper Right)/' | awk '{gsub(/,|\)|\(/," ");print $3 " " $4}' | sed ':a;N;$!ba;s/\n/ /g'`
tileData=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT ST_XMin(tile_geom), ST_YMin(tile_geom), ST_XMax(tile_geom), ST_YMax(tile_geom) FROM grid WHERE tile_name='${tileName}'"`
IFS='|'; read -r -a tileExtentEls <<< "$tileData"
tileExtent="${tileExtentEls[0]} ${tileExtentEls[1]} ${tileExtentEls[2]} ${tileExtentEls[3]}"
echo $tileExtent

echo "--> Preparing GRASS installation..."
gm-software-grass

echo "GISDBASE: ${scratchDir}/$workingDir" > ${scratchDir}/grassrc
echo "LOCATION_NAME: surface" >> ${scratchDir}/grassrc
echo "MAPSET: PERMANENT" >> ${scratchDir}/grassrc
echo "GASS_GUI: text" >> ${scratchDir}/grassrc

export GISBASE=`grass70 --config path`
export GISRC="${scratchDir}/grassrc"
export GRASS_MESSAGE_FORMAT=plain
export LD_LIBRARY_PATH="${GISBASE}/lib"
export GRASS_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
export PATH=${PATH}:${GISBASE}/bin:${GISBASE}/scripts

g.proj -c epsg=27700 location=surface
g.region -s 

echo "--> Setting processing region..."
IFS=' ' read -r -a tileBounds <<< "${tileExtent}"
tileCentreE=$(( (${tileBounds[0]%.*} + ${tileBounds[2]%.*}) / 2 ))
tileCentreN=$(( (${tileBounds[1]%.*} + ${tileBounds[3]%.*}) / 2 ))

edgeLeft=$(( $tileCentreE - 6000 ))
edgeRight=$(( $tileCentreE + 6000 ))
edgeUp=$(( $tileCentreN + 6000 ))
edgeDown=$(( $tileCentreN - 6000 ))

echo "--> Assessing region min/max..."
tileData=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT min(elevation_level)::integer AS min_lev, max(elevation_level)::integer AS max_lev, avg(elevation_level)::integer AS avg_lev FROM elevation WHERE elevation_geom && ST_MakeBox2D(ST_Point($edgeLeft, $edgeDown),ST_Point($edgeRight, $edgeUp))"`
echo "--> Assessing region empty space..."
tileEmptyArea=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "
SELECT
	(max(ST_Area(grid_empty)) / (1000 * 1000))::integer
FROM
(
	SELECT
		(ST_Dump(ST_Difference(grid_box, grid_zone))).geom AS grid_empty
	FROM
		ST_SetSRID(ST_MakeBox2D(ST_Point(${tileBounds[0]}, ${tileBounds[1]}), ST_Point(${tileBounds[2]}, ${tileBounds[3]})), 27700) AS grid_box
	LEFT JOIN
	(
		SELECT
			ST_Union(ST_Buffer(elevation_geom, 50.0)) AS grid_zone
		FROM
			elevation
		WHERE
			elevation_geom && ST_SetSRID(ST_MakeBox2D(ST_Point(${tileBounds[0]}, ${tileBounds[1]}), ST_Point(${tileBounds[2]}, ${tileBounds[3]})), 27700)
	) SA
	ON
		true
) SB
GROUP BY
	true
"`
IFS='|'; read -r -a tileAssessment <<< "$tileData"
IFS='|'; read -r -a tileEmptySize <<< "$tileEmptyArea"
echo "   Min: ${tileAssessment[0]}"
echo "   Max: ${tileAssessment[1]}"
echo "   Avg: ${tileAssessment[2]}"
echo "   Empty: ${tileEmptySize[0]}"
if [ ${tileAssessment[1]} -le 300 ] || [ ${tileEmptySize[0]} -ge 2 ]; 
then
	echo "    --> Using IDW for surface..."
	enableIDW=1
else
	echo "    --> IDW disabled for surface..." 
	enableIDW=0
fi

cellRes=10
cellsX=$(( ($edgeRight - $edgeLeft)/$cellRes ))
cellsY=$(( ($edgeRight - $edgeLeft)/$cellRes ))

g.region n=$edgeUp s=$edgeDown w=$edgeLeft e=$edgeRight res=$cellRes -ap

echo "--> Extracting contours from database..."
pgsql2shp -f "${scratchDir}/${workingDir}/contours.shp" -u grough-map -h 127.0.0.1 grough-map \
	"SELECT elevation_level AS lev, elevation_geom FROM elevation WHERE elevation_geom && ST_MakeBox2D(ST_Point($edgeLeft, $edgeDown),ST_Point($edgeRight, $edgeUp))"

echo "--> Importing to GRASS..."
v.in.ogr input="${scratchDir}/${workingDir}/contours.shp" output="elev_contours" -r

echo "--> Converting to raster..."
v.to.rast input=elev_contours output=contour_raster use=attr attribute_column=LEV

echo "--> Creating surface..."
if [ "$enableIDW" -ge 1 ]; then
	r.mapcalc expression="contour_raster_int=round(contour_raster)"	
	r.surf.idw input=contour_raster_int output=elev_raster npoints=50
else
	r.surf.contour in=contour_raster output=elev_raster
fi

echo "--> Exporting from GRASS..."
r.out.gdal input=elev_raster output="${scratchDir}/${workingDir}/elev_${tileName}.img" format=HFA type=Float32 -f --overwrite --verbose

echo "--> Converting to relief..."
gdaldem hillshade -compute_edges -alt 30 "${scratchDir}/${workingDir}/elev_${tileName}.img" "${scratchDir}/${workingDir}/aspect_${tileName}.tif"
gdaldem color-relief "${scratchDir}/${workingDir}/elev_${tileName}.img" "$binDir/Mapnik/grough_relief.txt" "${scratchDir}/${workingDir}/relief_${tileName}.tif"
convert "${scratchDir}/${workingDir}/aspect_${tileName}.tif" -recolor "0.5 0.5 0.5, 0.5 0.5 0.5, 0.0 0.0 0.0" -gaussian-blur 5 -resize ${cellsX}x${cellsY}  "${scratchDir}/${workingDir}/aspect_colour_${tileName}.tif"
convert -size ${cellsX}x${cellsY} xc:white -colorspace RGB -alpha set -depth 8 -type TrueColor -compose over \( "${scratchDir}/${workingDir}/relief_${tileName}.tif" -alpha set -channel A -evaluate set 20% \) -composite "${scratchDir}/${workingDir}/relief_alpha_${tileName}.tif"
convert "${scratchDir}/${workingDir}/relief_alpha_${tileName}.tif" -colorspace RGB -alpha set -depth 8 -type TrueColor -compose Overlay \( "${scratchDir}/${workingDir}/aspect_colour_${tileName}.tif" -alpha set -channel A -evaluate set 80% \) -composite "${scratchDir}/${workingDir}/aspect_relief_${tileName}.tif"
convert -size ${cellsX}x${cellsY} xc:white \( "${scratchDir}/${workingDir}/aspect_relief_${tileName}.tif" -alpha set -channel A -evaluate set 50% \) -composite -depth 8 -layers flatten "${scratchDir}/${workingDir}/final_relief_${tileName}.tif"
gdal_translate -ot Byte -a_srs EPSG:27700 -a_ullr $edgeLeft $edgeUp $edgeRight $edgeDown "${scratchDir}/${workingDir}/final_relief_${tileName}.tif" "${scratchDir}/${workingDir}/geo_final_relief_${tileName}.tif"

echo "--> Copying files..."
#cp "${scratchDir}/${workingDir}/"*.tif /vagrant/volatile/ # For testing only
cp "${scratchDir}/${workingDir}/geo_final_relief_${tileName}.tif" "${binDir}/Mapnik/relief/ReliefGeo.tif"

echo "--> Cleaning files..."
rm -rf "${scratchDir}/${workingDir}"

cd $currentDir
