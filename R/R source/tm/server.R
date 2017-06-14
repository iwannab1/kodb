Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_121")

library(tm)
library(wordcloud)
library(RColorBrewer)
library(memoise)
library(KoNLP)
library(stringr)
library(shiny)
library(ggplot2)
library(dplyr)

useNIADic()

pal <- brewer.pal(6,"Dark2")

function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    isolate({
      withProgress({
        setProgress(message = "전처리중...")
        txt = readLines(inFile$datapath, encoding='UTF-8') 
        txt <- str_replace_all(txt, "\\W", " ")
        nouns <- extractNoun(txt)
        wordcount <- table(unlist(nouns))
        df_word <- as.data.frame(wordcount, stringsAsFactors = F)
        colnames(df_word) <- c('word','freq')
        df_word
      })
    })
  })
  
  
  wordcloud_rep <- repeatable(wordcloud)
  
  output$wplot <- renderPlot({
    v <- terms()
    if(!is.null(v)){
      wordcloud_rep(words = v$word,  
                    freq = v$freq, 
                    min.freq = input$freq, max.words=input$max,
                    random.order = F,                
                    rot.per = .1,                    
                    scale=c(4, 0.3),
                    colors=pal)
    }
  })

}