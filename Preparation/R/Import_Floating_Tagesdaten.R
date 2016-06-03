## Directory festlegen
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Rohdaten/floating/Tagesdaten/")
## Liste mit csv-Dateien erstellen
filenames <- list.files(pattern = "\\.csv$",recursive = TRUE) 
substr(filenames, 0, 10)

## new Filenames
file_new <- paste("utf/", substr(filenames, 0, 10),".csv", sep="")

for (i in 1:length(filenames)){
  ffcs <- read.table(filenames[i],
                     sep=";",
                     dec=",",
                     header = TRUE,
                     na.strings=c("NA","null","null, null",", null"," ","","0,0","0.000000","0.000000, 0.000000",0),
                     quote = "\""
                   #  fill = TRUE
  )


  ffcs <- ffcs[2:20]
  
  ## Disable exponential notation
  options(scipen=15) 
  
  write.table(ffcs,file = file_new[i],
              fileEncoding= "utf8",
              quote=FALSE,
              row.names=FALSE,
              col.names = FALSE,
              sep = ";",
              dec = ".") 
}



print(file_new)
