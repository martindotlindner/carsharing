-- For Berlin
/*
-- Drop all trips from Multicity
DELETE FROM berlin.routes
WHERE provider = 'MULTICITY';

-- Drop 'Umrüsterfahrten'

DELETE FROM berlin.routes
WHERE streetstart = 'Umrüster DE' OR streetend = 'Umrüster DE' ;

DELETE FROM berlin.routes
WHERE latitudestart < 1 OR longitudestart < 1 OR latitudeend < 1 OR longitudeend < 1 OR
latitudestart > 90 OR longitudestart > 90 OR latitudeend > 90 OR longitudeend > 90;

*/

-- For Germany

-- Drop all trips from Multicity
DELETE FROM germany.routes
WHERE provider = 'MULTICITY';

--Remove records with wrong geometry
DELETE FROM germany.routes
WHERE latitudestart < 1 OR longitudestart < 1 OR latitudeend < 1 OR longitudeend < 1 OR
latitudestart > 90 OR longitudestart > 90 OR latitudeend > 90 OR longitudeend > 90;
