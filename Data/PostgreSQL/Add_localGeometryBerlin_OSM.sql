--Add geom with SRID 25833 to OSM-line
ALTER TABLE osm.berlin_osm_line DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'osm',
	'berlin_osm_line',
	'geom_25833',
	25833,
	'LINESTRING'
	,2);
UPDATE osm.berlin_osm_line SET geom_25833 = ST_Transform(way,25833);
DROP INDEX if exists osm.idx_berlin_osm_line_geom;
CREATE INDEX idx_berlin_osm_line_geom ON osm.berlin_osm_line USING gist(geom_25833);

--Add geom with SRID 25833 to OSM-points
ALTER TABLE osm.berlin_osm_point DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'osm',
	'berlin_osm_point',
	'geom_25833',
	25833,
	'POINT'
	,2);
UPDATE osm.berlin_osm_point SET geom_25833 = ST_Transform(way,25833);
DROP INDEX if exists osm.idx_berlin_osm_point_geom;
CREATE INDEX idx_berlin_osm_point_geom ON osm.berlin_osm_point USING gist(geom_25833);



--Add geom with SRID 25833 to OSM-poly
ALTER TABLE osm.berlin_osm_polygon ALTER COLUMN way SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(way);

--After you've done your import, you can revert back to MultiPolygon:

ALTER TABLE my_table ALTER COLUMN geom 
    SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);

ALTER TABLE osm.berlin_osm_polygon DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'osm',
	'berlin_osm_polygon',
	'geom_25833',
	25833,
	'MultiPolygon'
	,2);
UPDATE osm.berlin_osm_polygon SET geom_25833 = ST_Transform(way,25833);
DROP INDEX if exists osm.idx_berlin_osm_polygon_geom;
CREATE INDEX idx_berlin_osm_polygon_geom ON osm.berlin_osm_polygon USING gist(geom_25833);


