# This is the complete version of analysis of satisfaction
# This code take three tables in consideration: 'enquete sur la frequentation nautique' 
# and 'enquete sur la frequentation pietonne' and 'remarque'
#
# In each table, there are several columns that represent the level of satisfaction.
# For those columns (tres satisfait -> indifferent, critique positive, critique negative), we consider it as positive values.
# For those columns (tres derangenat -> pas derangeant, trop, pas assez, bien), we consider it as negative values.
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

# Consideration of two tables 'frequentation'
frequentation_nautique <- dbGetQuery(channel, "SELECT * FROM enquete_frequentation_nautique")
frequentation_pietonne <- dbGetQuery(channel, "SELECT * FROM enquete_frequentation_pietonne")
remarque <- dbGetQuery(channel, "SELECT * FROM remarques")

# Delete the first column
frequentation_pietonne <- frequentation_pietonne[-1]
frequentation_nautique <- frequentation_nautique[-1]
remarque <- remarque[-1]

# Extraction of the columns that signify the satisfaction degree
date_nautique <- substr(frequentation_nautique[,1],1,10)
date_pieton <- substr(frequentation_pietonne[,1],1,10)
date_remarque <- substr(remarque[,1],1,10)

# Neglect of 'null', 'NA' and 'no result'
satisfait_nautique <- frequentation_nautique[c(3,5,6,7,18)]%%5
derangeant_nautique <- frequentation_nautique[c(8,9,11,12,15,16)]%%5
satisfait_pieton <- frequentation_pietonne[c(2,3,5,6,17)]%%5
derangeant_pieton <- frequentation_pietonne[c(7,9,10,12:15)]%%5
satisfait_remarque <- remarque[c(5:23,26:30)]%%3
derangeant_remarque <- remarque[c(24,25)]%%4

# Reconstruct the dataframe with date
# pieton <- data.frame(date_pieton, satisfait_pieton)
# nautique <- data.frame(date_nautique, satisfait_nautique)
# remarque_1 <- data.frame(date_remarque, satisfait_remarque)

# Write to csv file for further analysis
# write.csv(pieton, file = "pieton.csv")
# write.csv(nautique, file = "nautique.csv")
# write.csv(remarque_1, file = "remarque.csv")

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
satisfait_nautique_norm <- sat_cal(sat_der = satisfait_nautique, mark_val = 4)
derangeant_nautique_norm <- sat_cal(sat_der = derangeant_nautique, mark_val = -4)

satisfait_pieton_norm <- sat_cal(sat_der = satisfait_pieton, mark_val = 4)
derangeant_pieton_norm <- sat_cal(sat_der = derangeant_pieton, mark_val = -4)

satisfait_remarque_norm <- sat_cal(sat_der = satisfait_remarque, mark_val = 2)
derangeant_remarque_norm <- sat_cal(sat_der = derangeant_remarque, mark_val = -3)

# Regroup the data and calculate the final result
sat_nautique <- cbind(satisfait_nautique_norm, derangeant_nautique_norm)
nautique_final <- as.matrix(rowSums(sat_nautique, na.rm = T))

sat_pieton <- cbind(satisfait_pieton_norm, derangeant_pieton_norm)
pieton_final <- as.matrix(rowSums(sat_pieton, na.rm = T))

sat_remarque <- cbind(satisfait_remarque_norm, derangeant_remarque_norm)
remarque_final <- as.matrix(rowSums(sat_remarque, na.rm = T))

# Regroup with date for a further step
sat_nautique_with_date <- data.frame(cbind(date_nautique, nautique_final))
sat_pieton_with_date <- data.frame(cbind(date_pieton, pieton_final))
sat_remarque_with_date <- data.frame(cbind(date_remarque, remarque_final))

#####################################################################
#####################  Analyse of the data  #########################
#####################################################################

# install.packages("plyr")
library("plyr")

# Regroup the data by date and calculate the average
sat_result_nautique <- ddply(sat_nautique_with_date, .(date_nautique), summarize, moyen=-mean(as.numeric(levels(V2))[V2]))
sat_result_pieton <- ddply(sat_pieton_with_date, .(date_pieton), summarize, moyen=-mean(as.numeric(levels(V2))[V2]))
sat_result_remarque <- ddply(sat_remarque_with_date, .(date_remarque), summarize, moyen=-mean(as.numeric(levels(V2))[V2]))

# Show the result
# plot(x = sat_result_remarque$date_remarque, y = sat_result_remarque$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Remarque", ylim=c(-1,1))
# plot(x = sat_result_nautique$date_nautique, y = sat_result_nautique$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Frequentation Nautique", ylim=c(-1,1))
# plot(x = sat_result_pieton$date_pieton, y = sat_result_pieton$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Frequentation Pieton", ylim=c(-1,1))


# Part II 

# We want to merge the result of "nautique" and "pieton" in order to analyze all the visitors together.
# So we merge the two result tables and calculate the average satisfaction of each date.
# At one date, if there are not any record of "nautique", the result is the number of satisfaction "pieton".
# If there are two records, we calculate the average.
# At the end, we obtain a table with numbers in [-1,1]


# Preperation for merging the tables
colnames(sat_result_remarque) <- c("date", "remarque")
colnames(sat_result_pieton) <- c("date", "pieton")
colnames(sat_result_nautique) <- c("date", "nautique")

# sat_result <- merge(sat_result_remarque, sat_result_nautique, all = T, by="date")
sat_result <- merge(sat_result_nautique, sat_result_pieton, all = T, by = "date")

# Calculate the average
all_sat <- function(par_mat){
  new_mat <- format(par_mat[,c(2,3)], scientific = F)
#   num_all <- which(!is.na(new_mat[,1])&!is.na(new_mat[,2]))
  new_mat[,1] <- round(as.numeric(unlist(new_mat[,1])), 8)
  new_mat[,2] <- round(as.numeric(unlist(new_mat[,2])), 8)
  new_mat[,3] <- apply(new_mat, 1, mean, na.rm = T)
  res <- data.frame(par_mat[,1], new_mat)
  colnames(res) <- c("date", "nautique", "pieton", "total")
  return(res)
}

sat_result <- all_sat(par_mat = sat_result)
sat_result_total <- sat_result[,c(1,4)]
# plot(x = sat_result_pieton$date_pieton, y = sat_result_pieton$moyen, xlab = "Date d'enquete", ylab = "Niveau de satisfaction", main = "Satisfaction calcule de Frequentation Pieton", ylim=c(-1,1))
