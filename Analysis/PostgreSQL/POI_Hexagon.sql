

COPY(
SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), count(*)
 FROM berlin.hexagon_1km, berlin.osm_poi
 WHERE ST_Within(berlin.osm_poi.geom_25833,berlin.hexagon_1km.geom) AND berlin.osm_poi.amenity = 'restaurant'
 GROUP BY berlin.hexagon_1km.gid)
 TO '/tmp/POI_Restaurant_Hexagon.csv' (format csv);