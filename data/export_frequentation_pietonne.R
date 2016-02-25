source("readTable.R")

mysql = readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_pietonne")

table <- table[-1]
date <- table[1]

table[is.na(table)] <- 0


satisfait_pieton <- table[c(2,3,5,6,17)] %% 5
derangeant_pieton <- table[c(7,9,10,12:15)] %% 5
frequentation <- c(numeric(length(derangeant_pieton[,1])))

id <- rep("NULL", length(frequentation))

for(i in 1:length(frequentation)) {
  tmp = derangeant_pieton[i,]
  frequentation[i] <- mean(tmp[tmp != 0])
}

frequentation[is.na(frequentation)] <- 0

export <- cbind(id, date, satisfait_pieton, frequentation)
colnames(export) <- c("id", "date", "visite", "accueil", "info", "preservation", "reglementation", "frequentation")

write.table(export, file = "pieton.csv", sep=",", quote = FALSE, col.names=FALSE, row.names=FALSE)

source("close_db_connections.R")
