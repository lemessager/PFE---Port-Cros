source("normalize.R")
source("correlation.R")
source("readTable.R")

mysql = readMyTable()

gestion <- dbGetQuery(mysql, "SELECT * FROM enquete_gestion")

gestion <- gestion[-1]
gestion[is.na(gestion)] <- 0

satisfait_gestion_1 <- gestion[c(3)]%%3
satisfait_gestion_1[satisfait_gestion_1==2] <- -1

satisfait_gestion_2 <- gestion[c(9,10,11,17)]%%4
satisfait_gestion_2 <- satisfait_gestion_2%%3
satisfait_gestion_2[satisfait_gestion_2==2] <- -1

satisfait_gestion <- cbind(satisfait_gestion_1, satisfait_gestion_2)

plot_cor(satisfait_gestion)

source("close_db_connections.R")