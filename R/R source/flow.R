#server.R
library(shiny)

print("Outside!")

shinyServer(function(input, output) {
  
  print("Inside!")
  output$text1 <- renderText({ 
    print("Inside render!")
    paste0("Hello ", input$name)
  })
})

#ui.R
library(shiny)

shinyUI(fluidPage(
  titlePanel("Reactive"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Your Name")
    ),
    
    mainPanel(
      textOutput("text1")
    )
  )
))
