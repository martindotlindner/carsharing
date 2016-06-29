-- Calculate number of days
SELECT count(distinct(date_trunc('day', timestampstart))) FROM berlin.routes;

-- Sum waiting time per week (number of days/7) as seconds/(60sec*60min*24h) to get waiting time in days for each hexagon
COPY(
SELECT berlin.hexagon_empty_01km.gid, ST_AsText(berlin.hexagon_empty_01km.geom), (SUM(EXTRACT(EPOCH FROM berlin.routes.wait))/(689/7))/86400 AS wait_sum_week
 FROM berlin.hexagon_empty_01km, berlin.routes
 WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty_01km.geom)
 GROUP BY berlin.hexagon_empty_01km.gid)
-- TO 'C:/Program Files/PostgreSQL/9.5/data/advert_starts_hexagon.csv' DELIMITER ';' CSV HEADER;
 TO '/tmp/wait_sum_week_hexagon.csv' DELIMITER ';' CSV HEADER;

 