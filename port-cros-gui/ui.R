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
                   ),
                   
                   #TAB 4
                   tabPanel("Analyse Debarquement !",
                   sidebarLayout(
                     sidebarPanel(
                       selectInput("deb","select the month", choices = c("Janvier"=1,"Fevrier"=2,"Mars"=3,"Avril"=4,"Mai"=5,"Juin"=6,"Juillet"=7,"Aout"=8,"Septembre"=9,"Octobre"=10,"Novembre"=11,"Decembre"=12)),
                       br(),
                       sliderInput("jour","Select the day for histogram",min = 1,max = 31,value = 1),
                       
                       
                       br(),
                       radioButtons("color","Select the color of histogram", choices = c("Green","Yellow","Red"),selected = "Green"),
                       
                       
                       
                       h6(" Powered by: "),
                       tags$img(src='RStudio-Ball.png', height=50, width=50),
                       tags$style("body{background-color:linen; color:brown}")
                     ),
                     mainPanel(
                       plotOutput("disPlot")
                     )
                   )
                   
                   
)))
