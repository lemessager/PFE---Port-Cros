library(shiny)
#library(datasets)

shinyUI(navbarPage("Port-Cros GUI",
                   
                   # TAB 1
                   tabPanel(
                     "Visualistion données satisfaction",
                     
                     sidebarLayout(
                       sidebarPanel(
                         selectInput("sat", "Niveau de satisfaction",
                                     choices = c("pieton","nautique","remarque")),
                         hr(),
                         helpText("Data from the questionnaires")
                       ),
                       mainPanel(
                         plotOutput("satPlot")
                       )
                     )
                   ),
                   
                   # TAB 2
                   tabPanel(
                     "Prédiction satisfaction",
                     
                     sidebarLayout(
                       sidebarPanel(
                         sliderInput("day", "Jour", 1, 31, 15),
                         selectInput("month", "Mois", c("Janvier" = 1,
                                                        "Février" = 2,
                                                        "Mars" = 3,
                                                        "Avril" = 4,
                                                        "Mai" = 5,
                                                        "Juin" = 6,
                                                        "Juillet" = 7,
                                                        "Août" = 8,
                                                        "Septembre" = 9,
                                                        "Octobre" = 10,
                                                        "Novembre" = 11,
                                                        "Décembre" = 12)),
                         hr(),
                         actionButton("predict", "Lancer la prédiction")
                       ),
                       mainPanel(
                         plotOutput("svmPlot")
                       )
                     )
                   )
                   
                   
))
