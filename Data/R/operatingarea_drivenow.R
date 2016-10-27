require(stringi)
setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Geschaeftsgebiete/Drivenow/")
location <- read.table("Location_Drivenow.txt", sep = "," ,header = FALSE)
location <- data.frame(t(location))

businessAreaUrl <- location[grep("businessAreaUrl", location$t.location.), ]
businessAreaUrl <- as.data.frame(as.character(businessAreaUrl))
colnames(businessAreaUrl) <- "url"

businessAreaUrl$url <- stri_unescape_unicode(businessAreaUrl$url)

businessAreaUrl$url <- as.data.frame(sapply(businessAreaUrl$url,gsub,pattern="businessAreaUrl:",replacement=""))
businessAreaUrl$url <- as.data.frame(sapply(businessAreaUrl$url,gsub,pattern="items:",replacement=""))
businessAreaUrl$url <- as.data.frame(sapply(businessAreaUrl$url,gsub,pattern="\\{|\\[",replacement=""))
colnames(businessAreaUrl) <- "url"


setwd("C:/Users/Martin/Documents/Workaholic/TUD_Verkehr/Geodaten/Geschaeftsgebiete/Drivenow/")
destfilenames <- stri_sub(URL,-8,-1) 
for (i in 1:length(businessAreaUrl$url[,1])){
  URL <- as.vector(as.character(businessAreaUrl$url[i,1]))
  download.file(URL, destfile=stri_sub(URL,-8,-1))
}
