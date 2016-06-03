SELECT  AddGeometryColumn(
	'ffcs',
	'routes',
	'geom_start',
	4326,
	'POINT'
	,2);

UPDATE ffcs.routes SET geom_start = ST_SetSRID(ST_Point(longitudestart, latitudestart), 4326);

CREATE INDEX idx_geom_start ON ffcs.routes USING gist(geom_start);