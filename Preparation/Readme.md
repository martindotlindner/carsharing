# Table of Contents

* [Preparation](#Preparation)
* [Import data to PostgreSQL](#Import_Data)  
* [Remove errors and calculate parameters](#Calc_Parameters) 
* [Summarized workflow](#Workflow)


# Preparation of CSV files <a id="Preparation"></a>
Only necessary for raw CSV files from parsing server:  preprocessing of raw CSV files in R with [Import_Floating.R](R/Import_Floating.R) (convert to UTF-8, set NA-strings, fix decimal problems, remove header)


# Import data to PostgreSQL<a id="Import_Data"></a>
## Import FFCS-Data
### Copy CSV files into PostgreSQL
1. Create table in PostgreSQL: [Import_Routes_World.sql](PostgreSQL/Import_Routes_World.sql) 
2. Import all CSV files 
  * if there are multiple files within one directory you can use [Import_CSV_SQL_Query.R](R/Import_CSV_SQL_Query.R)
  * for a single CSV file use a query like this: 
  
'''sql
COPY world.routes (TIMESTAMPSTART, TIMESTAMPEND, PROVIDER, VEHICLEID, LICENCEPLATE, MODEL, INNERCLEANLINESS, OUTERCLEANLINESS, FUELTYPE, FUELSTATESTART, FUELSTATEEND, CHARGINGONSTART, CHARGINGONEND, STREETSTART, STREETEND, LATITUDESTART, LONGITUDESTART, LATITUDEEND, LONGITUDEEND)'''

FROM 'C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Rohdaten/floating/utf/2015-09.csv' NULL AS 'NA' DELIMITER ';' ;
3. Calculate geometry column and gist-indexes: [Add_Geometry_World_Routes.sql](PostgreSQL/Add_Geometry_World_Routes.sql)
4. Create indexes on following columns: timestampstart, timestampend, provider,  to increase performance: [Create_Indexes.sql](PostgreSQL/Create_Indexes.sql)
5. `VACUUM ANALYZE world.routes`

### Reduce area of interest
To reduce computing time, a reduction of your data is recommended. Furthermore, you can use a local spatial reference system, which is suitable for multiple PostGIS-queries.

#### Choice 1 - Germany
1. Import shapefile with boundary of Germany (see [Wiki](https://github.com/martindotlindner/carsharing/wiki/Import-Shapefile-into-a-PostGIS-Database) how to import shapefiles)
2. Select Routes within Germany [Select_Into_Germany_Routes.sql](PostgreSQL/Select_Into_Germany_Routes.sql)

#### Choice 2 - Berlin
1. Select Routes within Berlin [Select_Into_Berlin_Routes.sql](PostgreSQL/Select_Into_Berlin_Routes.sql)


## Optional: Import Operating Areas <a id="Operating_Areas"></a>
1. Download operating areas as kml-files from Car2Go: [operatingarea_car2go.R](Data/R/operatingarea_car2go.R) You need a API-KEY for this (see https://github.com/car2go/openAPI)
2. Import kml-files to PostgreSQL-Database with ogr2ogr: [Add_Operating_Area_kml_with_ogr2ogr.txt](PostgreSQL/Add_Operating_Area_kml_with_ogr2ogr.txt), Change your settings (EPSG-Code, port, dbname, password and filenames)!
3. Change geometry from lines to polygons [OperatingArea_Line_to_Polygon.sql](Preparation/PostgreSQL/OperatingArea_Line_to_Polygon.sql)


# Remove errors and calculate parameters<a id="Calc_Parameters"></a>
1. Create indexes on following columns: timestampstart, timestampend, provider,  to increase performance: [Create_Indexes.sql](PostgreSQL/Create_Indexes.sql) Performe 'Vacuum Analzye' afterwards!
2. Remove errors - Part I: Remove 'Umrüsterfahrten', all trips from 'Multicity' and coordinates < 1 and > 90 (negative coordinates and coordinates above 90 degree leads to errors when calculation geometry with local coordinate reference system) [Remove_Errors_Step1.sql](PostgreSQL/Remove_Errors.sql)
3. Add and calculate geometry columns for trips within Berlin with SRID 25833 [Add_Geometry_Berlin_Routes.sql](PostgreSQL/Add_Geometry_Berlin_Routes.sql)
4. Calculate basic parameters like duration of trip, distance, mean speed, e.g. [Calculate_Parameter.sql](PostgreSQL/Calculate_Parameter.sql)
5. Calculate sales based on the pricing of the providers: [Calculate_Sales.sql](Preparation/PostgreSQL/Calculate_Sales.sql)
6. Remove errors - Part II: Remove trips with unlikly speed or duration [Remove_Errors_Step2.sql](PostgreSQL/Remove_Errors_Step2.sql)
7. Remove errors - Part III: Create query to remove outliers based on in R [Remove_Outliers.R](R/Remove_Outliers.R), run created query afterwards

# Data quality check
## Impact of free reservations from 0:00 - 6:00 o´clock at weekends on duration of trips
1. Run the sql script: [Reservation_Effect.sql](PostgreSQL/Reservation_Effect.sql) (adjust the directory)
2. Import csv-files and create two plots with: [Reservation_Effect.R](R/Reservation_Effect.R)



# Summarized workflow<a id="Workflow"></a>
To execute serval files with psql, you can use this command:

```sql
BEGIN;
\i query1.sql
\i query2.sql
COMMIT;
```

A workflow for preprocessing data for Berlin would be (you have to run [Import_CSV_SQL_Query.R](R/Import_CSV_SQL_Query.R.R) first)

```sql
BEGIN;
\i Import_Routes_World.sql
\i sql_import.sql
\i Add_Geometry_World_Routes.sql
\i Create_Indexes.sql
\i Vacuum_Analzye.sql
\i Select_Into_Berlin_Routes.sql
\i Remove_Errors_Step1.sql
\i Add_Geometry_Berlin_Routes.sql
\i Calculate_Parameter.sql
\i Remove_Errors_Step2.sql
\i Calculate_Sales.sql
COMMIT;
```

A workflow for preprocessing data for Germany would be similar. If you want to add the corresponding city to each trip, you have to [import the operating areas](#Operating_Areas) first.

```sql
BEGIN;
\i Import_Routes_World.sql
\i sql_import.sql
\i Add_Geometry_World_Routes.sql
\i Select_Into_Germany_Routes.sql
\i Remove_Errors_Step1.sql
\i Add_Geometry_Germany_Routes.sql
\i Add_City.sql
\i Calculate_Parameter.sql
\i Remove_Errors_Step2.sql
\i Calculate_Sales.sql
COMMIT;
```

Afterwards, outliers should be removed like [described](#Remove_Errors) above.
