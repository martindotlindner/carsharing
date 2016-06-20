# Replacement of umlauts and spaces have to be added (Failure of downloading e.g. 'München" or 'New York City'
library(curl,RCurl,httr,jsonlite)
library(jsonlite)

cities <- fromJSON("https://www.car2go.com/api/v2.1/locations?oauth_consumer_key=consumer_key&format=json")
citynames <- tolower(cities$location$locationName)

city = c("stuttgart","berlin","hamburg","frankfurt","rheinland","muenchen")
for (i in 1:length(citynames)){
url <- paste0("http://www.car2go.com/api/v2.1/operationareas?loc=",citynames[i],"&oauth_consumer_key=car2gowebsite")
filename <- paste0(citynames[i],".kml")
download.file(url, destfile = filename, method="libcurl")
}
