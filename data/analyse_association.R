# We want to find the association rules between the criteria and the final satisfaction value.
# At first, we 'clean' all the net data:
# For the criteria 'derangeant': -4 : tres derangeant, -1 pas derangeant, 0 pas d'avis
# For the criteria 'satisfait': 4 : tres satisfait, 1 : pas satisfait, 0 pas d'avis
# For the table 'gestion': -1 : trop contraignant, 1 : justifie, 0 pas d'avis
#
# Then, we group the satisfaction value into four classes : 0 pas satisfait -- 3 tres satisfait
# At last, we save the table into a excel file.
# In order to find the association rules, we use WEKA :
#   [ Load the file, Filter the data by 'NumerisToNominal', Run the Association functions ]
# Among all the results, we choose the rules respecting :
#   The satisfaction value is on one side. One criteria is on the other side. The min support is 0.5
# The final results is saved and explained in https://docs.google.com/document/d/1fBBQ4VVthBKlOCbxgExYbP0oEghhhXpQ6K8f9ZIGFaQ/edit
#
# Version : 24/02/2016

source("satisfaction_version_complet.R")

association <- function(){
  .frequentation_nautique <- dbGetQuery(channel, "SELECT * FROM enquete_frequentation_nautique")
  .frequentation_pietonne <- dbGetQuery(channel, "SELECT * FROM enquete_frequentation_pietonne")
  .gestion <- dbGetQuery(channel, "SELECT * FROM enquete_gestion")
  
  # Delete the first column
  .frequentation_pietonne <- .frequentation_pietonne[-1]
  .frequentation_nautique <- .frequentation_nautique[-1]
  .gestion <- .gestion[-1]
  
  # Neglect of 'null', 'NA' and 'no result'
  .satisfait_nautique <- (-1 * .frequentation_nautique[c(3,5,6,7,18)]%%5 + 5)%%5
  .derangeant_nautique <- -1 * (.frequentation_nautique[c(8,9,11,12,15,16)]%%5 -5)%%5
  
  .satisfait_pieton <- (-1 * .frequentation_pietonne[c(2,3,5,6,17)]%%5 + 5)%%5
  .derangeant_pieton <- -1 * (.frequentation_pietonne[c(7,9,10,12:15)]%%5 -5)%%5
  
  .sat_nautique <- cbind(.satisfait_nautique, .derangeant_nautique)
  .sat_pieton <- cbind(.satisfait_pieton, .derangeant_pieton)
  
  # Add new criteriers for calculating the satisfaction
  
  # information 1: bien diffuse 2->-1 peu accessible
  .satisfait_gestion_1 <- .gestion[c(3)]%%3
  .satisfait_gestion_1[.satisfait_gestion_1==2] <- -1
  
  # limitation de poubelle / limitation de sanitaire / interdiction de fumer / regulation
  # 1: justifie 2->-1 trop contraignant 3/4->0 pas d'avis
  .satisfait_gestion_2 <- .gestion[c(9,10,11,17)]%%4
  .satisfait_gestion_2 <- .satisfait_gestion_2%%3
  .satisfait_gestion_2[.satisfait_gestion_2==2] <- -1
  
  .satisfait_gestion <- cbind(.satisfait_gestion_1, .satisfait_gestion_2)
  
  # Extraction of the columns that signify the satisfaction degree
  date <- substr(.frequentation_nautique[,1],1,10)
  .date_nautique <- date
  .sat_nautique_with_date <- data.frame(cbind(date, .sat_nautique))
  
  date <- substr(.frequentation_pietonne[,1],1,10)
  .date_pieton <- date
  .sat_pieton_with_date <- data.frame(cbind(date, .sat_pieton))
  
  date <- substr(.gestion[,1],1,10)
  .date_gestion <- date
  .sat_gestion_with_date <- data.frame(cbind(date, .satisfait_gestion))
  
  sep_sat <- function(sat_mat){
    m1 <- median(sat_mat)
    m2 <- median(sat_mat[sat_mat>m1])
    m3 <- median(sat_mat[sat_mat<=m1])
    result <- sat_mat
    result[sat_mat<=m3] <- 3 
    result[sat_mat<=m1&sat_mat>m3] <- 2
    result[sat_mat<=m2&sat_mat>m1] <- 1
    result[sat_mat>m2] <- 0
    return(result)
  }
   
  .nautique_final <- sep_sat(.nautique_final)
  .pieton_final <- sep_sat(.pieton_final)
  .sat_gestion <- sep_sat(.sat_gestion)
  
  .sat_nautique_with_date <- data.frame(.sat_nautique_with_date, .nautique_final)
  .sat_pieton_with_date <- data.frame(.sat_pieton_with_date, .pieton_final)
  .sat_gestion_with_date <- data.frame(.sat_gestion_with_date, .sat_gestion)
  
  write.csv(.sat_nautique_with_date[943:1680,], "nautique_result.csv")
 #  write.csv(.sat_pieton_with_date[1087:2180,], "pieton_result.csv")
  write.csv(.sat_gestion_with_date, "gestion_result.csv")
}