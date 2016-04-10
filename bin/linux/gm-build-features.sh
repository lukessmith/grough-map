#!/bin/bash

echo "Preparing to build feature database..."

binDir=/vagrant/bin/linux
sqlDir=/vagrant/source/sql

echo "-----------------------------------"
echo "--> Importing feature data..."
echo "-----------------------------------"

echo "--> Removing old data..."
psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
	TRUNCATE feature_linear;
	TRUNCATE feature_point;
	DROP INDEX IF EXISTS "Idx: feature_linear::feature_geom";
	DROP INDEX IF EXISTS "Idx: feature_point::feature_geom";
EoSQL

echo " --> Identifying columns to check for imports..."
IFS=$'\n'; for columnName in `psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT DISTINCT import_field FROM feature_import"`
do
	echo "    --> Found column: ${columnName}..."
	echo "       --> Importing lines..."
	psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
		INSERT INTO feature_linear (feature_class_id, feature_geom)
		SELECT
			i.import_class_id AS feature_class_id,
			ST_Multi(way) AS feature_geom
		FROM
			_src_osm_line o
		INNER JOIN
			feature_import i
		ON
			o.${columnName} = i.import_value
		AND
			i.import_line = true;
EoSQL
	echo "       --> Importing polygons..."
	psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
		INSERT INTO feature_linear (feature_class_id, feature_geom)
		SELECT
			i.import_class_id AS feature_class_id,
			ST_Multi(ST_ExteriorRing(way)) AS feature_geom
		FROM
			_src_osm_polygon o
		INNER JOIN
			feature_import i
		ON
			o.${columnName} = i.import_value
		AND
			i.import_polygon_edge = true;
EoSQL
	echo "       --> Importing points..."
	psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
		INSERT INTO feature_point (feature_class_id, feature_geom)
		SELECT
			i.import_class_id AS feature_class_id,
			way AS feature_geom
		FROM
			_src_osm_point o
		INNER JOIN
			feature_import i
		ON
			o.${columnName} = i.import_value
		AND
			i.import_point = true;
EoSQL
echo "       --> Importing lines as points..."
	psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
		INSERT INTO feature_point (feature_class_id, feature_geom)
		SELECT
			i.import_class_id AS feature_class_id,
			ST_Line_Interpolate_Point(way, 0.5) AS feature_geom
		FROM
			_src_osm_line o
		INNER JOIN
			feature_import i
		ON
			o.${columnName} = i.import_value
		AND
			i.import_point = true
EoSQL
	# TODO: Snap to edges for some points (e.g. gates)
done

echo "--> Indexing and clustering..."
psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
	CREATE INDEX "Idx: feature_linear::feature_geom"
		ON public.feature_linear
		USING gist
		(feature_geom);
	ALTER TABLE public.feature_linear CLUSTER ON "Idx: feature_linear::feature_geom";
	CREATE INDEX "Idx: feature_point::feature_geom"
		ON public.feature_point
		USING gist
		(feature_geom);
	ALTER TABLE public.feature_point CLUSTER ON "Idx: feature_point::feature_geom";
EoSQL

echo "--> Cleaning up..."
psql -Ugrough-map grough-map -h 127.0.0.1 << EoSQL
	VACUUM FULL ANALYZE feature_linear;
	VACUUM FULL ANALYZE feature_point;
EoSQL

echo "--> Build complete."