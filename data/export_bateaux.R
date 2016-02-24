source("estimation_nombre_bateaux.R")

bateaux <- result
id <- rep("NULL", length(bateaux))

export <- cbind(id, bateaux)
write.table(export, file = "bateaux.csv", sep=",", quote = FALSE, col.names=FALSE, row.names=FALSE)

source("close_db_connections.R")
