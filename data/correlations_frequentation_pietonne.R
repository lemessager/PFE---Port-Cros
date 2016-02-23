source("readTable.R")
mysql <- readMyTable()

table <- dbGetQuery(mysql, "SELECT * FROM enquete_frequentation_pietonne")

table <- table[-48]
table <- table[-1]
table <- table[-1]

table[is.na(table)] <- 0

my_length <- length(table[1,])

my_cor <- matrix(numeric(1), nrow = my_length, ncol = my_length)

for (i in 1:my_length) {
  for (j in 1:my_length) {
    my_cor[i,j] <- cor(table[,i], table[,j])
  }
}

for(i in 1:my_length) {
  plot(my_cor[i,], type = "b", ylab = "Correlation", xaxt='n', ann=FALSE)
  title(colnames(table[i]))
  axis(1, at=seq(1, 51, by=1), labels = FALSE)
  text(seq(1, 51, by=1), par("usr")[3] - 0.2, cex = 0.8, labels = colnames(table), srt = 90, pos = 1, xpd = TRUE)
  abline(h = 0, col = "red")
  abline(v = i, col = "green")
  grid(52, 20)
}

source("close_db_connections.R")