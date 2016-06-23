ALTER TABLE berlin.punkte_100m_oa DROP COLUMN if exists id, DROP COLUMN polygon;
-- Remove duplicates but keep the first row of each group

-- Attention! Very time consuming (try with a small selection first)
SELECT * INTO berlin.routes_sel FROM berlin.routes LIMIT 10000;

-- General way
SELECT 
   DISTINCT ON (berlin.punkte_100m_oa.gid) berlin.punkte_100m_oa.gid, berlin.routes_sel.id, ST_Distance(berlin.routes_sel.geom_start, berlin.punkte_100m_oa.geom)  as dist
FROM berlin.punkte_100m_oa, berlin.routes_sel 
ORDER BY berlin.punkte_100m_oa.gid, berlin.routes_sel.id, ST_Distance(berlin.routes_sel.geom_start, berlin.punkte_100m_oa.geom) LIMIT 100;

-- If you know a max distance between both points, you can accelerate calculation

SELECT 
   DISTINCT ON (berlin.punkte_100m_oa.gid) berlin.punkte_100m_oa.gid, berlin.routes_sel.id, ST_Distance(berlin.routes_sel.geom_start, berlin.punkte_100m_oa.geom)  as dist
FROM berlin.punkte_100m_oa, berlin.routes_sel 
WHERE ST_DWithin(berlin.routes_sel.geom_start, berlin.punkte_100m_oa.geom,5000) 
ORDER BY berlin.punkte_100m_oa.gid, berlin.routes_sel.id, ST_Distance(berlin.routes_sel.geom_start, berlin.punkte_100m_oa.geom) LIMIT 100;




