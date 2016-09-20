
# Table of Contents
* [OSM data](#OSM_data)
* [Operating Area](#Operating_Area)


# OSM data <a id="OSM_data"></a>

##Import OSM data to a PostgreSQL database
### Option 1: osm2pgsql
Note: this is the preferred options, since most of the scripts are based in this data structure
#### Windows

1. Download OSM-data from [Geofabrik](http://download.geofabrik.de/europe/germany.html) in osm.pbf-format (download also a smaller dataset, e.g. Berlin, to test the import, otherwise it will be a bit time consuming)
2. Install Osm2pgsql following this instruction: [http://wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/Osm2pgsql#Windows)
3. To add some important columns to default settings, open default.style and add following lines at line ~150
```
...
node,way   capacity     text         linear
node,way   iata         text         linear
node,way   passengers   text         linear
```
4. Create new database if required, create new extension 'postgis' and 'hstore'
5. Run cmd, change directory to osm2pgsql and import osm.pbf-file via commandline (like this:

```osm2pgsql --create --slim --cache 1000 --number-processes 2 --hstore --multi-geometry berlin-latest.osm.pbf -d osm -U postgres -H localhost -S default.style -W --prefix berlin_osm```

6. After import you can change the schema of the tables with following script:[Set_Schema_OSM.sql](PostgreSQL/Set_Schema_OSM.sql)

Fore more infos about all options click [here](http://www.volkerschatz.com/net/osm/osm2pgsql-usage.html).

Some links for help:
* [https://switch2osm.org](https://switch2osm.org/loading-osm-data/)
* [http://wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/DE:Ajoessen/Postgis)

### Linux

## Option 2: Shapefile-Import

1.  Download OSM-Data (e.g from https://mapzen.com/data/metro-extracts/)
2.  [[Import Shapefile into a PostGIS Database]]
3.  Transform projection:

```
ALTER TABLE berlin.osm_point DROP COLUMN if exists geom_25832;
SELECT  AddGeometryColumn(
	'berlin',
	'osm_point',
	'geom_25832',
	25832,
	'POINT'
	,2);

UPDATE berlin.osm_point SET geom_25832 = ST_Transform(geom, 25832);
```

## Option 3: Osmosis
Osmosis provides also a good option to import osm-files. See following [link](http://wiki.openstreetmap.org/wiki/Osmosis/PostGIS_Setup) for installing options. In comparison to osm2pgsql, all tags are written into one column, which have to be read with pgsql.



# Operating Area <a id="Operating_Area"></a>




