-- Add column with city based on coordinates of cities from Wikipedia
-- set correct SRID for xy of cities(same like geom_start)

ALTER TABLE germany.routes DROP COLUMN if exists city;
ALTER TABLE germany.routes ADD COLUMN city character varying;

UPDATE germany.routes SET city = 'Berlin'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(13.408333 52.518611)', 4326),25832), 30000);

UPDATE germany.routes SET city = 'Muenchen'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(11.575556 48.137222)', 4326),25832), 30000);

UPDATE germany.routes SET city = 'Hamburg'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(9.993333 53.550556)', 4326),25832), 30000);

UPDATE germany.routes SET city = 'Frankfurt'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(8.682222 50.110556)', 4326),25832), 30000);

UPDATE germany.routes SET city = 'Stuttgart'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(9.182778 48.775556)', 4326),25832), 30000);

UPDATE germany.routes SET city = 'Koeln'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(6.956944 50.938056)', 4326),25832), 15000);

UPDATE germany.routes SET city = 'Duesseldorf'
WHERE ST_DWithin(germany.routes.geom_start, ST_Transform(ST_GeomFromText('POINT(6.782778 51.225556)', 4326),25832), 15000);

DROP INDEX if exists germany.idx_germany_routes_city;
CREATE INDEX idx_germany_routes_city ON germany.routes(city);
