ALTER SYSTEM SET shared_buffers = '4000MB';
ALTER SYSTEM SET work_mem = '2000MB';
ALTER SYSTEM SET max_connections = 3;

   ALTER TABLE berlin.punkte_100m_oa DROP COLUMN if exists id, DROP COLUMN polygon;
-- Remove duplicates but keep the first row of each group

-- Attention! Very time consuming (try with a small selection first)
SELECT * INTO berlin.routes_sel FROM berlin.routes LIMIT 10000;

-- Calculate nearest neighbour with all starting points

COPY(
 SELECT
  points.*,
  routes.id as routes_id,
  ST_Distance(routes.geom_start, points.geom) AS distance
FROM
  berlin.punkte_100m_oa AS points
CROSS JOIN LATERAL
  (SELECT id, geom_start
   FROM berlin.routes_sel
   ORDER BY
       points.geom <-> geom_start
   LIMIT 1) AS routes)
TO 'C:/Program Files/PostgreSQL/9.5/data/Nearest_Neighbour.csv' DELIMITER ';' CSV HEADER;


-- Calculate nearest neighbour with starting point to given date/time
DROP TABLE if exists berlin.standzeit;

SELECT id, vehicleid, timestampstart, timestampend, LEAD (timestampstart) OVER (partition by vehicleid ORDER BY vehicleid, timestampstart) AS nextstart INTO berlin.standzeit
		   FROM berlin.routes;	

ALTER TABLE berlin.routes DROP COLUMN if exists nextstart;
ALTER TABLE berlin.routes ADD COLUMN nextstart timestamp;

UPDATE berlin.routes
SET    nextstart = berlin.standzeit.nextstart
FROM   berlin.standzeit
WHERE  berlin.routes.id = berlin.standzeit.id
AND    berlin.routes.vehicleid = berlin.standzeit.vehicleid
AND    berlin.routes.timestampstart = berlin.standzeit.timestampstart;


CREATE INDEX idx_berlin_routes_nextstart ON berlin.routes_sel(nextstart);


 SELECT
  points.*,
  routes.id as routes_id,
  ST_Distance(routes.geom_start, points.geom) AS distance
FROM
  berlin.punkte_100m_oa AS points
CROSS JOIN LATERAL
  (SELECT id, geom_start
   FROM berlin.routes_sel WHERE timestampend > '2014-11-05 07:00:00'::timestamp AND nextstart < '2014-11-05 08:00:00'::timestamp
   ORDER BY
       points.geom <-> geom_start
   LIMIT 1) AS routes;




