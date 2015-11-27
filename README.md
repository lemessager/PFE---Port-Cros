# PFE---Port-Cros
Codes R / Codes SQL

Dans le fichier home, creer un fichier  readMyTable.R contenant le code ci-dessous : (avec les bons paramètres)

 ( getwd() sur R, pour connaitre le directory home... On ne sait jamais, ça peut dépendre de votre installation de RStudio )
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(RMySQL)

readMyTable <- function () {
  
  mydb = dbConnect(MySQL(), user='root', password='', dbname='port-cros');
  return(mydb);
}
--------
