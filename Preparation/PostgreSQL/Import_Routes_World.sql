SET datestyle TO German;
DROP TABLE if exists world.routes;
CREATE TABLE world.routes(
	ID serial PRIMARY KEY,
	TIMESTAMPSTART timestamp default NULL,
	TIMESTAMPEND timestamp default NULL,
	PROVIDER character varying,
	VEHICLEID character varying,
	LICENCEPLATE character varying,
	MODEL character varying,
	INNERCLEANLINESS character varying,
	OUTERCLEANLINESS character varying,
	FUELTYPE character varying,
	FUELSTATESTART integer,
	FUELSTATEEND integer,
	CHARGINGONSTART integer,
	CHARGINGONEND integer,
	STREETSTART character varying,
	STREETEND character varying,
	LATITUDESTART double precision,
	LONGITUDESTART double precision,
	LATITUDEEND double precision,
	LONGITUDEEND double precision);
