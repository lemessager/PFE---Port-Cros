# Closes every MySQL connection
cons <- dbListConnections(MySQL())
for(con in cons)
  dbDisconnect(con)