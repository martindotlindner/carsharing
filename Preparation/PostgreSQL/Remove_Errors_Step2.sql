--Drop all trips with mean speed > 100km/h and duration < 4min

DELETE FROM berlin.routes
WHERE mean_speed > 100 OR duration < Interval '00:04:00';