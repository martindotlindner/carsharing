--Count of vehicles, which are available at 9:00am for each hexagon
COPY(
SELECT berlin.hexagon_empty.gid, ST_AsText(berlin.hexagon_empty.geom), count(*), count(*)/60.0 AS sum_vehicles_time
FROM berlin.hexagon_empty, berlin.routes
 WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty.geom) AND timestampend::time <= '09:00:00'::time AND nextstart::time > '09:00:00'::time
 GROUP BY berlin.hexagon_empty.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/.csv' DELIMITER ';' CSV HEADER;


--Generate time series
 SELECT generate_series('2015-01-01 01:00:00', '2015-01-01 24:00:00', interval '1 hour')::time ;


EXPLAIN SELECT berlin.hexagon_empty.gid, ST_AsText(berlin.hexagon_empty.geom), count(*), count(*)/60.0 AS sum_vehicles_time
FROM berlin.hexagon_empty, berlin.routes
 WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty.geom) AND timestampend::time <= '09:00:00'::time AND nextstart::time > '09:00:00'::time
 GROUP BY berlin.hexagon_empty.gid;

 SELECT gid, ST_AsText(berlin.hexagon_empty.geom) FROM berlin.hexagon_empty;