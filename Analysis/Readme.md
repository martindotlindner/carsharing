# Table of Contents

* [Impact of transformation of the operating area](#Changes)
* [Import Data to PostgreSQL](#Import_Data)  



#  Impact of transformation of the operating area<a id="Changes"></a>

## Create matrix with start-end-relationship

1. Create hexagon shapefile in QGIS (see wiki article *Create Hexagons with QGIS*) with required size and import it into PostgreSQL database
2. Set hexagon ID for start and end for each trip and export the result grouped by hexagon id´s as csv with [Hexagon_Matrix_Start_End.sql](Analysis/PostgreSQL/Hexagon_Matrix_Start_End.sql). Modify table name of hexagons and schema if necessary!
3. Import csv to R and create matrix with [Hexagon_Matrix_Start_End.R](Analysis/R/Hexagon_Matrix_Start_End.R)
4. 

## Calculate shortest distance between grid points and vehicles
1. Create grid points in QGIS
2. Calculate shortest distance (really timeconsuming!): [Nearest_Neighbour.sql](Analysis/PostgreSQL/Nearest_Neighbour.sql)

 
