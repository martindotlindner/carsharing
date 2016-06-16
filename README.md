
# Table of Contents
* [First Steps with PostgreSQL](#First_Steps)
* [Preparation of FFCS-Data](#Preparation)
  * [Import Data](#Import_Data)  
  * [Calculate Parameters](#Calc_Parameters) 
  * [Remove Errors](#Remove_Errors) 
* [Analysis of FFCS-Data](#Analysis)
* 




# First Steps with PostgreSQL <a id="First_Steps"></a>

# Preparation of FFCS-Data <a id="Preparation"></a>
Only necessary for converted csv-files Server:  Preprocessing of raw csv-files in R with [Import_Floating.R](Preparation/R/Import_Floating.R) (convert to UTF-8, set NA-strings, fix decimal problems)



## Import Data <a id="Import_Data"></a>
1. Create table in PostgreSQL: [Import_Routes_World.sql](Preparation/PostgreSQL/Import_Routes_World.sql) 
2. Import all csv-files (if there are multiple files within one directory you can use [Import_CSV_SQL_Query.R](Preparation/R/Import_CSV_SQL_Query.R.R)





## Create Parameter <a id="Calc_Parameters"></a>
1. Add and calculate geometry column for all data: [Add_Geometry_World_Routes.sql](Preparation/PostgreSQL/Add_Geometry_World_Routes.sql)
2. Select Routes within Berlin [Select_Into_Berlin_Routes.sql](Preparation/PostgreSQL/Select_Into_Berlin_Routes.sql)
3. Add and calculate geometry columns for trips within Berlin with SRID 25833 [Add_Geometry_Berlin_Routes.sql](Preparation/PostgreSQL/Add_Geometry_Berlin_Routes.sql)
4. Calculate basic parameters like duration of trip, distance, mean speed, e.g. [Calculate_Parameter.sql](Preparation/PostgreSQL/Calculate_Parameter.sql)
5. Calculate sales based on the pricing of the providers: [Calculate_Sales.sql](Preparation/PostgreSQL/Calculate_Sales.sql)


## Remove Errors <a id="Remove_Errors"></a>
1. Remove errors - PartI: Remove 'Umrüsterfahrten', all trips from 'Multicity', trips with unlikly speed or duration [Remove_Errors.sql](Preparation/PostgreSQL/Remove_Errors.sql)
2. Remove errors - PartII: Create query to remove outliers based on in R [Remove_Outliers.R](Preparation/R/Remove_Outliers.R), run created query afterwards

To execute serval files with psql, you can use this command:

```sql
BEGIN;
\i Import_Routes_World.sql
\i sql_import.sql
\i Add_Geometry_World_Routes.sql
\i Select_Into_Berlin_Routes.sql
\i Add_Geometry_Berlin_Routes.sql
COMMIT;
```

# Analysis of FFCS-Data <a id="Analysis"></a>

