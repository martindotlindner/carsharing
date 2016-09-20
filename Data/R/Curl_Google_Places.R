library(RCurl)
library(RJSONIO)
library(plyr)

url <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=52.388,13.52&radius=5000&key=AIzaSyA9xYv7kr8j9HIEhA8Jr1SBUL1pZ2idJVo"
places <- fromJSON(url,simplify = FALSE)

lat <- places$results$geometry$location$lat
lng <- places$results$geometry$location$lng
location_type <- places$results[[1]]$geometry$location_type
formatted_address <- places$results[[1]]$formatted_address

lat <- places$results[[1]]$geometry$location$lat
lng <- places$results[[1]]$geometry$location$lng
formatted_address <- places$results[[1]]$formatted_address
opening <- places$results[[2]]$opening_hours$weekday_text

places$results

