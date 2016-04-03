require(shiny)
require(dplyr)
require(stringr)

#Define the UI for the Shiny application here

shinyUI(fluidPage(
        #Application title
        titlePanel(title = h1("Coursera Capestone Project: Language Modelling", 
                              align = "center")),
        #Sidebar layout
        sidebarLayout(
                #sidebar panel: COntains widgets to get data from user
                sidebarPanel(h3("Enter the sentence for which application should predict next word"),
                             textInput("userinput", 
                                       "", ""),
                             radioButtons("predictcount", 
                                          "Select Number of Suggestions", 
                                          list("3", "5", "10", "25")),
                             submitButton("Predict"),
                             p("Click predict to pull suggestions")
                             ),
                
                #Main panel: Where the output will be displayed
                mainPanel(h2("Next Word Prediction: Language Model", 
                             align = "center"),
                          tabsetPanel(type = "tab",
                                      tabPanel("Next Word", dataTableOutput("data")),
                                      tabPanel("Documentation", 
                                               h2("John Hopkins Data Science Specialization Coursera - Capestone Project"),
                                               h4("Author: Avinash Singh Pundhir"),
                                               h3("Introduction"),
                                               p("* This is an app that can be used as a text prediction application based based on input provided by user."),
                                               p("* We have used language modelling algorithm that uses a corpus of english language as base for predictions."),
                                               h3("Functionalities"),
                                               p("* In the text input box enter the sentense for which next word should be predicted."),
                                               p("* You can enter one word or multiple words to get the predictions."),
                                               p("* Select the radio box to access top 3/5/10 predictions."),
                                               p("* Hit predict to get the list of predictions."),
                                               h3("Userinterface"),
                                               p("* First tab of application will show the predictions and corresponding relevance score."),
                                               p("* Second tab outlines the documentation on how to use the application.")))
                )
        )
))