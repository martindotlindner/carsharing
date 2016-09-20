CREATE SCHEMA if not exists osm;

-- Set schema for berlin_osm
ALTER TABLE berlin_osm_line SET SCHEMA osm;
ALTER TABLE berlin_osm_nodes SET SCHEMA osm;
ALTER TABLE berlin_osm_point SET SCHEMA osm;
ALTER TABLE berlin_osm_polygon SET SCHEMA osm;
ALTER TABLE berlin_osm_rels SET SCHEMA osm;
ALTER TABLE berlin_osm_roads SET SCHEMA osm;
ALTER TABLE berlin_osm_ways SET SCHEMA osm;

-- Set schema for germany_osm
ALTER TABLE germany_osm_line SET SCHEMA osm;
ALTER TABLE germany_osm_nodes SET SCHEMA osm;
ALTER TABLE germany_osm_point SET SCHEMA osm;
ALTER TABLE germany_osm_polygon SET SCHEMA osm;
ALTER TABLE germany_osm_rels SET SCHEMA osm;
ALTER TABLE germany_osm_roads SET SCHEMA osm;
ALTER TABLE germany_osm_ways SET SCHEMA osm;