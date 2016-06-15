library(RCurl)
library(RJSONIO)
library(plyr)

url <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=52.5,13.36&radius=500&types=food&key=AIzaSyA9xYv7kr8j9HIEhA8Jr1SBUL1pZ2idJVo"
places <- fromJSON(url)

lat_lon <- places$results[[1]]$geometry$location
lng <- places$results[[1]]$geometry$location$lng
location_type <- places$results[[1]]$geometry$location_type
formatted_address <- places$results[[1]]$formatted_address

