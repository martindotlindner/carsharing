DROP TABLE if exists germany.routes ;
SELECT world.routes.* INTO germany.routes FROM world.routes, germany.border WHERE ST_DWithin(world.routes.geom::geography, germany.border.geom::geography,1000);