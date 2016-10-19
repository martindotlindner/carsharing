--get number of days
SELECT COUNT(DISTINCT(date_trunc('day' ,timestampstart))) FROM berlin.routes;
SELECT DISTINCT(date_trunc('day', timestampstart)) FROM berlin.routes;

--Create sum of sales per day for each hexagon, change number of days!
COPY(
SELECT berlin.berlin_hexagon_1km.gid, (SUM(berlin.routes.sales))/60 as sum_sales_day
 FROM berlin.berlin_hexagon_1km, berlin.routes
 WHERE ST_Within(berlin.routes.geom_start,berlin.berlin_hexagon_1km.geom)
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_sum_sales.csv' DELIMITER ';' CSV HEADER;

--Create weighted population density and other population parameter for each hexagon (peergroup: 25y-45y)

--repair geometry of population layer
DROP TABLE if exists berlin.ewr2015_plr_valid;
SELECT ST_MakeValid(geom),* INTO berlin.ewr2015_plr_valid FROM berlin.ewr2015_plr ;
UPDATE berlin.ewr2015_plr_valid SET geom = ST_CollectionExtract(st_makevalid, 3);

--calculate weighed population density for each hexagon

COPY(
SELECT h.gid,
sum(((st_area (st_intersection (h.geom,e.geom))/st_area(e.geom))*e.pop_density)) AS pop_density,
sum(((st_area (st_intersection (h.geom,e.geom))/st_area(e.geom))*e.pop_density_peergroup)) AS pop_density_peergroup,
avg(((st_area (st_intersection (h.geom,e.geom))/st_area(e.geom))*e.peergroup_percent)) AS peergroup_percent
FROM berlin.berlin_hexagon_1km h, berlin.ewr2015_plr_valid e
 WHERE ST_Intersects(e.geom, h.geom)
GROUP BY h.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_population.csv' DELIMITER ';' CSV HEADER;



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
SELECT berlin.berlin_hexagon_1km.gid, SUM(berlin.weighted_stops.count_arrivals) as sum_arrivals, SUM(berlin.weighted_stops.count_routes) as sum_routes, count(berlin.weighted_stops.*) as count_stops
 FROM berlin.berlin_hexagon_1km, berlin.weighted_stops
 WHERE ST_Within(berlin.weighted_stops.geom,berlin.berlin_hexagon_1km.geom)
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_sum_arrivals.csv' DELIMITER ';' CSV HEADER;



--Create sum of cafes+restaurants (based on OSM) for each hexagon
DROP TABLE if exists berlin.osm_point_restaurant;
CREATE TABLE berlin.osm_point_restaurant AS
SELECT name, geom_25833, amenity FROM berlin.osm_point 
WHERE amenity = 'restaurant' OR amenity = 'cafe' OR amenity = 'pub' OR amenity = 'bar';

COPY(
SELECT berlin.berlin_hexagon_1km.gid, count(berlin.osm_point_restaurant.*) as count_restaurant
 FROM berlin.berlin_hexagon_1km, berlin.osm_point_restaurant
 WHERE ST_Within(berlin.osm_point_restaurant.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_count_restaurant.csv' DELIMITER ';' CSV HEADER;


--Create sum of aerodroms and their passengers for each hexagon
DROP TABLE if exists berlin.osm_point_aerodrome;
CREATE TABLE berlin.osm_point_aerodrome AS
SELECT gid,berlin.osm_point.name, geom_25833, osm_id FROM berlin.osm_point 
WHERE  osm_id = '1456142872' OR osm_id = '36830541';

ALTER TABLE berlin.osm_point_aerodrome ADD COLUMN passengers integer;
UPDATE berlin.osm_point_aerodrome SET passengers = 21005215 WHERE osm_id = 1456142872;
UPDATE berlin.osm_point_aerodrome SET passengers = 8526268 WHERE osm_id = 36830541;

COPY(
SELECT berlin.berlin_hexagon_1km.gid, SUM(passengers) as sum_passengers, count(berlin.osm_point_aerodrome.*) as count_aerodroms
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
SELECT berlin.berlin_hexagon_1km.gid, count(berlin.osm_poly_ikea.*) as count_ikea
 FROM berlin.berlin_hexagon_1km, berlin.osm_poly_ikea
 WHERE ST_Within(berlin.osm_poly_ikea.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_ikea.csv' DELIMITER ';' CSV HEADER;

--Shopping Mall
--Import wikitable
DROP TABLE if exists berlin.mall;
CREATE TABLE berlin.mall(
Rang integer,
Einkaufszentrum character varying (50),
Ort character varying (30),
Bundesland character varying (30),
Verkaufsflaeche character varying (50),
Flaeche integer);

COPY berlin.mall
FROM 'C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Berlin/Strukturdaten/Einkaufszentren/malls.csv'  DELIMITER ';' CSV HEADER;

--Create table with malls from OSM

DROP TABLE if exists berlin.osm_poly_mall;
CREATE TABLE berlin.osm_poly_mall AS
SELECT shop,name, geom_25833 FROM berlin.osm_poly
WHERE shop LIKE '%mall%';

--Join both tables

SELECT * INTO berlin.shopping_malls FROM berlin.osm_poly_mall JOIN berlin.mall ON berlin.osm_poly_mall.name  LIKE berlin.mall.Einkaufszentrum
WHERE berlin.mall.bundesland LIKE 'Berlin' ;

--Problem: several malls (area) intersecting more than one hexagon -> weighed sum 
COPY(
SELECT berlin.berlin_hexagon_1km.gid,
SUM((ST_Area(ST_Intersection(berlin.osm_poly_mall.geom_25833,berlin.berlin_hexagon_1km.geom))/ST_Area(geom_25833))*berlin.mall.flaeche) AS prop_shoppingarea , 
SUM(ST_Area(ST_Intersection(berlin.osm_poly_mall.geom_25833,berlin.berlin_hexagon_1km.geom))/1000000) AS area,
count(berlin.osm_poly_mall.*) as count_mall 
FROM berlin.berlin_hexagon_1km, berlin.osm_poly_mall JOIN berlin.mall ON berlin.osm_poly_mall.name  LIKE berlin.mall.Einkaufszentrum
WHERE berlin.mall.bundesland LIKE 'Berlin' AND ST_Intersects(berlin.osm_poly_mall.geom_25833,berlin.berlin_hexagon_1km.geom)
GROUP BY berlin.berlin_hexagon_1km.gid )
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_mall.csv' DELIMITER ';' CSV HEADER;


--Pedestrian zone, access limited roads
DROP TABLE if exists berlin.osm_line_pedestrian_zone;
CREATE TABLE berlin.osm_line_pedestrian_zone AS
SELECT shop,name, geom_25833, area, access FROM berlin.osm_line
WHERE highway LIKE '%pedestrian%' OR access LIKE 'no' OR access LIKE 'delivery';



-- University, research institute,
DROP TABLE if exists berlin.osm_point_research;
CREATE TABLE berlin.osm_point_research AS
SELECT office, amenity, name, geom_25833 FROM berlin.osm_point
WHERE amenity LIKE '%university%' OR amenity LIKE '%research_institute%' OR office='research';

DROP TABLE if exists berlin.osm_poly_research;
CREATE TABLE berlin.osm_poly_research AS
SELECT * FROM berlin.osm_poly
WHERE amenity LIKE '%university%' OR amenity LIKE '%research_institute%';


--Parking area

DROP TABLE if exists berlin.osm_poly_parking;
CREATE TABLE berlin.osm_poly_parking AS
SELECT amenity, name, geom_25833, ST_Area(geom_25833) as Area FROM berlin.osm_poly
WHERE amenity LIKE '%parking%' AND amenity NOT LIKE '%bicycle%';


COPY(
SELECT berlin.berlin_hexagon_1km.gid,
SUM(ST_Area(ST_Intersection(berlin.osm_poly_parking.geom_25833,berlin.berlin_hexagon_1km.geom))/1000000) AS area,
count(berlin.osm_poly_parking.*) as count_park
FROM berlin.berlin_hexagon_1km, berlin.osm_poly_parking
WHERE ST_Intersects(berlin.osm_poly_parking.geom_25833,berlin.berlin_hexagon_1km.geom) AND ST_IsValid(geom_25833) = 't'
GROUP BY berlin.berlin_hexagon_1km.gid )
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_parking_area.csv' DELIMITER ';' CSV HEADER;


--Parking places
DROP TABLE if exists berlin.osm_point_parking;
CREATE TABLE berlin.osm_point_parking AS
SELECT capacity,geom_25833 FROM osm.berlin_osm_point
WHERE amenity = 'parking';

COPY(
SELECT berlin.berlin_hexagon_1km.gid, count(berlin.osm_point_parking.*) as count_parking, SUM(berlin.osm_point_parking.capacity::int)
 FROM berlin.berlin_hexagon_1km, berlin.osm_point_parking
 WHERE ST_Within(berlin.osm_point_parking.geom_25833,berlin.berlin_hexagon_1km.geom) 
 GROUP BY berlin.berlin_hexagon_1km.gid)
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_parking.csv' DELIMITER ';' CSV HEADER;


-- Parks
DROP TABLE if exists berlin.osm_poly_park;
SELECT * INTO berlin.osm_poly_park FROM berlin.osm_poly
WHERE leisure LIKE 'park' AND landuse LIKE 'recreation_ground';

--C:\Users\Martin\Documents\Workaholic\TUD_Verkehr\Geodaten\Wikipedia


COPY(
SELECT berlin.berlin_hexagon_1km.gid,
SUM(ST_Area(ST_Intersection(berlin.osm_poly_park.geom_25833,berlin.berlin_hexagon_1km.geom))/1000000) AS area,
count(berlin.osm_poly_park.*) as count_park
FROM berlin.berlin_hexagon_1km, berlin.osm_poly_park
WHERE ST_Intersects(berlin.osm_poly_park.geom_25833,berlin.berlin_hexagon_1km.geom) AND ST_IsValid(geom_25833) = 't'
GROUP BY berlin.berlin_hexagon_1km.gid )
TO 'C:/Program Files/PostgreSQL/9.5/data/hexagon_park.csv' DELIMITER ';' CSV HEADER;

