#!/bin/bash

echo "Starting to update OpenStreetMap..."

cd /vagrant/source/ > /dev/null
mkdir osm > /dev/null
cd osm > /dev/null

echo "--> Downloading latest version..."
wget http://download.geofabrik.de/europe/great-britain-latest.osm.pbf

echo "--> Dropping old data..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "DROP TABLE IF EXISTS _src_osm_line; DROP TABLE IF EXISTS _src_osm_point; DROP TABLE IF EXISTS _src_osm_polygon;"
echo "--> Vacuuming..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "VACUUM;"

echo "--> Importing to database..."
osm2pgsql --create -d grough-map -s --username=grough-map -H localhost --unlogged -E 27700 -S grough-map.style -p _src_osm great-britain-latest.osm.pbf

echo "--> Dropping temporary tables..."
echo "    _src_osm_ways..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "DROP TABLE IF EXISTS _src_osm_ways;"
echo "    _src_osm_nodes..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "DROP TABLE IF EXISTS _src_osm_nodes;"
echo "    _src_osm_rels..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "DROP TABLE IF EXISTS _src_osm_rels;"
echo "    _src_osm_roads..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "DROP TABLE IF EXISTS _src_osm_roads;"

echo "--> Converting polygons to multipolygons..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "
	ALTER TABLE
		_src_osm_polygon
	ALTER COLUMN
		way
	TYPE
		geometry(MultiPolygon, 27700)
	USING
		ST_Multi(way);
"

echo "--> Performing full vacuum..."
psql -Ugrough-map grough-map -h 127.0.0.1 -c "VACUUM FULL;"

echo "--> Cleaning up files"
rm -rf /vagrant/source/osm/great-britain-latest.osm.pbf

echo "--> Adding source"
gm-require-attribution "/vagrant/source/osm/attribution.json"

echo "--> Update complete."
