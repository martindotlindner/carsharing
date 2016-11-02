--Add geom with SRID 25832 to OSM-line
ALTER TABLE osm.germany_osm_line DROP COLUMN if exists geom_25832;
SELECT  AddGeometryColumn(
	'osm',
	'germany_osm_line',
	'geom_25832',
	25832,
	'LINESTRING'
	,2);
UPDATE osm.germany_osm_line SET geom_25832 = ST_Transform(way,25832);
DROP INDEX if exists osm.idx_germany_osm_line_geom;
CREATE INDEX idx_germany_osm_line_geom ON osm.germany_osm_line USING gist(geom_25832);

--Add geom with SRID 25832 to OSM-points
ALTER TABLE osm.germany_osm_point DROP COLUMN if exists geom_25832;
SELECT  AddGeometryColumn(
	'osm',
	'germany_osm_point',
	'geom_25832',
	25832,
	'POINT'
	,2);
UPDATE osm.germany_osm_point SET geom_25832 = ST_Transform(way,25832);
DROP INDEX if exists osm.idx_germany_osm_point_geom;
CREATE INDEX idx_germany_osm_point_geom ON osm.germany_osm_point USING gist(geom_25832);



--Add geom with SRID 25832 to OSM-poly
ALTER TABLE osm.germany_osm_polygon ALTER COLUMN way SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(way);

--After you've done your import, you can revert back to MultiPolygon:

ALTER TABLE my_table ALTER COLUMN geom 
    SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);

ALTER TABLE osm.germany_osm_polygon DROP COLUMN if exists geom_25832;
SELECT  AddGeometryColumn(
	'osm',
	'germany_osm_polygon',
	'geom_25832',
	25832,
	'MultiPolygon'
	,2);
UPDATE osm.germany_osm_polygon SET geom_25832 = ST_Transform(way,25832);
DROP INDEX if exists osm.idx_germany_osm_polygon_geom;
CREATE INDEX idx_germany_osm_polygon_geom ON osm.germany_osm_polygon USING gist(geom_25832);

--Rename column names with quotes (required for following analysis)
ALTER TABLE osm.germany_osm_point RENAME COLUMN "addr:housename" TO housename;
ALTER TABLE osm.germany_osm_point RENAME COLUMN "addr:housenumber" TO housenumber;
ALTER TABLE osm.germany_osm_point RENAME COLUMN "addr:interpolation" TO interpolation;
ALTER TABLE osm.germany_osm_point RENAME COLUMN "generator:source" TO source;
ALTER TABLE osm.germany_osm_point RENAME COLUMN "tower:type" TO towertype;
ALTER TABLE osm.germany_osm_point RENAME COLUMN "natural" TO natural_type;

ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "addr:housename" TO housename;
ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "addr:housenumber" TO housenumber;
ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "addr:interpolation" TO interpolation;
ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "generator:source" TO source;
ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "tower:type" TO towertype;
ALTER TABLE osm.germany_osm_polygon RENAME COLUMN "natural" TO natural_type;
