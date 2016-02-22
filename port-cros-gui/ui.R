library(shiny)
#library(datasets)

shinyUI(navbarPage("Port-Cros GUI",
                   
                   # TAB 1
                   tabPanel(
                     "Visualistion donn??es satisfaction",
                     
                     sidebarLayout(
                       sidebarPanel(
                         selectInput("sat", "Niveau de satisfaction",
                                     choices = c("nautique","pieton","total")),
                         hr(),
                         helpText("Donn??es des enqu??tes")
                       ),
                       mainPanel(
                         plotOutput("satPlot")
                       )
                     )
                   ),
                   
                   # TAB 2
                   tabPanel(
                     "Visualistion donn??es satisfaction / frequentation",
                     
                     sidebarLayout(
                       sidebarPanel(
                         selectInput("nom", "Niveau de satisfaction en fonction de frequentation",
                                     choices = c("pieton","nautique","total")),
                         hr(),
                         helpText("Resultat apres l'analyse")
                       ),
                       mainPanel(
                         plotOutput("nomPlot")
                       )
                     )
                   ),
                   
                   
                   # TAB 3
                   tabPanel(
                     "Pr??diction satisfaction",
                     
                     sidebarLayout(
                       sidebarPanel(
                         sliderInput("day", "Jour", 1, 31, 15),
                         selectInput("month", "Mois", c("Janvier" = 1,
                                                        "F??vrier" = 2,
                                                        "Mars" = 3,
                                                        "Avril" = 4,
                                                        "Mai" = 5,
                                                        "Juin" = 6,
                                                        "Juillet" = 7,
                                                        "Ao??t" = 8,
                                                        "Septembre" = 9,
                                                        "Octobre" = 10,
                                                        "Novembre" = 11,
                                                        "D??cembre" = 12)),
                         hr(),
                         actionButton("predict", "Lancer la pr??diction")
                       ),
                       mainPanel(
                         plotOutput("svmPlot")
                       )
                     )
                   )
                   
                   
))
