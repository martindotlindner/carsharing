library(RPostgreSQL)

# Establish connection to PoststgreSQL using RPostgreSQL
drv <- dbDriver("PostgreSQL")

# Connection settings
con <- dbConnect(drv, dbname="Carsharing",host="localhost",port=5432,user="postgres",password="MuC4ever!" )

dbExistsTable(con, c("germany", "routes"))
starts <- dbReadTable(con, c("germany", "routes"))

head(starts)


# Close PostgreSQL connection 
dbDisconnect(con)
