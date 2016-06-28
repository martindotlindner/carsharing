-- Calculate number of days
SELECT count(distinct(date_trunc('day', timestampstart))) FROM berlin.routes;

-- Sum waiting time per week (number of days/7) as seconds/(60sec*60min*24h) to get waiting time in days for each hexagon
COPY(
SELECT berlin.hexagon_empty.gid, ST_AsText(berlin.hexagon_empty.geom), (SUM(EXTRACT(EPOCH FROM berlin.routes.wait))/(689/7))/86400 AS wait_sum_week
 FROM berlin.hexagon_empty, berlin.routes, berlin.count_days
 WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty.geom)
 GROUP BY berlin.hexagon_empty.gid)
-- TO 'C:/Program Files/PostgreSQL/9.5/data/advert_starts_hexagon.csv' DELIMITER ';' CSV HEADER;
 TO '/tmp/wait_sum_week_hexagon.csv' DELIMITER ';' CSV HEADER;
