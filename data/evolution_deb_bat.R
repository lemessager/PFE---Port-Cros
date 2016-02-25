load_data <- function (name) {
  source("readTable.R")
  mysql = readMyTable()
  data = dbGetQuery(mysql, paste("SELECT * FROM ", name))
  source("close_db_connections.R")
  data = data[-1]
  data[,1] = substr(data[,1],6,10)
  colnames(data) = c("date", "nbr")
  View(data)
  data = aggregate(data[, 2], list(data$date), mean)
  View(data)
  data = cbind(substr(data[,1],4,5), substr(data[,1],1,2), data[,2])
  table = data.frame(as.numeric(as.character(data[,1])), as.numeric(as.character(data[,2])), as.numeric(as.character(data[,3])))
  colnames(table) = c("jour", "mois", "nbr")
  return(table)
}

hist_by_month <- function (name, month) {
  data = load_data(name)
  View(data)
  data = data[data[,2] == month,]
  data = data[-2]
  return(data)
}