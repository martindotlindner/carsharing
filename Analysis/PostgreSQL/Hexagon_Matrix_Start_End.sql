ALTER TABLE berlin.routes ADD COLUMN start_hex integer;
ALTER TABLE berlin.routes ADD COLUMN end_hex integer;


UPDATE berlin.routes SET start_hex = gid FROM berlin.hexagon_empty WHERE ST_Within(berlin.routes.geom_start, berlin.hexagon_empty.geom);
UPDATE berlin.routes SET end_hex = gid FROM berlin.hexagon_empty WHERE ST_Within(berlin.routes.geom_end, berlin.hexagon_empty.geom);


COPY(
SELECT start_hex,end_hex, count(*) FROM berlin.routes GROUP BY start_hex, end_hex ORDER BY start_hex, end_hex)
TO 'C:/Program Files/PostgreSQL/9.5/data/Hexagon_Matrix.csv' (format csv);