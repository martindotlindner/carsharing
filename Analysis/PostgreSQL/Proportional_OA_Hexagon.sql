--Select hexagons which intersects with operating area into new table
DROP TABLE if exists berlin.hexagon_1km_car2go ;
SELECT berlin.hexagon_1km.gid, berlin.hexagon_1km.geom, ST_AsText(berlin.hexagon_1km.geom) 
INTO berlin.hexagon_1km_car2go 
FROM berlin.hexagon_1km, berlin.oa_car2go WHERE
ST_Intersects(berlin.hexagon_1km.geom, berlin.oa_car2go.geom_poly_25832) AND berlin.oa_car2go.zoneType NOT LIKE 'excluded' ;

DROP TABLE if exists berlin.hexagon_1km_car2go ;
SELECT berlin.hexagon_1km.gid, berlin.hexagon_1km.geom, ST_AsText(berlin.hexagon_1km.geom) 
INTO berlin.hexagon_1km_car2go 
FROM berlin.hexagon_1km, berlin.oa_car2go WHERE
ST_Intersects(berlin.hexagon_1km.geom, berlin.oa_car2go.geom) AND berlin.oa_car2go.zoneType NOT LIKE 'excluded' ;


--Calculate proportinal operating area for each hexagon (partly coverage at the boundery)
DROP TABLE if exists berlin.hexagon_car2go_area_oa ;
SELECT berlin.hexagon_1km_car2go.gid,
SUM(ST_Area(ST_Intersection(berlin.oa_car2go.geom,berlin.hexagon_1km_car2go.geom))/1000000) AS area_oa
INTO berlin.hexagon_car2go_area_oa
FROM berlin.hexagon_1km_car2go, berlin.oa_car2go
WHERE ST_Intersects(berlin.oa_car2go.geom,berlin.hexagon_1km_car2go.geom) AND berlin.oa_car2go.zoneType NOT LIKE 'excluded'
GROUP BY berlin.hexagon_1km_car2go.gid ;

--Add column with size of operating area for each hexagon

ALTER TABLE berlin.hexagon_1km_car2go DROP COLUMN if exists area_oa ;
ALTER TABLE berlin.hexagon_1km_car2go ADD COLUMN area_oa double precision;
UPDATE berlin.hexagon_1km_car2go SET area_oa = berlin.hexagon_car2go_area_oa.area_oa FROM berlin.hexagon_car2go_area_oa 
WHERE berlin.hexagon_1km_car2go.gid = berlin.hexagon_car2go_area_oa.gid;
DROP TABLE if exists berlin.hexagon_car2go_area_oa ;


--Calculate sales per hexagon
DROP TABLE if exists berlin.hexagon_car2go_sales ;
SELECT berlin.hexagon_1km_car2go.gid, (SUM(germany.routes.sales))/31 as sum_sales_day 
INTO berlin.hexagon_car2go_sales
 FROM berlin.hexagon_1km_car2go, germany.routes
 WHERE ST_Within(germany.routes.geom_start,berlin.hexagon_1km_car2go.geom) AND germany.routes.city = 'Berlin'
 GROUP BY berlin.hexagon_1km_car2go.gid ;
 
--Add column with size of operating area for each hexagon
ALTER TABLE berlin.hexagon_1km_car2go DROP COLUMN if exists sum_sales_day ;
ALTER TABLE berlin.hexagon_1km_car2go ADD COLUMN sum_sales_day double precision;

UPDATE berlin.hexagon_1km_car2go SET sum_sales_day = berlin.hexagon_car2go_sales.sum_sales_day FROM berlin.hexagon_car2go_sales 
WHERE berlin.hexagon_1km_car2go.gid = berlin.hexagon_car2go_sales.gid;
DROP TABLE if exists berlin.hexagon_car2go_sales ;



--Create table with number of restaurants per hexagon
SELECT berlin.hexagon_1km_car2go.gid, count(osm.germany_osm_point.*) as count_restaurant
INTO berlin.hexagon_car2go_restaurant
 FROM berlin.hexagon_1km_car2go, osm.germany_osm_point
 WHERE ST_Within(osm.germany_osm_point.geom_25832, berlin.hexagon_1km_car2go.geom) AND osm.germany_osm_point.amenity ='restaurant'
 GROUP BY berlin.hexagon_1km_car2go.gid;


--Add column with number of restaurants (from OSM)
ALTER TABLE berlin.hexagon_1km_car2go DROP COLUMN if exists count_restaurant ;
ALTER TABLE berlin.hexagon_1km_car2go ADD COLUMN count_restaurant integer;

UPDATE berlin.hexagon_1km_car2go SET count_restaurant = berlin.hexagon_car2go_restaurant.count_restaurant FROM berlin.hexagon_car2go_restaurant
WHERE berlin.hexagon_1km_car2go.gid = berlin.hexagon_car2go_restaurant.gid;
DROP TABLE if exists berlin.hexagon_car2go_restaurant ;

--Create table with number of cafes per hexagon
SELECT berlin.hexagon_1km_car2go.gid, count(osm.germany_osm_point.*) as count_cafe
INTO berlin.hexagon_car2go_cafe
 FROM berlin.hexagon_1km_car2go, osm.germany_osm_point
 WHERE ST_Within(osm.germany_osm_point.geom_25832, berlin.hexagon_1km_car2go.geom) AND osm.germany_osm_point.amenity ='cafe'
 GROUP BY berlin.hexagon_1km_car2go.gid;


--Add column with number of cafes (from OSM)
ALTER TABLE berlin.hexagon_1km_car2go DROP COLUMN if exists count_cafe ;
ALTER TABLE berlin.hexagon_1km_car2go ADD COLUMN count_cafe integer;

UPDATE berlin.hexagon_1km_car2go SET count_cafe = berlin.hexagon_car2go_cafe.count_cafe FROM berlin.hexagon_car2go_cafe
WHERE berlin.hexagon_1km_car2go.gid = berlin.hexagon_car2go_cafe.gid;
DROP TABLE if exists berlin.hexagon_car2go_cafe ;

--Create table with number of car_sharings per hexagon
SELECT berlin.hexagon_1km_car2go.gid, count(osm.germany_osm_point.*) as count_car_sharing
INTO berlin.hexagon_car2go_car_sharing
 FROM berlin.hexagon_1km_car2go, osm.germany_osm_point
 WHERE ST_Within(osm.germany_osm_point.geom_25832, berlin.hexagon_1km_car2go.geom) AND osm.germany_osm_point.amenity ='car_sharing'
 GROUP BY berlin.hexagon_1km_car2go.gid;


--Add column with number of car_sharings (from OSM)
ALTER TABLE berlin.hexagon_1km_car2go DROP COLUMN if exists count_car_sharing ;
ALTER TABLE berlin.hexagon_1km_car2go ADD COLUMN count_car_sharing integer;

UPDATE berlin.hexagon_1km_car2go SET count_car_sharing = berlin.hexagon_car2go_car_sharing.count_car_sharing FROM berlin.hexagon_car2go_car_sharing
WHERE berlin.hexagon_1km_car2go.gid = berlin.hexagon_car2go_car_sharing.gid;
DROP TABLE if exists berlin.hexagon_car2go_car_sharing ;



COPY(SELECT * FROM berlin.hexagon_1km_car2go )
 TO '/tmp/hexagon_car2go.csv' DELIMITER ';' CSV HEADER;







