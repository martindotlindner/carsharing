
## Directory festlegen
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Rohdaten/floating/")

## Import von Datei 13-11_a.csv
ffcs <- read.table("Problem/13-11_a.csv",
                     sep=";",
                     dec=".",
                     header = TRUE,
                     na.strings=c("NA","null","null, null"," ",""),
                     quote = "\"",
                     stringsAsFactors = FALSE)
ffcs[1] <- NULL
## Einfügen des Dezimaltrennzeichens 
ffcs$LATITUDESTART <- as.numeric(paste0(substr(ffcs$LATITUDESTART,1,2),".",substr(ffcs$LATITUDESTART,3,15)))
ffcs$LATITUDEEND <- as.numeric(paste0(substr(ffcs$LATITUDEEND,1,2),".",substr(ffcs$LATITUDEEND,3,15)))
ffcs$LONGITUDESTART <- as.numeric(paste0(substr(ffcs$LONGITUDESTART,1,2),".",substr(ffcs$LONGITUDESTART,3,15)))
ffcs$LONGITUDEEND <- as.numeric(paste0(substr(ffcs$LONGITUDEEND,1,2),".",substr(ffcs$LONGITUDEEND,3,15)))

## Disable exponential notation
options(scipen=15) 
  
## Export als csv-Datei 
write.table(ffcs,file = "utf/13-11_a.csv",
              fileEncoding= "utf8", #im UTF-8 Format
              quote=FALSE,          # ohne Anführungszeichen
              row.names=FALSE,
              col.names = FALSE,
              sep = ";",
              dec = ".")

## Import der Datei 13-11_a_SanFran.csv
ffcs <- read.table("Problem/13-11_a_SanFran.csv",
                     sep=";",
                     dec=".",
                     header = TRUE,
                     na.strings=c("NA","null","null, null"," ",""),
                     quote = "\"",
                     stringsAsFactors = FALSE)
ffcs[1] <- NULL
  ffcs$LATITUDESTART <- as.numeric(paste0(substr(ffcs$LATITUDESTART,1,2),".",substr(ffcs$LATITUDESTART,3,15)))
  ffcs$LATITUDEEND <- as.numeric(paste0(substr(ffcs$LATITUDEEND,1,2),".",substr(ffcs$LATITUDEEND,3,15)))
  ffcs$LONGITUDESTART <- as.numeric(paste0(substr(ffcs$LONGITUDESTART,1,4),".",substr(ffcs$LONGITUDESTART,5,15)))
  ffcs$LONGITUDEEND <- as.numeric(paste0(substr(ffcs$LONGITUDEEND,1,4),".",substr(ffcs$LONGITUDEEND,5,15)))

  
  ## Disable exponential notation
  options(scipen=15) 
  
## Datei als csv exportieren
  write.table(ffcs,file = "utf/13-11_a_SanFran.csv",
              fileEncoding= "utf8",
              quote=FALSE,
              row.names=FALSE,
              col.names = FALSE,
              sep = ";",
              dec = ".") 

