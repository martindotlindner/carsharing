-- For Berlin
/*
-- Drop all trips from Multicity
DELETE FROM berlin.routes
WHERE provider = 'MULTICITY';

-- Drop 'Umrüsterfahrten'

DELETE FROM berlin.routes
WHERE streetstart = 'Umrüster DE' OR streetend = 'Umrüster DE' ;

DELETE FROM berlin.routes
WHERE latitudestart < 1 OR longitudestart < 1 OR latitudeend < 1 OR latitudeend < 1;

*/

-- For Germany

-- Drop all trips from Multicity
DELETE FROM germany.routes
WHERE provider = 'MULTICITY';

-- Drop 'Umrüsterfahrten'

DELETE FROM germany.routes
WHERE streetstart = 'Umrüster DE' OR streetend = 'Umrüster DE' ;

DELETE FROM germany.routes
WHERE latitudestart < 1 OR longitudestart < 1 OR latitudeend < 1 OR latitudeend < 1;
