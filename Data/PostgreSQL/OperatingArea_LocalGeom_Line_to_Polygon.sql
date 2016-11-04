--Car2Go
--Create new geom column with local SRID 25832
ALTER TABLE germany.berlin_oa_car2go DROP COLUMN if exists geom_25832;
SELECT  AddGeometryColumn(
	'germany',
	'berlin_oa_car2go',
	'geom_25832',
	25832,
	'LINESTRING'
	,2);
UPDATE germany.berlin_oa_car2go SET geom_25832 = ST_Transform(wkb_geometry,25832);

--Convert lines to polygon
SELECT  AddGeometryColumn(
	'germany',
	'berlin_oa_car2go',
	'geom_poly_25832',
	25832,
	'POLYGON'
	,2);
UPDATE germany.berlin_oa_car2go SET geom_poly_25832 = ST_MakePolygon(geom_25832);