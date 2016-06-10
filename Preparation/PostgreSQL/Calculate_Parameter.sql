-- Calculate important parameters:


--Duration of booking (as interval):
ALTER TABLE berlin.routes ADD COLUMN duration interval;
UPDATE berlin.routes SET duration =  TIMESTAMPEND - TIMESTAMPSTART ;
    
--Duration in hours:
ALTER TABLE berlin.routes ADD COLUMN duration_h double precision;
UPDATE berlin.routes SET duration_h = EXTRACT(epoch FROM duration)/3600 ;

--Distance in meters (rounded to two decimal places, column 'geom' have to be LINESTRING
ALTER TABLE berlin.routes ADD COLUMN distance double precision;
UPDATE berlin.routes SET distance = ROUND(ST_Length(geom)::numeric,2) ;

--Mean speed in km/h
ALTER TABLE berlin.routes ADD COLUMN mean_speed double precision;
UPDATE berlin.routes SET mean_speed = (distance/1000)/duration_h ; 