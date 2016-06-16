## Directory festlegen
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Rohdaten/floating/")
## Liste mit csv-Dateien erstellen
filenames <- list.files(pattern = "\\.csv$") 

## new Filenames
file_new <- paste("utf/", filenames, sep="")

for (i in 1:6){
  ffcs <- read.table(filenames[6],
                     sep=";",
                     dec=",",
                     header = TRUE,
                     na.strings=c("NA","null","null, null",", null"," ","","0,0","0.000000","0.000000, 0.000000",0),
                     quote = "\"",
                     fill = TRUE
  )

  ffcs <- ffcs[2:20]
  
  ## Disable exponential notation
  options(scipen=15) 
  
  write.table(ffcs,file = file_new[4],
              fileEncoding= "utf8",
              quote=FALSE,
              row.names=FALSE,
              col.names = FALSE,
              sep = ";",
              dec = ".") 
}



## Read Data with coordinate problems
for (i in 7:length(filenames)){
ffcs <- read.table(filenames[23],
                   sep=";",
                   dec=",",
                   header = TRUE,
                   na.strings=c("NA","null","null, null",", null"," ","","0,0","0.000000","0.000000, 0.000000",0),
                   quote = "\"",
                   stringsAsFactors = FALSE,
                   fill = TRUE)

ffcs$LATITUDESTART <- as.numeric(sub(",",".",ffcs$LATITUDESTART, fixed = TRUE))
ffcs$LATITUDEEND <- as.numeric(sub(",",".",ffcs$LATITUDEEND, fixed = TRUE))
ffcs$LONGITUDESTART <- as.numeric(sub(",",".",ffcs$LONGITUDESTART, fixed = TRUE))
ffcs$LONGITUDEEND <- as.numeric(sub(",",".",ffcs$LONGITUDEEND, fixed = TRUE))
ffcs <- ffcs[2:20]

ffcs <- ffcs[!ffcs$TIMESTAMPSTART %in% c("TIMESTAMPEND"),]


## Disable exponential notation
options(scipen=15) 

write.table(ffcs_rm,file = file_new[i],
            fileEncoding= "utf8",
            quote=FALSE,
            row.names=FALSE,
            col.names = FALSE,
            sep = ";",
            dec = ".") 
}

