DROP TABLE germany.voronoi_routes

-- DROP TABLE germany.voronoi_starts 
CREATE TABLE germany.voronoi_starts(
	ID_START integer,
	START_GTFS_ID integer,
	START_LAT double precision,
	START_LON double precision);

INSERT into germany.voronoi_starts (ID_START, START_GTFS_ID,START_LAT,START_LON) ( 
 SELECT germany.starts.id, gtfs.stops_voronoi.stop_id, gtfs.stops_voronoi.stop_lat, gtfs.stops_voronoi.stop_lon
 FROM germany.starts, gtfs.stops_voronoi
 WHERE ST_Within(germany.starts.geom,gtfs.stops_voronoi.geom) 
);

--DROP TABLE germany.voronoi_stops;
CREATE TABLE germany.voronoi_stops(
	ID_STOP integer,
	STOP_GTFS_ID integer,
	STOP_LAT double precision,
	STOP_LON double precision);
	
INSERT into germany.voronoi_stops (ID_STOP, STOP_GTFS_ID,STOP_LAT,STOP_LON) ( 
 SELECT germany.stops.id, gtfs.stops_voronoi.stop_id, gtfs.stops_voronoi.stop_lat, gtfs.stops_voronoi.stop_lon
 FROM germany.stops, gtfs.stops_voronoi
 WHERE ST_Within(germany.stops.geom,gtfs.stops_voronoi.geom) 
);

CREATE TABLE germany.voronoi_routes AS (
SELECT * FROM germany.voronoi_starts JOIN germany.voronoi_stops ON germany.voronoi_starts.id_start = germany.voronoi_stops.id_stop
);


SELECT  AddGeometryColumn(
	'germany',
	'voronoi_routes',
	'geom',
	25832,
	'LINESTRING'
	,2);

UPDATE germany.voronoi_routes SET geom = ST_Transform(ST_SetSRID(ST_MakeLine(ST_Point(START_LON, START_LAT), ST_Point(STOP_LON, STOP_LAT)), 4326), 25832);

VACUUM ANALYZE germany.voronoi_routes;

CREATE TABLE germany.voronoi_count AS (
SELECT voronoi_routes.geom, count(germany.voronoi_routes.geom)
FROM germany.voronoi_routes 
GROUP BY germany.voronoi_routes.geom);
