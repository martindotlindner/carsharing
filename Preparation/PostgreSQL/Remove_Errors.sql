-- Drop all trips from Multicity
DELETE FROM berlin.routes
WHERE provider = 'MULTICITY';


-- Drop 'Umrüsterfahrten'

DELETE FROM berlin.routes
WHERE streetstart = 'Umrüster DE' OR streetend = 'Umrüster DE' ;

--Drop all trips with mean speed > 100km/h and duration < 4min

DELETE FROM berlin.routes
WHERE mean_speed > 100 OR duration < Interval '00:04:00';