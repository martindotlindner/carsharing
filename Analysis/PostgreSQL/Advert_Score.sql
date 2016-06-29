SELECT * FROM berlin.routes LIMIT 100;

-- Add column with GTKC-value
ALTER TABLE berlin.routes DROP COLUMN if exists gtkc;
ALTER TABLE berlin.routes ADD COLUMN gtkc double precision;

-- Add GTKC from hexagons
UPDATE berlin.routes SET gtkc = 1;

-- Change GTKC depending on daytime
UPDATE berlin.routes SET gtkc = CASE
 WHEN EXTRACT(hour from timestampend) > 6 AND EXTRACT(hour from nextstart) < 22 THEN gtkc*2
 WHEN EXTRACT(hour from timestampend) > 22 OR EXTRACT(hour from timestampend) < 6  AND EXTRACT(hour from nextstart) < 6 THEN gtkc/2
 ELSE gtkc
END;


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

