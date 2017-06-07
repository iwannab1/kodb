library(shiny)

ui <- pageWithSidebar(
  headerPanel("Click the button"),
  sidebarPanel(
    sliderInput("obs", "Number of observations:",
                min = 0, max = 1000, value = 500),
    actionButton("run","run")
  ),
  mainPanel(
    plotOutput("distPlot")
  )
)

server <- function(input, output) {
  
  rnormVal <- eventReactive(input$run, {
    rnorm(input$obs)
  })
  
  output$distPlot <- renderPlot({
    hist(rnormVal())
  })
  
}

shinyApp(ui, server)