require(shiny)
require(dplyr)
require(stringr)
require(tm)

unigram <- read.csv2("data/unigram2.txt",
                     header = TRUE,
                     sep = "\t",
                     stringsAsFactors = FALSE)

bigram <- read.csv2("data/bigram2.txt",
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE)

trigram <- read.csv2("data/trigram2.txt",
                     header = TRUE,
                     sep = "\t",
                     stringsAsFactors = FALSE)

quadgram <- read.csv2("data/quadgram2.txt",
                      header = TRUE,
                      sep = "\t",
                      stringsAsFactors = FALSE)

ngram <- read.csv2("data/ngram2.txt",
                   header = TRUE,
                   sep = "\t",
                   stringsAsFactors = FALSE)

source ("predictfunctions.r")

shinyServer(
        #Whatever computation happen here is used by ui.r to produce in main panel
        function(input, output){
                #Reactive function
                mysentence <- reactive({
                  validate(
                    need(input$userinput != "", "Please provide input sentence")
                  )
                        as.character(input$userinput)
                })
                mypredictions <- reactive({
                        as.numeric(input$predictcount)
                })
                #Loading nGram files
                
                #function to validate input
                cleanuserinput <- reactive({cleanuserinput <- cleansentense(mysentence())})
                matchpattern <- reactive({matchpattern <- processinput(cleanuserinput())})
                #break sentence into various grams for comparision 
                searchprediction <- reactive({searchprediction <- searchmatch(matchpattern(),
                                                                              mypredictions(), 
                                                                              unigram, 
                                                                              bigram, 
                                                                              trigram, 
                                                                              quadgram, 
                                                                              ngram)
                })
                output$data <- renderDataTable({head(searchprediction(), mypredictions())},
                                                options = list(lengthMenu = c(10, 20, 30), 
                                                                pageLength = 5))
        }
)