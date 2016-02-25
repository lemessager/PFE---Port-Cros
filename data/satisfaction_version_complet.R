# This is the complete version of analysis of satisfaction
# This code take three tables in consideration: 'enquete sur la frequentation nautique' 
# and 'enquete sur la frequentation pietonne' and 'remarque'
#
# In each table, there are several columns that represent the level of satisfaction.
# For those columns (tres .satisfait -> indifferent, critique positive, critique negative), we consider it as positive values.
# For those columns (tres derangenat -> pas .derangeant, trop, pas assez, bien), we consider it as negative values.
# We normalize the numbers and calculate the sum.
# As so, in our result:
#   1) The values vary from -1 to 1.
#   2) A bigger value represents a greater satisfaction.
# Result of Frequentation Nautique and Frequentation Pietonne:
#   1) There are much more positive numbers which means the majority of visiters are satisfied
#   2) There are lots of zeros from 2002-04-09 to 2002-04-21 because the original values are 'pas de reponses'
# Result of Remarque:
#   1) There are much more negative numbers which stands for a dissatisfaction. 
#      That is because the majority of visiters chose 'critique negative' for one criteria and 'pas de critiques' for the others.
#      We can consider that the visitor gave their opinion on the management of park. So the result can be taken as positive.
# Editor: ZHU Yuting
# Version: 2016/1/28
#

#####################################################################
####################  Extaction of the data  ########################
#####################################################################
# Clear the console
cat("\014") 
options(scipen = 8)
options(digits = 8)

# Connection with the database
source("readTable.R")
channel =  readMyTable(); 

get_table <- function(name){
  result <- dbGetQuery(channel, paste("SELECT * FROM", name))
  result <- result[-1]
  result[,1] <- substr(result[,1],1,10)
  if(ncol(result)==7){
    result[,7] <- (-result[,7])/4
  }
  return(result)
}

do_data <- function(){
  # Consideration of two tables 'frequentation'
  nautique <- get_table("nautique")
  pieton <- get_table("pieton")
  gestion <- get_table("gestion")

  #####################################################################
  ####################  Operation on the data  ########################
  #####################################################################

  # Calculate the number of non-zero and non-NA values in every row
  cal_na <- function(sat_der){
    res <- length(which(!is.na(sat_der)&sat_der!=0))
    return(res) 
  }

  # Normalise the data
  sat_cal <- function(sat_der, mark_val){
    num_vec <- apply(sat_der,1,cal_na)
    cal_vec <- 1./(num_vec*mark_val)
    sat_der[is.na(sat_der)]<-0
    cal_vec[is.infinite(cal_vec)]<-0
    res <- cal_vec*sat_der
    return(res)
  }
  
  # Positive mark signifies a greater satisfaction
  nautique[2:6] <- sat_cal(sat_der = nautique[,2:6], mark_val = 4)
  pieton[2:6] <- sat_cal(sat_der = pieton[,2:6], mark_val = 4)
  gestion[2:6] <- sat_cal(sat_der = gestion[,2:6], mark_val = 1)

  
  # Regroup the data and calculate the final result
  nautique_final <- as.matrix(rowSums(nautique[,-1], na.rm = T))
  pieton_final <- as.matrix(rowSums(pieton[,-1], na.rm = T))
  gestion_final <- as.matrix(rowSums(gestion[,-1], na.rm = T))
  
  # Regroup with date for a further step
  sat_nautique_with_date <- data.frame(cbind(nautique$date, nautique_final))
  sat_pieton_with_date <- data.frame(cbind(pieton$date, pieton_final))
  sat_gestion_with_date <- data.frame(cbind(gestion$date, gestion_final))

  #####################################################################
  #####################  Analyse of the data  #########################
  #####################################################################

  # install.packages("plyr")
  library("plyr")
  
  # Regroup the data by date and calculate the average
  .sat_result_nautique <<- ddply(sat_nautique_with_date, .(nautique$date), summarize, moyen=-mean(as.numeric(levels(X2))[X2]))
  .sat_result_pieton <<- ddply(sat_pieton_with_date, .(pieton$date), summarize, moyen=-mean(as.numeric(levels(X2))[X2]))
  .sat_result_gestion <<- ddply(sat_gestion_with_date, .(gestion$date), summarize, moyen=mean(as.numeric(levels(X2))[X2]))

  # Part II 
  
  # We want to merge the result of "nautique" and "pieton" in order to analyze all the visitors together.
  # So we merge the two result tables and calculate the average satisfaction of each date.
  # At one date, if there are not any record of "nautique", the result is the number of satisfaction "pieton".
  # If there are two records, we calculate the average.
  # At the end, we obtain a table with numbers in [-1,1]
  

  # Preperation for merging the tables
  colnames(.sat_result_pieton) <<- c("date", "pieton")
  colnames(.sat_result_nautique) <<- c("date", "nautique")
  colnames(.sat_result_gestion) <<- c("date", "gestion")
  
  sat_result <<- merge(.sat_result_nautique, .sat_result_pieton, all = T, by = "date")
  sat_result <<- merge(sat_result, .sat_result_gestion, all = T, by = "date")

  # Calculate the average
  all_sat <- function(par_mat){
    new_mat <- format(par_mat[,c(2,3,4)], scientific = F)
    new_mat[,1] <- round(suppressWarnings(as.numeric(unlist(new_mat[,1]))), 8)
    new_mat[,2] <- round(suppressWarnings(as.numeric(unlist(new_mat[,2]))), 8)
    new_mat[,3] <- round(suppressWarnings(as.numeric(unlist(new_mat[,3]))), 8)
    new_mat[,4] <- apply(new_mat, 1, mean, na.rm = T)
    res <- data.frame(par_mat[,1], new_mat)
    colnames(res) <- c("date", "nautique", "pieton", "gestion", "total")
    return(res)
  }

  sat_result <<- all_sat(par_mat = sat_result)
  sat_result_total <<- sat_result[,c(1,5)]
}

do_data()