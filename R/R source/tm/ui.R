library(shiny)

fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose text File',
                accept=c('text/txt', 
                         'text/plain', 
                         '.txt')),
      hr(),
      sliderInput("freq",
                  "최소사용회수:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "표시단어개수:",
                  min = 1,  max = 300,  value = 100)
    ),
    mainPanel(
      plotOutput("wplot")
      
    )
  )
)
