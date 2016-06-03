DROP TABLE if exists berlin.routes;
SELECT * INTO berlin.routes FROM world.routes WHERE ST_DWithin(geom::geography, ST_GeomFromText('POINT(13.33 52.52)', 4326)::geography, 50000); --Select all Routes with Distance of 50.000m from POINT(13.33 52.52)

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


