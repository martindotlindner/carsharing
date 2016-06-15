
# Table of Contents
* [First Steps with PostgreSQL](#First_Steps)
* [Preparation of FFCS-Data](#Preparation)
  * [Import Data](#Import_Data)  
  * [Remove Errors](#Remove_Errors) 
  * [Calculate Parameters](#Calc_Parameters) 
* [Analysis of FFCS-Data](#Analysis)
* 




# First Steps with PostgreSQL <a id="First_Steps"></a>

# Preparation of FFCS-Data <a id="Preparation"></a>
Only necessary for converted csv-files Server:  Preprocessing of raw csv-files in R with [Import_Floating.R](Preparation/R/Import_Floating.R) (convert to UTF-8, set NA-strings, fix decimal problems)



## Import Data <a id="Import_Data"></a>
1. Create table in PostgreSQL: [Import_Routes_World.sql](Preparation/PostgreSQL/Import_Routes_World.sql) 
2. Import all csv-files (if there are multiple files within one directory you can use [Import_CSV_SQL_Query.R](Preparation/R/Import_CSV_SQL_Query.R.R)
3. Add and calculate geometry column: [Add_Geometry_World_Routes.sql](PostgreSQL/Add_Geometry_World_Routes.sql)


## Remove Errors <a id="Remove_Errors"></a>

## Create Parameter <a id="Calc_Parameters"></a>

To execute serval files with psql, you can use this command:

```sql
BEGIN;
\i Import_Routes_World.sql
\i sql_import.sql
\i Add_Geometry_World_Routes.sql
COMMIT;
```

# Analysis of FFCS-Data <a id="Analysis"></a>

