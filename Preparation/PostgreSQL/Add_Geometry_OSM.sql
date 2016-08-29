--Add geom with SRID 25833 to OSM-line
ALTER TABLE berlin.osm_line DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'berlin',
	'osm_line',
	'geom_25833',
	25833,
	'MULTILINESTRING'
	,2);
UPDATE berlin.osm_line SET geom_25833 = ST_Transform(geom,25833);
DROP INDEX if exists berlin.idx_berlin_osm_line_geom;
CREATE INDEX idx_berlin_osm_line_geom ON berlin.osm_line USING gist(geom_25833);

--Add geom with SRID 25833 to OSM-points
ALTER TABLE berlin.osm_point DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'berlin',
	'osm_point',
	'geom_25833',
	25833,
	'POINT'
	,2);
UPDATE berlin.osm_point SET geom_25833 = ST_Transform(geom,25833);
DROP INDEX if exists berlin.idx_berlin_osm_point_geom;
CREATE INDEX idx_berlin_osm_point_geom ON berlin.osm_point USING gist(geom_25833);


--Add geom with SRID 25833 to OSM-poly
ALTER TABLE berlin.osm_poly DROP COLUMN if exists geom_25833;
SELECT  AddGeometryColumn(
	'berlin',
	'osm_poly',
	'geom_25833',
	25833,
	'MULTIPOLYGON'
	,2);
UPDATE berlin.osm_poly SET geom_25833 = ST_Transform(geom,25833);
DROP INDEX if exists berlin.idx_berlin_osm_poly_geom;
CREATE INDEX idx_berlin_osm_poly_geom ON berlin.osm_poly USING gist(geom_25833);