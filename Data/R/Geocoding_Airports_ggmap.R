library(RCurl)
library(RJSONIO)
library(plyr)
library(ggmap)

airports <- read.table("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/R/Data/airports.csv",
                           header = TRUE,
                           sep = ";",
                           dec = ".")


airports$Flughafen   <- as.character(airports$Flughafen)
airports$Flughafen <- paste("Flughafen", airports$Flughafen)

geo_reply <-  geocode(enc2utf8(airports$Flughafen),  
                      output = c("latlona"), #latlona
                      source = c("google"), 
                      sensor = FALSE, 
                      messaging=TRUE, 
                      override_limit=TRUE)

airports_geocodes <- cbind(airports,geo_reply)

mapImageData <- get_map(location = c(lon = 10.447683,
                                     lat = 51.163375),
                        color = "color", # or bw
                        source = "google",
                        maptype = "terrain",
                        zoom = 6)
ggmap(mapImageData,
      extent = "device", # "panel" keeps in axes, etc.
      ylab = "Latitude",
      xlab = "Longitude",
      legend = "right") +
  geom_point(aes(x = lon, # path outline
                 y = lat),
             data = airports_geocodes,
             size = airports_geocodes$Landungen.gesamt/2000)+
  scale_fill_manual(values=c("black",NA))