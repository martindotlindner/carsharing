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

# Unterscheidung nach Land 
Germany <- subset(ffcs, substr(ffcs$LICENCEPLATE,1,1) =="B" | #Berlin
                    substr(ffcs$LICENCEPLATE,1,1) =="M"| #München
                    substr(ffcs$LICENCEPLATE,1,1)=="S" | #Stuttgart
                    substr(ffcs$LICENCEPLATE,1,1)=="F" | #Frankfurt a. Main
                    substr(ffcs$LICENCEPLATE,1,1)=="K" | #Köln
                    substr(ffcs$LICENCEPLATE,1,1)=="H" | #Hamburg
                    substr(ffcs$LICENCEPLATE,1,1)=="U" | #Ulm
                    substr(ffcs$LICENCEPLATE,1,1)=="D"  #Düsseldorf
                  
                    )

USA <- subset(ffcs, ffcs$LONGITUDEEND < -90)
Austria <- subset(ffcs, substr(ffcs$LICENCEPLATE,1,1)=="W")
Denmark <- subset(ffcs, ffcs$LATITUDESTART > 55)
GB <- subset(ffcs, ffcs$LONGITUDESTART < 2 & ffcs$LONGITUDESTART > -10)

# Löschen der Einträge aus Originaldatensatz

ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="B" )
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="M")
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="S" )
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="F")
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="K" )
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="H")
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="D" )
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1) =="U" )
ffcs <- subset(ffcs, ! ffcs$LONGITUDEEND < -90)
ffcs <- subset(ffcs, ! substr(ffcs$LICENCEPLATE,1,1)=="W")
ffcs <- subset(ffcs, ! ffcs$LATITUDESTART > 55)
ffcs <- subset(ffcs, ! ffcs$LONGITUDESTART < 2 & ffcs$LONGITUDESTART > -10)

write.table(Germany,file = "Germany.csv",
            fileEncoding= "utf8",
            quote=FALSE,
            row.names=FALSE,
            col.names = FALSE,
            sep = ";",
            dec = ".") 
