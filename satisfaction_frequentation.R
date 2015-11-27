# This code take two tables in consideration: 'enquete sur la frequentation nautique' 
# and 'enquete sur la frequentation pietonne'.
# In each table, there are several columns that represent the level of satisfaction.
# For those columns (tr??s satisfait -> indiff??rent), we consider it as positive values.
# For those columns (tr??s derangenat -> pas derangeant), we consider it as negative values.
# We normalize the numbers and calculate the sum.
# As so, in our result:
#   1) The values vary from -5 to 5.
#   2) A smaller value represents a greater satisfaction.
#   3) There are much more negative numbers (<0) than the positive numbers (>0).
#       which shows the majority of visiters are satisfied with the park.
# Editor: ZHU Yuting
# Version: 2015/11/27

#####################################################################
####################  Extaction of the data  ########################
#####################################################################

# Connection with the database
source("readTable.R")
channel =  readMyTable(); 

# Consideration of two tables 'frequentation'
frequentation_nautique <- dbGetQuery(channel, "SELECT * FROM `enquete sur la frequentation nautique`")
frequentation_pietonne <- dbGetQuery(channel, "SELECT * FROM `enquete sur la frequentation pietonne`")

# Delete the first column
frequentation_pietonne <- frequentation_pietonne[-1]
frequentation_nautique <- frequentation_nautique[-1]

# Extraction of the columns that signify the satisfaction degree
date_nautique <- frequentation_nautique[,1]
date_peiton <- frequentation_pietonne[,1]

# Neglect of 'null', 'NA' and 'no result'
satisfait_nautique <- frequentation_nautique[c(3,5,6,7,18)]%%5
derangeant_nautique <- frequentation_nautique[c(8,9,11,12,15,16)]%%5
satisfait_pieton <- frequentation_pietonne[c(3,4,6,7,18)]%%5
derangeant_pieton <- frequentation_pietonne[c(8,10,11,13:16)]%%5

#####################################################################
####################  Operation on the data  ########################
#####################################################################


# Calculate the number of non-zero and non-NA values in every row
cal_na <- function(sat_der){
  res <- length(which(!is.na(sat_der)&sat_der!=0))
  return(res) 
}
# Normalise the data
sat_cal <- function(sat_der, mark){
  num_vec <- apply(sat_der,1,cal_na)
  cal_vec <- 1./num_vec
  sat_der[is.na(sat_der)]<-0
  cal_vec[is.infinite(cal_vec)]<-0
  if(mark==-1){
    cal_vec = cal_vec*(-1)
  }
  res <- cal_vec*sat_der
  return(res)
}
# Positive mark signifies a greater satisfaction
satisfait_nautique_norm <- sat_cal(sat_der = satisfait_nautique, mark = 1)
derangeant_nautique_norm <- sat_cal(sat_der = derangeant_nautique, mark = -1)
satisfait_pieton_norm <- sat_cal(sat_der = satisfait_pieton, mark = 1)
derangeant_pieton_norm <- sat_cal(sat_der = derangeant_pieton, mark = -1)

# Regroup the data and calculate the final result
sat_nautique <- cbind(satisfait_nautique_norm, derangeant_nautique_norm)
nautique_final <- as.matrix(rowSums(sat_nautique, na.rm = T))

sat_pieton <- cbind(satisfait_pieton_norm, derangeant_pieton_norm)
pieton_final <- as.matrix(rowSums(sat_pieton, na.rm = T))

# Regroup with date for a further step
sat_nautique_with_date <- cbind(date_nautique, nautique_final)
sat_pieton_with_date <- cbind(date_peiton, pieton_final)
# Clear the console
# cat("\014") 