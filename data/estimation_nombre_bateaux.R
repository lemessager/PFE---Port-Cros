library("plyr")

# Connexion avec MySQL
source("readTable.R")
mysql <- readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_nautique")

table <- table[-1]
date <- table[,1]
result <<- data.frame(table(date))
colnames(result) <- c("date", "nbr bateaux")

source("close_db_connections.R")