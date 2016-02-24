source("readTable.R")

mysql = readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_nautique")

table <- table[-1]
date <- table[1]

table[is.na(table)] <- 0


satisfait_nautique <- table[c(3,5,6,7,18)]%%5
derangeant_nautique <- table[c(8,9,11,12,15,16)]%%5

frequentation <- c(numeric(length(derangeant_nautique[,1])))

id <- rep("NULL", length(frequentation))

for(i in 1:length(frequentation)) {
  tmp = derangeant_nautique[i,]
  frequentation[i] <- mean(tmp[tmp != 0])
}

frequentation[is.na(frequentation)] <- 0
frequentation <- trunc(frequentation)

export <- cbind(id, date, satisfait_nautique, frequentation)
colnames(export) <- c("id", "date", "visite", "accueil", "info", "preservation", "reglementation", "frequentation")

write.table(export, file = "nautique.csv", sep=",", quote = FALSE, col.names=FALSE, row.names=FALSE)

source("close_db_connections.R")
