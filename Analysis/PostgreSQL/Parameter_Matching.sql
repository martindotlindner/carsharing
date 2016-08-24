--get number of days
SELECT COUNT(DISTINCT(date_trunc('day' ,timestampstart))) FROM berlin.routes;

--Create sum of sales per day for each hexagon
COPY(
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom), (SUM(berlin.routes.sales))/211 as sum_sales_day
 FROM berlin.berlin_hexagon_1km, berlin.routes
 WHERE ST_Within(berlin.routes.geom_start,berlin.berlin_hexagon_1km.geom)
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_sum_sales.csv' DELIMITER ';' CSV HEADER;

--Import GTFS-stops and create sum of arrivals/routes for each hexagon
DROP TABLE if exists berlin.weighted_stops;
CREATE TABLE berlin.weighted_stops(
	ID serial PRIMARY KEY,
	stop_id integer,
	stop_name character varying,
	count_arrivals integer,
	count_routes integer,
	stop_lat double precision,
	stop_lon double precision);

COPY berlin.weighted_stops (stop_id,stop_name,count_arrivals,count_routes,stop_lat,stop_lon)
FROM 'C:/Program Files/PostgreSQL/9.5/data/weighted_stops.csv' NULL AS 'NA' DELIMITER ';';

ALTER TABLE berlin.weighted_stops DROP COLUMN if exists geom;
SELECT  AddGeometryColumn(
	'berlin',
	'weighted_stops',
	'geom',
	25833,
	'POINT'
	,2);
	
UPDATE berlin.weighted_stops SET geom = ST_Transform(ST_SetSRID(ST_Point(stop_lon, stop_lat), 4326), 25833);
DROP INDEX if exists berlin.idx_berlin_weighted_stops_geom;
CREATE INDEX idx_berlin_weighted_stops_geom ON berlin.weighted_stops USING gist(geom);

--Create sum of arrivals/routes for each hexagon

COPY(
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom), SUM(berlin.weighted_stops.count_arrivals) as sum_arrivals, SUM(berlin.weighted_stops.count_routes) as sum_routes, count(berlin.weighted_stops.*) as count_stops
 FROM berlin.berlin_hexagon_1km, berlin.weighted_stops
 WHERE ST_Within(berlin.weighted_stops.geom,berlin.berlin_hexagon_1km.geom)
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_sum_arrivals.csv' DELIMITER ';' CSV HEADER;



--Create sum of cafes+restaurants (based on OSM) for each hexagon
DROP TABLE if exists berlin.osm_point_restaurant;
CREATE TABLE berlin.osm_point_restaurant AS
SELECT name, geom_25833, ST_AsText(geom_25833), amenity FROM berlin.osm_point 
WHERE amenity = 'restaurant' OR amenity = 'cafe' OR amenity = 'pub' OR amenity = 'bar';

COPY(
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom),count(berlin.osm_point_restaurant.*) as count_restaurant
 FROM berlin.berlin_hexagon_1km, berlin.osm_point_restaurant
 WHERE ST_Within(berlin.osm_point_restaurant.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_count_restaurant.csv' DELIMITER ';' CSV HEADER;


--Create sum of aerodroms and their passengers for each hexagon
DROP TABLE if exists berlin.osm_point_aerodrome;
CREATE TABLE berlin.osm_point_aerodrome AS
SELECT gid,berlin.osm_point.name, geom, ST_AsText(geom) FROM berlin.osm_point 
WHERE  aeroway LIKE 'aerodrome' AND berlin.osm_point.name = 'Flughafen Berlin-Tegel Otto Lilienthal' OR berlin.osm_point.name LIKE 'Flughafen Berlin-Schönefeld';

ALTER TABLE berlin.osm_point_aerodrome ADD COLUMN passengers integer;
UPDATE berlin.osm_point_aerodrome SET passengers = 21005215 WHERE gid = 52052;
UPDATE berlin.osm_point_aerodrome SET passengers = 8526268 WHERE gid = 135049;

COPY(
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom), SUM(passengers) as sum_passengers, count(berlin.osm_point_aerodrome.*) as count_aerodroms
 FROM berlin.berlin_hexagon_1km, berlin.osm_point_aerodrome
 WHERE ST_Within(berlin.osm_point_aerodrome.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_aerodroms.csv' DELIMITER ';' CSV HEADER;

-- IKEA

DROP TABLE if exists berlin.osm_poly_ikea;
CREATE TABLE berlin.osm_poly_ikea AS
SELECT shop,name, geom_25833 FROM berlin.osm_poly
WHERE name LIKE '%IKEA%';

COPY(
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom), count(berlin.osm_poly_ikea.*) as count_ikea
 FROM berlin.berlin_hexagon_1km, berlin.osm_poly_ikea
 WHERE ST_Within(berlin.osm_poly_ikea.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_ikea.csv' DELIMITER ';' CSV HEADER;


