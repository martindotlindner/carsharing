SELECT * FROM berlin.punkte_100m_oa WHERE GID = 1;

SELECT ST_AsText(geom_start) AS "geomstart_txt", ST_AsText(ST_ClosestPoint(berlin.routes.geom_start, berlin.punkte_100m_oa.geom)) FROM berlin.routes, berlin.punkte_100m_oa WHERE GID = 1 LIMIT 10;

COPY(
SELECT berlin.routes.*, ST_Distance(geom_start, berlin.punkte_100m_oa.geom)/1000 AS distance_km
FROM berlin.routes, berlin.punkte_100m_oa 
WHERE ST_DWithin(geom_start, berlin.punkte_100m_oa.geom, 100000) AND berlin.punkte_100m_oa.gid = 1
ORDER BY ST_Distance(geom_start, berlin.punkte_100m_oa.geom)
LIMIT 10)
TO 'C:/Program Files/PostgreSQL/9.5/data/Nearest_Point.csv' (format csv);

SELECT berlin.punkte_100m_oa.gid,berlin.routes.id, avg(ST_Distance(geom_start, berlin.punkte_100m_oa.geom)/1000) AS distance_km
FROM berlin.routes, berlin.punkte_100m_oa 
WHERE ST_DWithin(geom_start, berlin.punkte_100m_oa.geom, 100000) AND berlin.punkte_100m_oa.gid = 1
ORDER BY ST_Distance(geom_start, berlin.punkte_100m_oa.geom)
LIMIT 3;