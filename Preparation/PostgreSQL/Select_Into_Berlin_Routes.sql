CREATE SCHEMA if not exists berlin;
DROP TABLE if exists berlin.routes ;

-- Create two tables, on with important columns (germany.routes) and one with rarely used information (germany.routes_meta)
SELECT ID, TIMESTAMPSTART, TIMESTAMPEND, PROVIDER, VEHICLEID, LATITUDESTART, LONGITUDESTART, LATITUDEEND, LONGITUDEEND INTO berlin.routes 
FROM world.routes WHERE ST_DWithin(geom::geography, ST_GeomFromText('POINT(13.33 52.52)', 4326)::geography, 100000);

SELECT ID, LICENCEPLATE, MODEL, INNERCLEANLINESS, OUTERCLEANLINESS, FUELTYPE, FUELSTATESTART, FUELSTATEEND, CHARGINGONSTART, CHARGINGONEND, STREETSTART, STREETEND) INTO berlin.routes_meta
FROM world.routes WHERE ST_DWithin(geom::geography, ST_GeomFromText('POINT(13.33 52.52)', 4326)::geography, 100000);
