load_data = function (name) {
  source("readTable.R")
  mysql = readMyTable()
  data = dbGetQuery(mysql, paste("SELECT * FROM ", name))
  source("close_db_connections.R")
  data = data[-1]
  data[,1] = substr(data[,1],6,10)
  colnames(data) = c("date", "nbr")
  data = aggregate(data[, 2], list(data$date), mean)
  data = cbind(substr(data[,1],4,5), substr(data[,1],1,2), data[,2])
  table = data.frame(as.numeric(as.character(data[,1])), as.numeric(as.character(data[,2])), as.numeric(as.character(data[,3])))
  colnames(table) = c("jour", "mois", "nbr")
  return(table)
}

freq_by_month <- function (month, name) {
  data = load_data(name)
  data = data[data[,2] == month,]
  data = data[-2]
  base = data.frame(c(1:31), numeric(31))
  colnames(base) = c("jour", "nbr")
  my_merge = merge(base,data, by="jour", all=TRUE)
  result = data.frame(my_merge$jour, my_merge[,2] + my_merge[,3])
  result[is.na(result)] = 0
  colnames(result) = c("jour", "nbr")
  return(result)
}