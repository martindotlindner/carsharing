--Mean speed in km/h
ALTER TABLE germany.routes ADD COLUMN mean_speed double precision;
UPDATE germany.routes SET mean_speed = (distance_m/1000)/(duration_min/60) ;  

DROP INDEX if exists idx_germany_routes_speed;
CREATE INDEX idx_germany_routes_speed ON germany.routes(mean_speed);
