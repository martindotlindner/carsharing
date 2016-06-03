-- Add Geometry Column with SRID 25833 (ETRS89 / UTM zone 33N) to OSM-Point table
SELECT  AddGeometryColumn(
	'berlin',
	'osm_poi',
	'geom_25833',
	25833,
	'POINT'
	,2);

UPDATE berlin.osm_poi SET geom_25833 = ST_Transform(geom, 25833);