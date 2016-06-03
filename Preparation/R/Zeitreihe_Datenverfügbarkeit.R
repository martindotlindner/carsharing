library(ggplot2)
setwd("C:/Program Files/PostgreSQL/9.5/data/")

## Zeitreihe FFCS-Daten
zeitreihe_FFCS <- read.table("doy_floating.csv",
                             sep=",",
                             dec=".",
                             header = FALSE)
colnames(zeitreihe_FFCS) <- c("Count","time")
zeitreihe_FFCS$time <- as.Date(zeitreihe_FFCS$time, format = "%Y-%m-%d")


# sort the data by time. The [*,] selects all rows that
# match the specified condition - in this case an order function
# applied to the time column.
sorted.data <- zeitreihe_FFCS[order(zeitreihe_FFCS$time),]


# Find the length of the dataset
data.length <- length(sorted.data$time)

# Find min and max. Because the data is sorted, this will be
# the first and last element.
time.min <- sorted.data$time[1]
time.max <- sorted.data$time[data.length]

# generate a time sequence with 1 month intervals to fill in
# missing dates
all.dates <- seq(time.min, time.max, by="days")
# Convert all dates to a data frame. Note that we're putting
# the new dates into a column called "time" just like the
# original column. This will allow us to merge the data.
all.dates.frame <- data.frame(list(time=all.dates))

# Merge the two datasets: the full dates and original data
merged.data <- merge(all.dates.frame, sorted.data, all=T)
NA_Sum <- sum(is.na(merged.data$Count))
Row_Sum<- nrow(merged.data)
# The above merge set the new observations to NA.
# To replace those with a 0, we must first find all the rows
# and then assign 0 to them.
merged.data$Count[which(is.na(merged.data$Count))] <- 0
labeltext <- paste0("Missing Days: ", NA_Sum, "\nTotal Days: ", Row_Sum, " \\ Start Day: ", time.min, " \\ End Day: ", time.max)

ggplot(merged.data, aes(time, Count)) +
  geom_line(colour="black")+
  annotate("text",x = merged.data$time[30], y=50000, 
           label = labeltext, hjust = 0)
 

