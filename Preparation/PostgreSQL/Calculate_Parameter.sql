-- Calculate important parameters:

-- For Berlin
/*
--Duration of booking (as interval):
ALTER TABLE berlin.routes ADD COLUMN duration interval;
UPDATE berlin.routes SET duration =  TIMESTAMPEND - TIMESTAMPSTART ;

-- Create index
CREATE INDEX idx_berlin_routes_duration ON berlin.routes(duration);

-- Removing all trips with duration < 4min (to remove unplausible trips and to avoid division by zero afterwars)
DELETE FROM berlin.routes WHERE duration < Interval '00:04:00';
    
--Duration in hours:
-- ALTER TABLE berlin.routes ADD COLUMN duration_h double precision;
-- UPDATE berlin.routes SET duration_h = EXTRACT(epoch FROM duration)/3600 ;

--Duration in min:
-- ALTER TABLE berlin.routes ADD COLUMN duration_min double precision;
-- UPDATE berlin.routes SET duration_min = EXTRACT(epoch FROM duration)/60 ;

--Distance in meters (rounded to two decimal places, column 'geom' have to be LINESTRING
ALTER TABLE berlin.routes ADD COLUMN distance double precision;
UPDATE berlin.routes SET distance = ROUND(ST_Length(geom)::numeric,2) ;

--Mean speed in km/h
ALTER TABLE berlin.routes ADD COLUMN mean_speed double precision;
UPDATE berlin.routes SET mean_speed = (distance/1000)/(EXTRACT(epoch FROM duration)/3600) ;  

CREATE INDEX idx_berlin_routes_speed ON berlin.routes(mean_speed)

DELETE FROM berlin.routes WHERE mean_speed > 100 ;
*/

-- For Germany

--Duration of booking (as interval):
ALTER TABLE germany.routes ADD COLUMN duration interval;
UPDATE germany.routes SET duration =  TIMESTAMPEND - TIMESTAMPSTART ;

-- Create index
CREATE INDEX idx_germany_routes_duration ON germany.routes(duration);

-- Removing all trips with duration < 4min (to remove unplausible trips and to avoid division by zero afterwars)
DELETE FROM germany.routes WHERE duration < Interval '00:04:00';
    
--Duration in hours:
-- ALTER TABLE germany.routes ADD COLUMN duration_h double precision;
-- UPDATE germany.routes SET duration_h = EXTRACT(epoch FROM duration)/3600 ;

--Duration in min:
-- ALTER TABLE germany.routes ADD COLUMN duration_min double precision;
-- UPDATE germany.routes SET duration_min = EXTRACT(epoch FROM duration)/60 ;

--Distance in meters (rounded to two decimal places, column 'geom' have to be LINESTRING
ALTER TABLE germany.routes ADD COLUMN distance double precision;
UPDATE germany.routes SET distance = ROUND(ST_Length(geom)::numeric,2) ;

--Mean speed in km/h
ALTER TABLE germany.routes ADD COLUMN mean_speed double precision;
UPDATE germany.routes SET mean_speed = (distance/1000)/(EXTRACT(epoch FROM duration)/3600) ;  

CREATE INDEX idx_germany_routes_speed ON germany.routes(mean_speed);

DELETE FROM germany.routes WHERE mean_speed > 100 ;