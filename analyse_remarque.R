# This code does an analysis of the table 'remarque' 
# aiming at finding out the criteria which need to be improved.
#
# Result: 
#     1) 'information' is the criteria with the most 'critique negative' (143). 'preservation' is the second (130).
#         These two criteria have much more 'critique negative' than the others. (The third is 'limitation des poubelles' with 76).
# ==>       So we need to make lots of improvements from these two aspects, especially 'information'.
#     2) 'preservation' is the criteria with the most 'critique positive' (133). 'esthetique' is the second (110).
#         These two criteria have much more 'critique positive than the others'. (The third is 'accueil' with 22).
# ==>       We can see that 'preservation' has a divergence within the visitors. We should keep the service 'esthetique' as now.
#     3) People think that there are too many stipulations: 'nomber de regles' 'trop'(41) > 'pas assez'(21)
#        and there are not enough repressions: 'repression' 'trop'(5) << 'pas assez'(49)
#        Within the people who responded the questions, 61/123 think 'numbre de regles' is good, 51/105 think 'repression' is good.
# ==>       We might do some adjustments to the number of regles (--) and repression (++).
#
# Editor: ZHU Yuting
# Version: 2015-11-30

# Connection with the database
source("satisfaction_version_complet.R")

# Analyse 1: Criteria with the most 'critique negative'
cal_pos <- function(column, val){
  x_neg <- which(column == val)
  return(length(x_neg))
}

# People who do not have opinion
criteria_sat_0 <- apply(satisfait_remarque, 2, cal_pos, 0)
criteria_der_0 <- apply(derangeant_remarque, 2, cal_pos,0)

# People who responde the cases
criteria_sat_1 <- apply(satisfait_remarque, 2, cal_pos, 1) # critique positive
criteria_sat_2 <- apply(satisfait_remarque, 2, cal_pos, 2) # critique negative
criteria_der_1 <- apply(derangeant_remarque, 2, cal_pos, 1)# trop 
criteria_der_2 <- apply(derangeant_remarque, 2, cal_pos,2) # pas assez
criteria_der_3 <- apply(derangeant_remarque, 2, cal_pos,3) # pas assez

