--Select hexagons which intersects with operating area into new table

SELECT germany.berlin_hexagon_1km.*,ST_AsText(germany.berlin_hexagon_1km.geom) INTO berlin.hexagon_1km_car2go FROM germany.berlin_hexagon_1km, germany.berlin_oa_car2go WHERE
ST_Intersects(germany.berlin_hexagon_1km.geom, germany.berlin_oa_car2go.geom_poly_25832) AND germany.berlin_oa_car2go.zoneType = 'included' ;

--Calculate sales per hexagon
COPY(
SELECT berlin.hexagon_1km_car2go.gid, (SUM(germany.routes.sales))/31 as sum_sales_day
 FROM berlin.hexagon_1km_car2go, germany.routes
 WHERE ST_Within(germany.routes.geom_start,berlin.hexagon_1km_car2go.geom) AND germany.routes.city = 'Berlin'
 GROUP BY berlin.hexagon_1km_car2go.gid)
 TO '/tmp/hexagon_oa_sales.csv' DELIMITER ';' CSV HEADER;

--Calculate proportinal operating area for each hexagon (partly coverage at the boundery)


COPY(
SELECT berlin.hexagon_1km_car2go.gid,
SUM(ST_Area(ST_Intersection(germany.berlin_oa_car2go.geom_poly_25832,berlin.hexagon_1km_car2go.geom))/1000000) AS area
FROM berlin.hexagon_1km_car2go, germany.berlin_oa_car2go
WHERE ST_Intersects(germany.berlin_oa_car2go.geom_poly_25832,berlin.hexagon_1km_car2go.geom) AND germany.berlin_oa_car2go.zoneType = 'included'
GROUP BY berlin.hexagon_1km_car2go.gid )
 TO '/tmp/hexagon_oa_car2go_anteil.csv' DELIMITER ';' CSV HEADER;



