ALTER TABLE world.routes DROP COLUMN if exists geom;
SELECT  AddGeometryColumn(
	'world',
	'routes',
	'geom',
	4326,
	'LINESTRING'
	,2);

UPDATE world.routes SET geom = ST_SetSRID(ST_MakeLine(ST_Point(longitudestart, latitudestart), ST_Point(longitudeend, latitudeend)), 4326);

DROP INDEX if exists idx_world_routes_geom;
CREATE INDEX idx_world_routes_geom ON world.routes USING gist(geom);

ALTER TABLE world.routes DROP COLUMN if exists geom_start;
SELECT  AddGeometryColumn(
	'ffcs',
	'routes',
	'geom_start',
	4326,
	'POINT'
	,2);

UPDATE ffcs.routes SET geom_start = ST_SetSRID(ST_Point(longitudestart, latitudestart), 4326);

DROP INDEX if exists idx_world_routes_geom_start;
CREATE INDEX idx_world_routes_geom_start ON ffcs.routes USING gist(geom_start);

