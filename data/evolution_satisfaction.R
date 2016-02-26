load_data = function () {
	source("analyse_debarquement.R")
	satisfaction_nautique <<- format_data(nautique_with_passager_ss)
	satisfaction_pieton <<- format_data(pieton_with_passager_ss)
	satisfaction_totale <<- format_data(total_with_passager_ss)
	source("close_db_connections.R")
}

format_data = function (data) {
	data <- data[data$result != 0,]
	data[,1] <- substr(data[,1],6,10)
	colnames(data) <- c("date", "nbr", "sat")
	data <- aggregate(data[, 2:3], list(data$date), mean)
	data <- cbind(substr(data[,1],4,5), substr(data[,1],1,2), data[,2:3])
	data <- data[-3]
	data[,1] <- as.numeric(as.character(data[,1]))
	data[,2] <- as.numeric(as.character(data[,2]))
	data[,3] <- as.numeric(as.character(data[,3]))
	colnames(data) <- c("jour", "mois", "sat")
	return(data)
}

sat_by_month <- function (mois, critere) {
  if(critere == 1) {
    result = merge_sat(satisfaction_pieton, mois)
  }
  
  else if(critere == 2) {
    result = merge_sat(satisfaction_nautique, mois)
  }
  
  else {
    result = merge_sat(satisfaction_totale, mois)
  }
  return(result)
}

merge_sat = function (sat_data, mois) {
  base = data.frame(c(1:31), numeric(31))
  colnames(base) = c("jour", "sat")
  tmp = sat_data[sat_data$mois == mois,]
  tmp = tmp[-2]
  my_merge = merge(base,tmp, by="jour", all=TRUE)
  result = data.frame(my_merge$jour, my_merge[,2] + my_merge[,3])
  result[is.na(result)] = 0
  colnames(result) = c("jour", "sat")
  return(result)
}

load_data()