#!/bin/bash

tileSearch=`echo $1 | tr '[:lower:]' '[:upper:]' | sed -e 's/[^A-Z0-9\%]//g'`
extraOption=`echo $2 | tr '[:lower:]' '[:upper:]'`

binDir="/vagrant/bin/linux/"
terrainDir="/vagrant/source/os-terrain/"
outputDir="/vagrant/product/"
terrainCommand="$binDir/gm-build-terrain.sh"
obstructionsCommand="$binDir/gm-build-features-obstructions.sh"
mapnikDir="$binDir/Mapnik/"
mapnikOutputDir="$mapnikDir/output/"
mapnikCommand="$mapnikDir/generate.py"
currentDir=`pwd`

if [ -z "$tileSearch" ]; then
	echo "Must supply tile name, e.g. NZ26"
	exit 1
else
	echo "Using tile search $tileSearch"
fi

IFS=$'\n'; for tileName in `psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT tile_name FROM grid WHERE tile_name LIKE '${tileSearch}'"`
do
	echo "-----------------------"
	echo "  Processing $tileName"
	echo "-----------------------"
	
	contourCount=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT Count(e.elevation_id) FROM  grid g, elevation e WHERE  g.tile_name='${tileName}' AND e.elevation_geom && g.tile_geom AND ST_Within(e.elevation_geom, g.tile_geom) GROUP BY g.tile_name"`
	if [ -z "$contourCount" ]; then 
		contourCount=0
	fi
	if [[ ! $contourCount -ge 1 ]]; then
		echo "No terrain data found for this tile. Attempting to generate."
		$terrainCommand $tileName
		contourCount=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT Count(e.elevation_id) FROM  grid g, elevation e WHERE  g.tile_name='${tileName}' AND e.elevation_geom && g.tile_geom AND ST_Within(e.elevation_geom, g.tile_geom) GROUP BY g.tile_name"`
		if [[ -z "$contourCount" || ! "$contourCount" -eq 1 ]]; then
			echo "Unable to generate terrain data. Cannot continue."
			exit 1
		fi
	else
		echo "Identified suitable terrain data for this tile."
	fi

	echo "Processing obstructions..."
	$obstructionsCommand $tileName
	
	echo "Starting map generation process..."
	cd $mapnikDir
	$mapnikCommand $tileName

	if [[ "$tileName" = "LGND" ]]; then
		echo "Trimming output..."
		convert "$mapnikOutputDir/LGND.png" -trim -bordercolor white -border 50 "$outputDir/legend.png"
		rm -rf "$mapnikOutputDir/LGND.png"
	else
		if [ -z "$extraOption" ]; then
			echo "Moving output..."
			mv "$mapnikOutputDir/"`echo "$tileName" | tr '[:upper:]' '[:lower:]'`".png" "${outputDir}/${tileName}.png"
		else
			if [ "$extraOption" != "geotiff" ]; then
				echo "Converting output..."
				convert "$mapnikOutputDir/$tileName.png" -compress LZW "$outputDir/$tileName.tiff"
				echo "Assigning georeference..."
				# TODO: Convert this to not rely on the ASC file
				#IFS=' ' read -r -a tileBounds <<< `gdalinfo ${terrainDir}/${tileName}.asc | awk '/(Upper Left)|(Lower Right)/' | awk '{gsub(/,|\)|\(/," ");print $3 " " $4}' | sed ':a;N;$!ba;s/\\n/ /g'`
				tileData=`psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT ST_XMin(tile_geom), ST_YMin(tile_geom), ST_XMax(tile_geom), ST_YMax(tile_geom) FROM grid WHERE tile_name='${tileName}'"`
				IFS='|'; read -r -a tileBounds <<< "$tileData"
				gdal_edit.py -a_ullr ${tileBounds[0]} ${tileBounds[3]} ${tileBounds[2]} ${tileBounds[1]} -a_srs "EPSG:27700" "$outputDir/$tileName.tiff"
				rm -f "$mapnikOutputDir/$tileName.png"
			fi
		fi
	fi
done

echo "--> Removing temporary tables..."
psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
	DROP TABLE IF EXISTS _tmp_contour_label_primary CASCADE;
	DROP TABLE IF EXISTS _tmp_contour_label_rings CASCADE;
	DROP TABLE IF EXISTS _tmp_label_zone CASCADE;
EoSQL

cd $currentDir
