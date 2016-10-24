-- Removing all trips with duration < 4min (to remove unplausible trips and to avoid division by zero afterwars)
DELETE FROM germany.routes WHERE duration_min < 4;

-- Removing all trips with mean speed > 100km/h
DELETE FROM germany.routes WHERE mean_speed > 100 ;
