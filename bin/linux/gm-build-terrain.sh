#!/bin/bash

tileSearch=`echo $1 | tr '[:lower:]' '[:upper:]' | sed -e 's/[^A-Z0-9\%]//g'`

binDir="/vagrant/bin/linux/"
currentDir=`pwd`

if [ -z "$tileSearch" ]; then
	echo "Must supply tile name, e.g. NZ26"
	exit 1
else
	echo "Using tile mask $tileSearch"
fi

echo " --> Fetching matching tiles..."
IFS=$'\n'; for tileName in `psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT tile_name FROM grid WHERE tile_name LIKE '${tileSearch}'"`
do
	echo "-----------------------"
	echo "  Processing $tileName"
	echo "-----------------------"
	"$binDir/gm-build-terrain-tile.sh" "$tileName"
done

echo "--> Removing contours contained within watercourses..."
psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
	DELETE FROM
		elevation
	WHERE
		elevation_id IN
	(
		SELECT
			elevation_id
		FROM
			elevation e, surface s
		WHERE
			e.elevation_geom && s.surface_geom
		AND
			s.surface_class_id IN (5, 6)
		AND
			ST_Within(e.elevation_geom, s.surface_geom)
	);
EoSQL

cd $currentDir
