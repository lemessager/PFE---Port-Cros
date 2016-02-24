plot_cor <- function (table) {
  
  my_length <- length(table[1,])
  my_cor <- matrix(numeric(1), nrow = my_length, ncol = my_length)
  
  for (i in 1:my_length) {
    for (j in 1:my_length) {
      my_cor[i,j] <- cor(table[,i], table[,j])
    }
  }
  
  for (i in 1:my_length) {
    plot(my_cor[i,], type = "b", ylab = "Correlation", xaxt = 'n', ann = FALSE)
    title(colnames(table[i]))
    axis(1, at = seq(1, my_length, by = 1), labels = FALSE)
    text(seq(1, my_length, by = 1), par("usr")[3] - 0.15, cex = 0.8, labels = strtrim(colnames(table), 10), srt = 90, pos = 1, xpd = TRUE)
    abline(h = 0.7, col = "red")
    abline(h = -0.7, col = "red")
    abline(v = i, col = "blue")
    grid(30, 30)
  }
  
}