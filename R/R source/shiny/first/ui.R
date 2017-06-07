library(shiny)

shinyUI(fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      h1("First level title"),
      HTML("<br>"),
      h2("Second level title"),
      HTML("<br>"),
      h3("Third level title")
      
    )
  )
))