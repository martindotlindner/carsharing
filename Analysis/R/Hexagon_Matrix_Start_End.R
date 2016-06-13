library(reshape2)

setwd("C:/Program Files/PostgreSQL/9.5/data/")

# Read table from sql query "Hexagon_Matrix_Start_End.sql"
hex_matrix <- read.table("Hexagon_Matrix.csv",header = FALSE, sep = ",")
colnames(hex_matrix) <- c("start_hex","end_hex","count")

#Create column with percentage
hex_matrix$Anteil <- (hex_matrix$count/sum(hex_matrix$count))*100

#Remove rows with NA
hex_matrix <- na.omit(hex_matrix)

#Create matrix from data frame
hex_matrix_total <- acast(hex_matrix, start_hex~end_hex, value.var = "count")
hex_matrix_anteil <- acast(hex_matrix, start_hex~end_hex, value.var = "Anteil")
