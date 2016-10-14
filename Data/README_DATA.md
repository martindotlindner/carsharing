
# Table of Contents
* [Geocoding](#Geocoding)
* [OSM data](#OSM_data)
* [Operating Area](#Operating_Area)

# Geocoding <a id="Geocoding"></a>
## Getting formatted data with place name
Prerequisite for geocoding record is the presence of a place name like an address and a readable formatting of the table. 

###  Example 1: Shopping Malls in Berlin
1. Download [pdf](https://www.ihk-berlin.de/blob/bihk24/produktmarken/branchen/handel/2271598/e7e05a510e6f1cf8431c84d2e9ca20f8/Shoppingcenter_Berlin-data.pdf) 
2. Convert pdf to csv with a tool like https://pdftables.com/ or http://tabula.technology/
3. Manual editing to get clear table with name, adress, shopping area...
4. Save as csv-file

###  Example 2: Airports in Germany
1. Download [xlxs](https://www.destatis.de/DE/Publikationen/Thematisch/TransportVerkehr/Luftverkehr/Luftverkehr2080600161065.xlsx?__blob=publicationFile) from the [Federal Statistical Office](https://www.destatis.de/DE/Publikationen/Thematisch/TransportVerkehr/Luftverkehr/Luftverkehr.html)
2. Copy required information (e.g. table 1.1.2) to new sheet
3. Manual editing header if necessary
4. Save as csv-file

##Geocoding adresses with a Google Maps API in R
To get xy-coordinates from an address, you can make use of Google Maps API. There are a couple of ways to integrate this API in R, for example [ggmaps](https://cran.r-project.org/web/packages/ggmap/index.html).

Here is a code example for geocoding shopping malls in Berlin: [Geocoding_Addresses_ggmap.R](R/Geocoding_Addresses_ggmap.R)
Here is a code example for geocoding airports in Germany: [Geocoding_Airports_ggmap.R](R/Geocoding_Airports_ggmap.R)

Note that the free version of Google Maps Geocoding API is limited to 2500 requests per day!

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

    ```
    osm2pgsql --create --slim --cache 1000 --number-processes 2 --hstore --multi-geometry berlin-latest.osm.pbf -d osm -U           postgres -H localhost -S default.style -W --prefix berlin_osm
    ```

6. After import you can change the schema of the tables with following script: [Set_Schema_OSM.sql](PostgreSQL/Set_Schema_OSM.sql)

Fore more infos about all options click [here](http://www.volkerschatz.com/net/osm/osm2pgsql-usage.html).

Some links for help:
* [https://switch2osm.org](https://switch2osm.org/loading-osm-data/)
* [http://wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/DE:Ajoessen/Postgis)

### Linux
1. Download OSM-data from [Geofabrik](http://download.geofabrik.de/europe/germany.html) in osm.pbf-format via Terminal

    ```
    wget "http://download.geofabrik.de/europe/germany-latest.osm.pbf"
    ```

2. Install osm2pgsql (further information: [http://wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/Osm2pgsql#For_Debian_or_Ubuntu)):

    ```
    apt-get install osm2pgsql
    ```
3. To add some important columns to default settings, open default.style and add following lines at line ~150

    ```
    ...
    node,way   capacity     text         linear
    node,way   iata         text         linear
    node,way   passengers   text         linear
    ```

4. Create new database if required, create new extension 'postgis' and 'hstore'
In psql: ```CREATE EXTENSION hstore```

In Terminal: ```psql -d carsharing -c 'create extension hstore;```

5. Execute osm2pgsql command (customize parameters)

    ```
    osm2pgsql --create --slim --cache 4000 --number-processes 2 --hstore --multi-geometry /home/martinlindner/Data/Geodata    /OSM/germany-latest.osm.pbf -d carsharing -U martinlindner -H localhost -S /usr/share/osm2pgsql/default.style -W --prefix     germany_osm
    ```

6. Wait about 25 hours 

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

## Import Operating Areas
1. Download operating areas as kml-files from Car2Go: [operatingarea_car2go.R](Data/R/operatingarea_car2go.R) You need a API-KEY for this (see https://github.com/car2go/openAPI)
2. Import kml-files to PostgreSQL-Database with ogr2ogr: [Add_Operating_Area_kml_with_ogr2ogr.txt](PostgreSQL/Add_Operating_Area_kml_with_ogr2ogr.txt), Change your settings (EPSG-Code, port, dbname, password and filenames)!
3. Change geometry from lines to polygons [OperatingArea_Line_to_Polygon.sql](PostgreSQL/OperatingArea_Line_to_Polygon.sql)



