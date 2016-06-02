SELECT  AddGeometryColumn(
	'world',
	'routes',
	'geom',
	4326,
	'LINESTRING'
	,2);

UPDATE world.routes SET geom = ST_SetSRID(ST_MakeLine(ST_Point(longitudestart, latitudestart), ST_Point(longitudeend, latitudeend)), 4326);

CREATE INDEX idx_world_geom ON world.routes USING gist(geom);

