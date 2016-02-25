load_data <- function () {
	source("analyse_debarquement.R")
	satisfaction_nautique <<- format_data(nautique_with_passager_ss)
	satisfaction_pieton <<- format_data(pieton_with_passager_ss)
	satisfaction_totale <<- format_data(total_with_passager_ss)
	source("close_db_connections.R")
}

format_data <- function (data) {
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
	View(data)
	return(data)
}

sat_by_month <- function (mois, critere) {
  if(critere == 1) {
    tmp = satisfaction_pieton[satisfaction_pieton$mois == mois,]
  } else if(critere == 2) {
    tmp = satisfaction_nautique[satisfaction_nautique$mois == mois,]
  } else {
    tmp = satisfaction_totale[satisfaction_totale$mois == mois,]
  }
  return(tmp[-2])
}

load_data()