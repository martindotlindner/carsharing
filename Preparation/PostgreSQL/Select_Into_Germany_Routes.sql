DROP TABLE if exists germany.routes ;
SELECT world.routes.* INTO germany.routes FROM world.routes, germany.border WHERE ST_DWithin(world.routes.geom::geography, ST_MakePolygon(ST_GeomFromText('LINESTRING(6 55, 15 55, 15 47.5, 6 47.5,6 55)')) ,1000);
