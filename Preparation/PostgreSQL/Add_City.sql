-- Add column with city based on spatial query with operating area from Drivenow
-- Import shapefiles with operating area of each city first
ALTER TABLE germany.routes ADD COLUMN city character varying;
UPDATE germany.routes SET city = CASE
   WHEN ST_DWithin(germany.routes.geom::geography, germany.muenchen_oa_poly.wkb_geometry::geography, 10000) THEN 'Muenchen'
   WHEN ST_DWithin(germany.routes.geom::geography, germany.berlin_oa_poly.wkb_geometry::geography, 5000) THEN 'Berlin'
   WHEN ST_DWithin(germany.routes.geom::geography, germany.rheinland_oa_poly.wkb_geometry::geography, 10000) THEN 'Rheinland'
   WHEN ST_DWithin(germany.routes.geom::geography, germany.hamburg_oa_poly.wkb_geometry::geography, 10000) THEN 'Hamburg'
   WHEN ST_DWithin(germany.routes.geom::geography, germany.frankfurt_oa_poly.wkb_geometry::geography, 10000) THEN 'Frankfurt'
   WHEN ST_DWithin(germany.routes.geom::geography, germany.stuttgart_oa_poly.wkb_geometry::geography, 10000) THEN 'Stuttgart'
   ELSE 'unknown'
END
FROM germany.muenchen_oa_poly, germany.berlin_oa_poly, germany.rheinland_oa_poly, germany.hamburg_oa_poly, germany.frankfurt_oa_poly, germany.stuttgart_oa_poly;

