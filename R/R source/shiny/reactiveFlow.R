library(shiny)
library(quantmod)

ui <- fluidPage(
  titlePanel("stockVis"),
  
  sidebarLayout(
    sidebarPanel(
      
      textInput("symb", "Symbol", "SPY"),
      
      dateRangeInput("dates", 
                     "Date range",
                     start = "2016-01-01", 
                     end = as.character(Sys.Date())),
      
      br(),
      
      checkboxInput("log", "Plot y axis on log scale", 
                    value = FALSE)
      
    ),
    
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    print("executed!!!")
    data <- getSymbols(input$symb, src = "yahoo", 
                       from = input$dates[1],
                       to = input$dates[2],
                       auto.assign = FALSE)
    
    chartSeries(data, theme = chartTheme("white"), 
                type = "line", log.scale = input$log, TA = NULL)
  })
  
}

shinyApp(ui, server)