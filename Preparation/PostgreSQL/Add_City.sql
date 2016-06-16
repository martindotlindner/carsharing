-- Add column with city based on spatial query with operating area from Drivenow
-- Import shapefiles with operating area of each city first
ALTER TABLE world.routes ADD COLUMN city character varying;
UPDATE world.routes SET city = CASE
   WHEN ST_DWithin(world.routes.geom::geography, world.muenchen.geom::geography, 10000) THEN 'Muenchen'
   WHEN ST_DWithin(world.routes.geom::geography, world.berlin.geom::geography, 5000) THEN 'Berlin'
   WHEN ST_DWithin(world.routes.geom::geography, world.duesseldorf.geom::geography, 10000) THEN 'Duesseldorf'
   WHEN ST_DWithin(world.routes.geom::geography, world.hamburg.geom::geography, 5000) THEN 'Hamburg'
   WHEN ST_DWithin(world.routes.geom::geography, world.koeln.geom::geography, 10000) THEN 'Koeln'
   ELSE 'unknown'
END
FROM world.muenchen WHERE ST_DWithin(world.routes.geom::geography, world.muenchen.geom::geography, 10000);
;

