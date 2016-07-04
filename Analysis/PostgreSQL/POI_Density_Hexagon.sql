-- Calculate sum of POIs ('berlin.osm_point') within each hexagon ('berlin.berlin_hexagon_1km')

DROP TABLE if exists berlin.hexagon_poi_density;
SELECT berlin.berlin_hexagon_1km.gid, ST_AsText(berlin.berlin_hexagon_1km.geom), berlin.berlin_hexagon_1km.geom, count(berlin.osm_point.*) INTO berlin.hexagon_poi_density
 FROM berlin.berlin_hexagon_1km, berlin.osm_point
 WHERE ST_Intersects(ST_Transform(berlin.osm_point.geom, 25833), berlin.berlin_hexagon_1km.geom)
 GROUP BY berlin.berlin_hexagon_1km.gid;

