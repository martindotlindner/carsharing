--Car2Go
--Create new geom column with local SRID 25832
ALTER TABLE berlin.oa_car2go DROP COLUMN if exists geom_line;
SELECT  AddGeometryColumn(
	'berlin',
	'oa_car2go',
	'geom_line',
	25832,
	'LINESTRING'
	,2);
UPDATE berlin.oa_car2go SET geom_line = ST_Transform(wkb_geometry,25832);

--Convert lines to polygon
SELECT  AddGeometryColumn(
	'berlin',
	'oa_car2go',
	'geom',
	25832,
	'POLYGON'
	,2);
UPDATE berlin.oa_car2go SET geom = ST_MakePolygon(geom_line);

ALTER TABLE berlin.oa_car2go DROP COLUMN if exists geom_line;
