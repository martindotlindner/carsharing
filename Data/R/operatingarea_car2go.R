#Load packages
library(curl)
library(jsonlite)
library(httr)
library(RCurl)

date <- Sys.Date()
path <- paste0("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Freefloating/Geodaten/Geschaeftsgebiete/Car2Go/",date)

dir.create(path)

#Get list of current operating areas
cities <- fromJSON("https://www.car2go.com/api/v2.1/locations?oauth_consumer_key=car2gowebsite&format=json")

#Adjust style of city names (e.g. convert München to muenchen)
citynames <- tolower(cities$location$locationName)
citynames <- gsub("ü","ue",citynames)
citynames <- gsub(" ","",citynames)

# Download kml-files:
for (i in 1:length(citynames)){
url <- paste0("http://www.car2go.com/api/v2.1/operationareas?loc=",citynames[i],"&oauth_consumer_key=car2gowebsite")
filename <- paste0(path, "/", citynames[i],".kml")
download.file(url, destfile = filename)
}

