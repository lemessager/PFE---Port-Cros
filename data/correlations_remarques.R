# Connexion avec MySQL
source("readTable.R")
mysql <- readMyTable()

# On recupere la table
table <- dbGetQuery(mysql, "SELECT * FROM remarques")

# On enleve les colonnes inutiles
table <- table[-3]
table <- table[-2]
table <- table[-1]

# On met des 0 a la place des NULL
table[is.na(table)] <- 0

# On stocke la taille de la table (le nombre de colonnes)
my_length <- length(table[1,])

# On initialise une matrice de cross correlation
my_cor <- matrix(numeric(1), nrow = my_length, ncol = my_length)

# ON REMPLIT LA MATRICE DE CROSS CORRELATION
for (i in 1:my_length) {
  for (j in 1:my_length) {
    my_cor[i,j] <- cor(table[,i], table[,j])
  }
}

# ON PLOT POUR CHAQUE COLONNE SON VECTEUR DE CROSS CORRELATION
for(i in 1:my_length) {
  plot(my_cor[i,], type = "b", ylab = "Correlation", xaxt='n', ann=FALSE)
  title(colnames(table[i]))
  axis(1, at=seq(1, my_length, by=1), labels = FALSE)
  text(seq(1, my_length, by=1), par("usr")[3] - 0.15, cex = 0.8, labels = strtrim(colnames(table), 8), srt = 90, pos = 1, xpd = TRUE)
  abline(h = 0.7, col = "red")
  abline(h = - 0.7, col = "red")
  abline(v = i, col = "blue")
  grid(30, 30)
}

source("close_db_connections.R")