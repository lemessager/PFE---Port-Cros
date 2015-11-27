
library(RMySQL)

user = 'root'
password = ''
dbname='port-cros'

readMyTable <- function () {
  
  mydb = dbConnect(MySQL(), user='root', password='', dbname='port-cros');
  return(mydb);
}