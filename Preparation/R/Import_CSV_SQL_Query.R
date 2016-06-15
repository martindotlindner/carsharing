## Set Directory
setwd("C:/Users/xxx/utf")

## Create list with csv-files
filenames <- list.files(pattern = "\\.csv$") 
sql_import <- matrix(ncol=1,nrow=length(filenames))

for (i in 1:length(filenames)){
sql_import[i] <- paste0("COPY world.routes (TIMESTAMPSTART, TIMESTAMPEND, PROVIDER, VEHICLEID, LICENCEPLATE, MODEL, INNERCLEANLINESS, OUTERCLEANLINESS, FUELTYPE, FUELSTATESTART, FUELSTATEEND, CHARGINGONSTART, CHARGINGONEND, STREETSTART, STREETEND, LATITUDESTART, LONGITUDESTART, LATITUDEEND, LONGITUDEEND)
FROM 'C:/Users/xxx/utf/",filenames[i], "' NULL AS 'NA' DELIMITER ';' ;")
}
# Create sql-query
write.table(sql_import, 
            "sql_import.sql",
            quote=FALSE,
            row.names=FALSE,
            col.names = FALSE)
