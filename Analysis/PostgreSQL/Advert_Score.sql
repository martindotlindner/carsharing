-- Create table with daytime depending score of carsharing users as proxy for number of people, how are mobile and see advert
DROP TABLE if exists berlin.advert_value ;
SELECT COUNT(*) AS daytime_score, EXTRACT (hour from timestampstart) as hour INTO berlin.advert_value
FROM berlin.routes
GROUP BY  hour
ORDER BY hour;


ALTER TABLE berlin.routes ADD COLUMN hour_end integer;
UPDATE berlin.routes SET hour_end = EXTRACT (hour from timestampend);

-- Add column with percental amount of trips for every our to each trip
ALTER TABLE berlin.routes ADD COLUMN advert_daytime_score float;
UPDATE berlin.routes
SET advert_daytime_score = (daytime_score::float)/641780*100
FROM berlin.advert_value
WHERE berlin.routes.hour_end = berlin.advert_value.hour; 

-- Add column with advert-score
ALTER TABLE berlin.routes ADD COLUMN advert integer;
UPDATE berlin.routes 
SET advert = (EXTRACT(epoch FROM wait)/3600) * advert_daytime_score;


-- Sum advert-score of all trips for each hexagon
COPY(
SELECT berlin.hexagon_empty.gid, ST_AsText(berlin.hexagon_empty.geom), SUM(berlin.routes.advert)
 FROM berlin.hexagon_empty, berlin.routes
 WHERE ST_Within(berlin.routes.geom_end,berlin.hexagon_empty.geom)
 GROUP BY berlin.hexagon_empty.gid)
 TO 'C:/Program Files/PostgreSQL/9.5/data/advert_starts_hexagon.csv' DELIMITER ';' CSV HEADER;

