-- Select all columns to new table
CREATE SCHEMA if not exists germany ;
DROP TABLE if exists germany.routes ;
SELECT world.routes.* INTO germany.routes FROM world.routes WHERE ST_DWithin(world.routes.geom_start::geography, ST_MakePolygon(ST_GeomFromText('LINESTRING(6 55, 15 55, 15 47.5, 6 47.5,6 55)')) ,1000);

-- Create two tables, on with important columns (germany.routes) and one with rarely used information (germany.routes_meta)
/* 
DROP TABLE if exists germany.routes_info ;
SELECT ID, TIMESTAMPSTART, TIMESTAMPEND, PROVIDER, VEHICLEID, LATITUDESTART, LONGITUDESTART, LATITUDEEND, LONGITUDEEND
INTO germany.routes_info FROM world.routes WHERE ST_DWithin(world.routes.geom::geography, ST_MakePolygon(ST_GeomFromText('LINESTRING(6 55, 15 55, 15 47.5, 6 47.5,6 55)')) ,1000);
 
DROP TABLE if exists germany.routes_meta ;
SELECT ID, LICENCEPLATE, MODEL, INNERCLEANLINESS, OUTERCLEANLINESS, FUELTYPE, FUELSTATESTART, FUELSTATEEND, CHARGINGONSTART, CHARGINGONEND, STREETSTART, STREETEND
INTO germany.routes_meta FROM world.routes WHERE ST_DWithin(world.routes.geom::geography, ST_MakePolygon(ST_GeomFromText('LINESTRING(6 55, 15 55, 15 47.5, 6 47.5,6 55)')) ,1000);
*/
