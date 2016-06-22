ALTER TABLE germany.routes DROP COLUMN if exists geom;
SELECT  AddGeometryColumn(
	'germany',
	'routes',
	'geom',
	25832,
	'LINESTRING'
	,2);
	
UPDATE germany.routes SET geom = ST_Transform(ST_SetSRID(ST_MakeLine(ST_Point(longitudestart, latitudestart), ST_Point(longitudeend, latitudeend)), 4326), 25832);

ALTER TABLE germany.routes DROP COLUMN if exists geom_start;
SELECT  AddGeometryColumn(
	'germany',
	'routes',
	'geom_start',
	25832,
	'POINT'
	,2);

UPDATE germany.routes SET geom_start = ST_Transform(ST_SetSRID(ST_Point(longitudestart, latitudestart), 4326), 25832);

ALTER TABLE germany.routes DROP COLUMN if exists geom_end;
SELECT  AddGeometryColumn(
	'germany',
	'routes',
	'geom_end',
	25832,
	'POINT'
	,2);

UPDATE germany.routes SET geom_end = ST_Transform(ST_SetSRID(ST_Point(longitudeend, latitudeend), 4326), 25832);

DROP INDEX if exists idx_cs_germany_geom;
CREATE INDEX idx_cs_germany_geom ON germany.routes USING gist(geom);