ALTER TABLE berlin.routes DROP COLUMN if exists geom_end;
SELECT  AddGeometryColumn(
	'berlin',
	'routes',
	'geom_end',
	25833,
	'POINT'
	,2);

UPDATE berlin.routes SET geom_end = ST_Transform(ST_SetSRID(ST_Point(longitudeend, latitudeend), 4326), 25833);

SELECT * FROM berlin.routes ORDER BY timestampstart desc LIMIT 100;

ALTER TABLE berlin.routes ADD COLUMN start_hex integer;
ALTER TABLE berlin.routes ADD COLUMN end_hex integer;


UPDATE berlin.routes SET start_hex = gid FROM berlin.hexagon_1km WHERE ST_Within(berlin.routes.geom_start, berlin.hexagon_1km.geom);
UPDATE berlin.routes SET end_hex = gid FROM berlin.hexagon_1km WHERE ST_Within(berlin.routes.geom_end, berlin.hexagon_1km.geom);


COPY(
SELECT start_hex,end_hex, count(*) FROM berlin.routes WHERE TIMESTAMPSTART < '2015-06-01'::timestamp AND TIMESTAMPSTART > '2015-03-01'::timestamp GROUP BY start_hex, end_hex ORDER BY start_hex, end_hex)
--Windows
--TO 'C:/Program Files/PostgreSQL/9.5/data/Hexagon_Matrix_before.csv' DELIMITER ';' CSV HEADER;
-- Linux
TO '/tmp/Hexagon_Matrix_before.csv' DELIMITER ';' CSV HEADER;

COPY(
SELECT start_hex,end_hex, count(*) FROM berlin.routes WHERE TIMESTAMPSTART < '2015-09-01'::timestamp AND TIMESTAMPSTART > '2015-06-01'::timestamp GROUP BY start_hex, end_hex ORDER BY start_hex, end_hex)
--Windows
--TO 'C:/Program Files/PostgreSQL/9.5/data/Hexagon_Matrix_after.csv' DELIMITER ';' CSV HEADER;
-- Linux
TO '/tmp/Hexagon_Matrix_after.csv' DELIMITER ';' CSV HEADER;