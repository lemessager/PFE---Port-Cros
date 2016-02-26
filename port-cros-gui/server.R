library(shiny)

shinyServer(function(input, output) {
  setwd("../data/")
  source("svm_souple.R")
  source("evolution_satisfaction.R")
  source("evolution_deb_bat.R")
  
  
  
  
  # TAB 1 : Affichage des liens entre la satisfaction et la frequentation
  output$nomPlot <- renderPlot({
    eval(parse(
      text = paste("final_result <- ",input$nom,"_with_passager",sep = "")
    ))
    show_res(mat_res = final_result, mark = paste("frequentation",input$nom))
  })
  
  
  
  
  
  # TAB 2 : Prediction avec SVM
  observeEvent(input$predict, {
    withProgress(message = 'Chargement du modele', value = 0, {
      run_svm_training_c(as.numeric(input$critere))
      
      #run_svm_training()
      day <<- as.numeric(input$day)
      month <<- as.numeric(input$month)
      withProgress(message = 'Estimation de la satisfaction', value = 0, {
        result <<- run_svm_prediction(day, month)
      })
    })
    
    output$svmPlot <- renderPlot({
      # Displaying the result
      plot(
        result$my_result,type = "l", xlab = "Nombre de passagers", ylab = "Satisfaction", lwd =
          3
      )
      
      # Some title
      title("Resultat des estimations")
      
      # Drawing the daily mean live
      abline(h = result$sat_mean[day, month], col = "red")
      
      # Drawing the monthly mean live
      abline(h = result$sat_mean_by_month[month], col = "green")
      
      # Drawing the global mean live
      abline(h = result$sat_mean_global, col = "blue")
      
      # Drawing vertical lines when we cross the mean
      abline(v = result$crossing_mean, col = "gray")
      
      #Grille
      grid(17,8)
    })
    
    output$dailyMean <- renderText({
      paste(
        "Satisfaction moyenne pour le ", day, "/", month, " : ", round(result$sat_mean[day, month], digits = 2)
      )
    })
    
    output$monthlyMean <- renderText({
      paste(
        "Satisfaction moyenne mensuelle : ", round(result$sat_mean_by_month[month], digits = 2)
      )
    })
    
    output$globalMean <- renderText({
      paste("Satisfaction moyenne globale : ", round(result$sat_mean_global, digits = 2))
    })
    
    output$maxPass <- renderText({
      paste("Nous vous conseillons de limiter le nombre de visiteurs a ", result$crossing_mean)
    })
    
    output$explications <- renderText({
      paste(
        "Pour vous fournir ce chiffre, nous regardons quand notre estimation de la satisfaction des visiteurs passe en dessous de la moyenne pour le jour que vous avez choisi. Si la moyenne du jour est trop basse, nous comparons avec la moyenne mensuelle. Si la moyenne mensuelle est trop basse, nous comparons avec la moyenne globale."
      )
    })
  })
  
  
  
  
  
  #TAB 3 : Evolution satisfaction
  output$evo_sat <- renderPlot({
    evo_sat_result <- sat_by_month(input$month_sat, input$crit_sat)
    
    if (sum(evo_sat_result$sat) > 0) {
      barplot(
        evo_sat_result$sat, names.arg = c(1:31), col = rainbow(31),
        main = "Evolution de la satisfaction moyenne par jour",
        xlab = "Jours", ylab = "Satisfaction"
      )
      
      grid(0,10)
    }
    
    else {
      title("Aucune donnee de satisfaction n'est disponible pour ce mois")
    }
  })
  
  output$zero_sat <- renderText({
    paste(
      "Une satisfaction a 0 signifie souvent une absence de donnees pour ce jour."
    )
  })
  
  
  
  
  #TAB 4 : Evolution Frequentation
  output$evo_freq <- renderPlot({
    evo_freq_result <- freq_by_month(input$month_freq, input$type_freq)
    
    if (sum(evo_freq_result$nbr) > 0) {
      if (input$type_freq == "bateaux") {
        barplot(
          evo_freq_result$nbr, names.arg = c(1:31), col = rainbow(31),
          main = "Evolution de la frequentation nautique moyenne par jour",
          xlab = "Jours", ylab = "Nombre de bateaux de plaisance"
        )
      } else {
        barplot(
          evo_freq_result$nbr, names.arg = c(1:31), col = rainbow(31),
          main = "Evolution de la frequentation pietonne moyenne par jour",
          xlab = "Jours", ylab = "Nombre de debarquements"
        )
      }
      grid(0,10)
    }
    
    else {
      title("Aucune donnee de frequentation n'est disponible pour ce mois")
    }
  })
  
  output$zero_freq <- renderText({
    paste(
      "Une frequentation a 0 signifie souvent une absence de donnees pour ce jour."
    )
  })
  
  
  
  
  
})
