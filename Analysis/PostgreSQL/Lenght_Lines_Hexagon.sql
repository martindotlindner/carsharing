--Calculate lenght of lines within each hexagon
SELECT berlin.hexagon_empty.gid, ST_AsText(berlin.hexagon_empty.geom), ST_LENGTH(ST_Intersection(berlin.hexagon_empty.geom, berlin.cycleway_25833.geom))
FROM berlin.hexagon_empty, berlin.cycleway_25833
WHERE ST_Intersects(berlin.hexagon_empty.geom, berlin.cycleway_25833.geom);