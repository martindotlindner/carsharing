#Get lat/lon from Streetnames via Google Places API
library(RCurl)
library(RJSONIO)
library(plyr)
library(ggmap)

malls_berlin <- read.table("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/Malls_Berlin.csv",
                           header = TRUE,
                           sep = ";",
                           dec = ".")

malls_berlin$Standort <- as.character(malls_berlin$Standort)
malls_berlin$Standort <- paste0(malls_berlin$Standort,", Berlin")

malls_berlin$Verkaufsflaeche <- gsub("m2","",malls_berlin$Verkaufsflaeche)
malls_berlin$Verkaufsflaeche <- gsub("([a-zA-Z.])","",malls_berlin$Verkaufsflaeche)
malls_berlin$Verkaufsflaeche <- gsub(" ","",malls_berlin$Verkaufsflaeche)
malls_berlin$Verkaufsflaeche <- as.numeric(malls_berlin$Verkaufsflaeche)


geo_reply <-  geocode(enc2utf8(malls_berlin$Standort),  
                      output = c("latlona"), #latlona
                      source = c("google"), 
                      sensor = FALSE, 
                      messaging=TRUE, 
                      override_limit=TRUE
                      )

malls_berlin_geocodes <- cbind(malls_berlin,geo_reply)

mapImageData <- get_map(location = c(lon = malls_berlin_geocodes$lon[1],
                                     lat = malls_berlin_geocodes$lat[1]),
                        color = "color", # or bw
                        source = "google",
                        maptype = "terrain",
                        # api_key = "your_api_key", # only needed for source = "cloudmade"
                        zoom = 13)
ggmap(mapImageData,
      extent = "device", # "panel" keeps in axes, etc.
      ylab = "Latitude",
      xlab = "Longitude",
      legend = "right") +
  geom_point(aes(x = lon, # path outline
                y = lat),
            data = malls_berlin_geocodes,
            colour = "black",
            size = malls_berlin_geocodes$Verkaufsflaeche/5000)