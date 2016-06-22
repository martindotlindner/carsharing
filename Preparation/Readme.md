# Table of Contents

* [Preparation](#Preparation)
* [Import Data to PostgreSQL](#Import_Data)  
* [Remove errors and calculate parameters](#Calc_Parameters) 
* [Summarized workflow](#Workflow)


# Preparation of FFCS-Data <a id="Preparation"></a>
Only necessary for converted csv-files Server:  Preprocessing of raw csv-files in R with [Import_Floating.R](Preparation/R/Import_Floating.R) (convert to UTF-8, set NA-strings, fix decimal problems)


# Import Data to PostgreSQL<a id="Import_Data"></a>
## Import FFCS-Data
### Copy csv files into PostgreSQL
1. Create table in PostgreSQL: [Import_Routes_World.sql](Preparation/PostgreSQL/Import_Routes_World.sql) 
2. Import all csv-files (if there are multiple files within one directory you can use [Import_CSV_SQL_Query.R](Preparation/R/Import_CSV_SQL_Query.R.R)

### Reduce area of interest
To reduce computing time, a reduction of your data is recommended. Furthermore, you can use a local spatial reference system, which is suitable for multiple PostGIS-queries.

#### Choice 1 - Germany
1. Import shapefile with boundary of Germany

 ```
 cd /usr/bin/
 shp2pgsql -s 4326 DEU_adm0.shp germany.border | psql -h localhost -p 5432 -U postgres -d carsharing
 ```
2. Select Routes within Germany [Select_Into_Germany_Routes.sql](Preparation/PostgreSQL/Select_Into_Germany_Routes.sql)

#### Choice 2 - Berlin
1. Select Routes within Berlin [Select_Into_Berlin_Routes.sql](Preparation/PostgreSQL/Select_Into_Berlin_Routes.sql)


## Import Operating Areas <a id="Operating_Areas"></a>
1. Download operating areas as kml-files from Car2Go: [operatingarea_car2go.R](Data/R/operatingarea_car2go.R) You need a API-KEY for this (see https://github.com/car2go/openAPI)
2. Import kml-files to PostgreSQL-Database with ogr2ogr: [Add_Operating_Area_kml_with_ogr2ogr.txt](Preparation/PostgreSQL/Add_Operating_Area_kml_with_ogr2ogr.txt), Change your settings (EPSG-Code, port, dbname, password and filenames)!
3. Change geometry from lines to polygons [OperatingArea_Line_to_Polygon.sql](Preparation/PostgreSQL/OperatingArea_Line_to_Polygon.sql)


# Remove errors and calculate parameters<a id="Calc_Parameters"></a>
1. Remove errors - PartI: Remove 'Umrüsterfahrten', all trips from 'Multicity' and coordinates < 1 (negative coordinates leads to error when calculation geometry with local coordinate reference system) [Remove_Errors_Step1.sql](Preparation/PostgreSQL/Remove_Errors_Step1.sql)
2. Add and calculate geometry column for all data: [Add_Geometry_World_Routes.sql](Preparation/PostgreSQL/Add_Geometry_World_Routes.sql)
3. Add and calculate geometry columns for trips within Berlin with SRID 25833 [Add_Geometry_Berlin_Routes.sql](Preparation/PostgreSQL/Add_Geometry_Berlin_Routes.sql)
4. Calculate basic parameters like duration of trip, distance, mean speed, e.g. [Calculate_Parameter.sql](Preparation/PostgreSQL/Calculate_Parameter.sql)
5. Calculate sales based on the pricing of the providers: [Calculate_Sales.sql](Preparation/PostgreSQL/Calculate_Sales.sql)
6. Remove errors - PartII: Remove trips with unlikly speed or duration [Remove_Errors_Step2.sql](Preparation/PostgreSQL/Remove_Errors_Step2.sql)
7. Remove errors - PartIII: Create query to remove outliers based on in R [Remove_Outliers.R](Preparation/R/Remove_Outliers.R), run created query afterwards


# Summarized workflow<a id="Workflow"></a>
To execute serval files with psql, you can use this command:

```sql
BEGIN;
\i query1.sql
\i query2.sql
COMMIT;
```

A workflow for preprocessing data for Berlin would be (you have to run [Import_CSV_SQL_Query.R](Preparation/R/Import_CSV_SQL_Query.R.R) first)

```sql
BEGIN;
\i Import_Routes_World.sql
\i sql_import.sql
\i Add_Geometry_World_Routes.sql
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
