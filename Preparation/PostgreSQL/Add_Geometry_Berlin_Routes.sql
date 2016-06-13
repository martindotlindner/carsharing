ALTER TABLE berlin.routes DROP COLUMN if exists geom;
SELECT  AddGeometryColumn(
	'berlin',
	'routes',
	'geom',
	25833,
	'LINESTRING'
	,2);
	
UPDATE berlin.routes SET geom = ST_Transform(ST_SetSRID(ST_MakeLine(ST_Point(longitudestart, latitudestart), ST_Point(longitudeend, latitudeend)), 4326), 25833);

ALTER TABLE berlin.routes DROP COLUMN if exists geom_start;
SELECT  AddGeometryColumn(
	'berlin',
	'routes',
	'geom_start',
	25833,
	'POINT'
	,2);

UPDATE berlin.routes SET geom_start = ST_Transform(ST_SetSRID(ST_Point(longitudestart, latitudestart), 4326), 25833);

ALTER TABLE berlin.routes DROP COLUMN if exists geom_end;
SELECT  AddGeometryColumn(
	'berlin',
	'routes',
	'geom_end',
	25833,
	'POINT'
	,2);

UPDATE berlin.routes SET geom_end = ST_Transform(ST_SetSRID(ST_Point(longitudeend, latitudeend), 4326), 25833);

DROP INDEX if exists idx_cs_berlin_geom;
CREATE INDEX idx_cs_berlin_geom ON berlin.routes USING gist(geom);