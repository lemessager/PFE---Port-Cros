source("readTable.R")

mysql = readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM enquete_gestion")

table <- table[-1]
date <- table[1]

table[is.na(table)] <- 0

satisfait_gestion_1 <- table[c(3)]%%3
satisfait_gestion_1[satisfait_gestion_1==2] <- -1
satisfait_gestion_2 <- table[c(9,10,11,17)]%%4
satisfait_gestion_2 <- satisfait_gestion_2%%3
satisfait_gestion_2[satisfait_gestion_2==2] <- -1

satisfait_gestion <- cbind(satisfait_gestion_1, satisfait_gestion_2)


id <- rep("NULL", length(satisfait_gestion))

export <- cbind(id, date, satisfait_gestion)
write.table(export, file = "gestion.csv", sep=",", quote = FALSE, col.names=FALSE, row.names=FALSE)

source("close_db_connections.R")
