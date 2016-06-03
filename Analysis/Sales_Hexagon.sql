COPY(
SELECT berlin.hexagon_1km.gid, ST_AsText(berlin.hexagon_1km.geom), SUM(berlin.routes.sales)
 FROM berlin.hexagon_1km, berlin.routes
 WHERE ST_Within(berlin.routes.geom_start,berlin.hexagon_1km.geom)
 GROUP BY berlin.hexagon_1km.gid)
 TO '/tmp/sales_starts_hexagon.csv' (format csv);
