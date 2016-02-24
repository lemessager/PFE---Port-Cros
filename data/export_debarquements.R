source("readTable.R")
mysql = readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM debarquements_journaliers")
table <- table[-c(1,4)]
id <- rep("NULL", length(table))

export <- cbind(id, table)
write.table(export, file = "debarquements.csv", sep=",", quote = FALSE, col.names=FALSE, row.names=FALSE)

source("close_db_connections.R")
