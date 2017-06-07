## 1

library(shiny)

runExample("01_hello") # a histogram
runExample("02_text") # tables and data frames
runExample("03_reactivity") # a reactive expression
runExample("04_mpg") # global variables
runExample("05_sliders") # slider bars
runExample("06_tabsets") # tabbed panels
runExample("07_widgets") # help text and submit buttons
runExample("08_html") # Shiny app built from HTML
runExample("09_upload") # file upload wizard
runExample("10_download") # file download wizard
runExample("11_timer") # an automated timer

# http://shiny.rstudio.com/gallery/

## 2

# ui.R
library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny Text"),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:", 
                  choices = c("rock", "pressure", "cars")),
      
      numericInput("obs", "Number of observations to view:", 10)
    ),
    
    # Show a summary of the dataset and an HTML table with the 
    # requested number of observations
    mainPanel(
      verbatimTextOutput("summary"),
      
      tableOutput("view")
    )
  )
))

# server.R
library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})

#myApp.R
library(shiny)
runApp(
  list(
    ui = fluidPage(
      
      titlePanel("Shiny Text"),
      sidebarLayout(
        sidebarPanel(
          selectInput("dataset", "Choose a dataset:", 
                      choices = c("rock", "pressure", "cars")),
          
          numericInput("obs", "Number of observations to view:", 10)
        ),
        mainPanel(
          verbatimTextOutput("summary"),
          tableOutput("view")
        )
      )
      
    ),
    server = function(input, output) {
      datasetInput <- reactive({
        switch(input$dataset,
               "rock" = rock,
               "pressure" = pressure,
               "cars" = cars)
      })
      output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
      })
      output$view <- renderTable({
        head(datasetInput(), n = input$obs)
      })
    }
  )
)

# 3

setwd("c:/raonbit/R/shiny")
runApp("first")
runApp("first", display.mode = "showcase")  ## show code
# ui.R , server.R 의 runApp 버튼

# 4

# ui programming
# structure
library(shiny)
shinyUI(fluidPage(
  # code
))

# layout

# default layout

# http://shiny.rstudio.com/articles/layout-guide.html의 첫번째 그림 삽입
# 그림에 input 영역, output 영역 표시 

shinyUI(fluidPage(
  
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("obs", "Number of observations:",  
                  min = 1, max = 1000, value = 500)
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

# 코드의 titlePanel,  sidebarPanel, mainPanel 빨간색으로 
# sidebarLayout(position="right", sidebar를 오른쪽에 표시


# grid layout
# column : 12 grid
# default layout 구현
library(shiny)
library(ggplot2)

dataset <- diamonds

shinyUI(fluidPage(
  
  titlePanel("Diamonds Explorer!"),
  
  fluidRow(
    column(3,
           h4("Diamonds Explorer"),
           sliderInput('sampleSize', 'Sample Size', 
                       min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
                       step=500, round=0),
           br(),
           checkboxInput('jitter', 'Jitter'),
           checkboxInput('smooth', 'Smooth')
    ),
    column(4, offset = 1,
           selectInput('x', 'X', names(dataset)),
           selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
           selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(4,
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
    )
  )
))

## offset 빨간색 
## offset : 간격 조정

# segment layout
# tabsetPanel() / navlistPanel()
# 06_tabsets example

shinyUI(fluidPage(
  
  titlePanel("Tabsets"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("dist", "Distribution type:",
                   c("Normal" = "norm",
                     "Uniform" = "unif",
                     "Log-normal" = "lnorm",
                     "Exponential" = "exp")),
      br(),
      
      sliderInput("n", 
                  "Number of observations:", 
                  value = 500,
                  min = 1, 
                  max = 1000)
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Summary", verbatimTextOutput("summary")), 
                  tabPanel("Table", tableOutput("table"))
      )
    )
  )
))

# 빨간색 tabsetPanel 
# tabsetPanel(type = "tabs", position="below",
# position = c("above", "below", "left", "right")


# Navlists

shinyUI(fluidPage(
  
  titlePanel("Application Title"),
  
  navlistPanel(
    "Header A",
    tabPanel("Component 1", "Component 1"),
    tabPanel("Component 2", "Component 2"),
    "Header B",
    tabPanel("Component 3", "Component 3"),
    tabPanel("Component 4", "Component 5"),
    "-----",
    tabPanel("Component 5", "Component 5")
  )
))

# Navbar pages
shinyUI(navbarPage("My Application", header="header", footer="footer",
                   tabPanel("Component 1", "Component 1"),
                   tabPanel("Component 2", "Component 2"),
                   navbarMenu("Component 3",
                              tabPanel("Sub-Component A", "Sub-Component A"),
                              tabPanel("Sub-Component B", "Sub-Component B"))
))

# HTML contents
#html tab mapping
p	<p>	A paragraph of text
h1	<h1>	A first level header
h2	<h2>	A second level header
h3	<h3>	A third level header
h4	<h4>	A fourth level header
h5	<h5>	A fifth level header
h6	<h6>	A sixth level header
a	<a>	A hyper link
br	<br>	A line break (e.g. a blank line)
div	<div>	A division of text with a uniform style
span	<span>	An in-line division of text with a uniform style
pre	<pre>	Text ‘as is’ in a fixed width font
code	<code>	A formatted block of code
img	<img>	An image
strong	<strong>	Bold text
em	<em>	Italicized text
HTML	 	Directly passes a character string as HTML code


## control widgets

function	widget
actionButton	Action Button
checkboxGroupInput	A group of check boxes
checkboxInput	A single check box
dateInput	A calendar to aid date selection
dateRangeInput	A pair of calendars for selecting a date range
fileInput	A file upload control wizard
helpText	Help text that can be added to an input form
numericInput	A field to enter numbers
radioButtons	A set of radio buttons
selectInput	A box with choices to select from
sliderInput	A slider bar
submitButton	A submit button
textInput	A field to enter text

# example
shinyUI(fluidPage(
  titlePanel("Basic widgets"),
  
  fluidRow(
    
    column(3,
           h3("Buttons"),
           actionButton("action", label = "Action"),
           br(),
           br(), 
           submitButton("Submit")),
    
    column(3,
           h3("Single checkbox"),
           checkboxInput("checkbox", label = "Choice A", value = TRUE)),
    
    column(3, 
           checkboxGroupInput("checkGroup", 
                              label = h3("Checkbox group"), 
                              choices = list("Choice 1" = 1, 
                                             "Choice 2" = 2, "Choice 3" = 3),
                              selected = 1)),
    
    column(3, 
           dateInput("date", 
                     label = h3("Date input"), 
                     value = "2014-01-01"))   
  ),
  
  fluidRow(
    
    column(3,
           dateRangeInput("dates", label = h3("Date range"))),
    
    column(3,
           fileInput("file", label = h3("File input"))),
    
    column(3, 
           h3("Help text"),
           helpText("Note: help text isn't a true widget,", 
                    "but it provides an easy way to add text to",
                    "accompany other widgets.")),
    
    column(3, 
           numericInput("num", 
                        label = h3("Numeric input"), 
                        value = 1))   
  ),
  
  fluidRow(
    
    column(3,
           radioButtons("radio", label = h3("Radio buttons"),
                        choices = list("Choice 1" = 1, "Choice 2" = 2,
                                       "Choice 3" = 3),selected = 1)),
    
    column(3,
           selectInput("select", label = h3("Select box"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
    
    column(3, 
           sliderInput("slider1", label = h3("Sliders"),
                       min = 0, max = 100, value = 50),
           sliderInput("slider2", "",
                       min = 0, max = 100, value = c(25, 75))
    ),
    
    column(3, 
           textInput("text", label = h3("Text input"), 
                     value = "Enter text..."))   
  )
  
))

## passing object

# ui <----> server
# input$name , display output

#display output object function
Output function	reder function  creates  
htmlOutput	rederUI raw HTML
imageOutput	rederImage image
plotOutput	rederPlot plot
tableOutput	rederTable table
textOutput	rederText text
uiOutput	            raw HTML
verbatimTextOutput	  text

# app.R
library(shiny)
runApp(
  list(
    ui = pageWithSidebar(
      headerPanel("Display Text!!"),
      sidebarPanel(
        p("display text...")
      ),
      mainPanel(
        #textOutput("text1"),
        verbatimTextOutput("text1"),
        verbatimTextOutput("text3"),
        htmlOutput("text2")
      )
    ),
    server = function(input, output){
      
      output$text1 <- renderText({
        "hello world!!"
      })
      
      output$text2 <- renderUI({
        "hello world!!"
      })
      
      c = list("a", "b", "c")
      output$text3 <- renderPrint({
        c
      })
      
    }
  )
)

# reactive example
library(shiny)
runApp(display.mode = "showcase",
       list(
         ui = fluidPage(
           titlePanel("Reactive"),
           
           sidebarLayout(
             sidebarPanel(
               selectInput("var", 
                           label = "Choose a variable to display",
                           choices = c("Percent White", "Percent Black",
                                       "Percent Hispanic", "Percent Asian"),
                           selected = "Percent White")
             ),
             
             mainPanel(
               textOutput("text1")
             )
           )
         ),
         server = function(input, output){
           
           output$text1 <- renderText({ 
             paste("You have selected ", input$var)
           })
           
         })
)

# action Button , actioin link

actionButton("<inputId>", "<label>")
actionLink("<inputId>", "<label>")
# 동작은 똑같고 보이는 모양만 다름 


# command 실행
# observeEvent()

library(shiny)

ui <- fluidPage(
  tags$head(tags$script(
    "Shiny.addCustomMessageHandler('testmessage',
    function(message) {
    alert(JSON.stringify(message));
    }
  );")),
  actionButton("do", "Click Me")
  )

server <- function(input, output, session) {
  observeEvent(input$do, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Thank you for clicking')
  })
}

shinyApp(ui, server)

# reactive data
# eventReactive()

library(shiny)

ui <- fluidPage(
  actionButton("go", "Go"),
  numericInput("n", "n", 50),
  plotOutput("plot")
)

server <- function(input, output) {
  
  randomVals <- eventReactive(input$go, {
    runif(input$n)
  })
  
  output$plot <- renderPlot({
    hist(randomVals())
  })
}

shinyApp(ui, server)

# 여러개의 actionButton 사용
# observeEvent() , reactiveValues()

library(shiny)

ui <- fluidPage(
  actionButton("runif", "Uniform"),
  actionButton("rnorm", "Normal"), 
  hr(),
  plotOutput("plot")
)

server <- function(input, output){
  v <- reactiveValues(data = NULL)
  
  observeEvent(input$runif, {
    v$data <- runif(100)
  })
  
  observeEvent(input$rnorm, {
    v$data <- rnorm(100)
  })  
  
  output$plot <- renderPlot({
    if (is.null(v$data)) return()
    hist(v$data)
  })
}

shinyApp(ui, server)


# tabchange
library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(id = "tabset",
                  tabPanel("Uniform",
                           numericInput("unifCount", "Count", 100),
                           sliderInput("unifRange", "Range", min = -100, max = 100, value = c(-10, 10))
                  ),
                  tabPanel("Normal",
                           numericInput("normCount", "Count", 100),
                           numericInput("normMean", "Mean", 0),
                           numericInput("normSd", "Std Dev", 1)
                  )
      ),
      actionButton("go", "Plot")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output){
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$go, {
    v$doPlot <- input$go
  })
  
  observeEvent(input$tabset, {
    v$doPlot <- FALSE
  })  
  
  output$plot <- renderPlot({
    if (v$doPlot == FALSE) return()
    
    isolate({
      data <- if (input$tabset == "Uniform") {
        runif(input$unifCount, input$unifRange[1], input$unifRange[2])
      } else {
        rnorm(input$normCount, input$normMean, input$normSd)
      }
      
      hist(data)
    })
  })
}

shinyApp(ui, server)


## HTML

names(tags)
##   [1] "a"           "abbr"        "address"     "area"        "article"
##   [6] "aside"       "audio"       "b"           "base"        "bdi"
##  [11] "bdo"         "blockquote"  "body"        "br"          "button"
##  [16] "canvas"      "caption"     "cite"        "code"        "col"
##  [21] "colgroup"    "command"     "data"        "datalist"    "dd"
##  [26] "del"         "details"     "dfn"         "div"         "dl"
##  [31] "dt"          "em"          "embed"       "eventsource" "fieldset"
##  [36] "figcaption"  "figure"      "footer"      "form"        "h1"
##  [41] "h2"          "h3"          "h4"          "h5"          "h6"
##  [46] "head"        "header"      "hgroup"      "hr"          "html"
##  [51] "i"           "iframe"      "img"         "input"       "ins"
##  [56] "kbd"         "keygen"      "label"       "legend"      "li"
##  [61] "link"        "mark"        "map"         "menu"        "meta"
##  [66] "meter"       "nav"         "noscript"    "object"      "ol"
##  [71] "optgroup"    "option"      "output"      "p"           "param"
##  [76] "pre"         "progress"    "q"           "ruby"        "rp"
##  [81] "rt"          "s"           "samp"        "script"      "section"
##  [86] "select"      "small"       "source"      "span"        "strong"
##  [91] "style"       "sub"         "summary"     "sup"         "table"
##  [96] "tbody"       "td"          "textarea"    "tfoot"       "th"
## [101] "thead"       "time"        "title"       "tr"          "track"
## [106] "u"           "ul"          "var"         "video"       "wbr"

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hello Shiny!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # adding the new div tag to the sidebar            
      tags$div(class="header", checked=NA,
               tags$p("Ready to take the Shiny tutorial? If so"),
               tags$a(href="http://shiny.rstudio.com/tutorial", "Click Here!")
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

# Use html UI
runExample("06_tabsets")
#<application-dir>
#  |-- www
#|-- index.html
#|-- server.R


#www/index.html
<html>
  
  <head>
  <script src="shared/jquery.js" type="text/javascript"></script>
  <script src="shared/shiny.js" type="text/javascript"></script>
  <link rel="stylesheet" type="text/css" href="shared/shiny.css"/> 
  </head>
  
  <body>
  <h1>HTML UI</h1>
  
  <p>
  <label>Distribution type:</label><br />
  <select name="dist">
  <option value="norm">Normal</option>
  <option value="unif">Uniform</option>
  <option value="lnorm">Log-normal</option>
  <option value="exp">Exponential</option>
  </select> 
  </p>
  
  <p>
  <label>Number of observations:</label><br /> 
  <input type="number" name="n" value="500" min="1" max="1000" />
  </p>
  
  <pre id="summary" class="shiny-text-output"></pre> 
  
  <div id="plot" class="shiny-plot-output" 
style="width: 100%; height: 400px"></div> 
  
  <div id="table" class="shiny-html-output"></div>
  </body>
  
  </html>
  
  # server.R
  library(shiny)

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # Reactive expression to generate the requested distribution.
  # This is called whenever the inputs change. The output
  # functions defined below then all use the value computed from
  # this expression
  data <- reactive({
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data. Also uses the inputs to build
  # the plot label. Note that the dependencies on both the inputs
  # and the data reactive expression are both tracked, and
  # all expressions are called in the sequence implied by the
  # dependency graph
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(data(), 
         main=paste('r', dist, '(', n, ')', sep=''))
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(data())
  })
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})


runApp("shiny/html")





## execution flow
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

## reactive expression

# server.R
library(shiny)
library(quantmod)

shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    print("executed!!!")
    data <- getSymbols(input$symb, src = "yahoo", 
                       from = input$dates[1],
                       to = input$dates[2],
                       auto.assign = FALSE)
    
    chartSeries(data, theme = chartTheme("white"), 
                type = "line", log.scale = input$log, TA = NULL)
  })
  
})

# ui.R
library(shiny)

shinyUI(fluidPage(
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
))

# server.R
shinyServer(function(input, output) {
  
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  output$plot <- renderPlot({    
    chartSeries(dataInput(), theme = chartTheme("white"), 
                type = "line", log.scale = input$log, TA = NULL)
  })
  
})


# use session
#server.R
shinyServer(function(input, output, session) {
  
  # Return the components of the URL in a string:
  output$urlText <- renderText({
    paste(sep = "",
          "protocol: ", session$clientData$url_protocol, "\n",
          "hostname: ", session$clientData$url_hostname, "\n",
          "pathname: ", session$clientData$url_pathname, "\n",
          "port: ",     session$clientData$url_port,     "\n",
          "search: ",   session$clientData$url_search,   "\n"
    )
  })
  
  # Parse the GET query string
  output$queryText <- renderText({
    query <- parseQueryString(session$clientData$url_search)
    
    # Return a string with key-value pairs
    paste(names(query), query, sep = "=", collapse=", ")
  })
})

#ui.R

shinyUI(bootstrapPage(
  h3("URL components"),
  verbatimTextOutput("urlText"),
  
  h3("Parsed query string"),
  verbatimTextOutput("queryText")
))



# run application

library(shiny)
runApp("<directory name>")
runUrl( "<url>")
runGitHub( "<your repository name>", "<your user name>") 
runGist("<gist number>")

# command line
R -e "shiny::runApp('<path>')"

# hosting
# http://www.shinyapp.io

install.packages('devtools')
devtools::install_github('rstudio/rsconnect')
rsconnect::setAccountInfo(name='raonbit', token='AEA5C57C88C610E317408597410BCFEB', secret='xw8o+sXVrC/opw1vYtu95iiUQZidzLspiAymmGu8')

library(rsconnect)

rsconnect::deployApp('shiny/stockVis')
Preparing to deploy application...DONE
Uploading bundle for application: 89077...
Detecting system locale ... ko_KO
DONE
Deploying bundle: 396314 for application: 89077 ...
Waiting for task: 168849237
building: Parsing manifest
building: Fetching packages
building: Installing packages
building: Installing files
building: Pushing image: 389669
deploying: Starting instances
rollforward: Activating new instances
success: Stopping old instances
Application successfully deployed to https://raonbit.shinyapps.io/stockVis/
  
  
  
  # http://shiny.rstudio.com/articles/reactivity-overview.html
  
  
  shinyServer(function(input, output) {
    output$distPlot <- renderPlot({
      hist(rnorm(input$obs))
    })
  })

# reactive source ---> reactive endpoing
# input$obs ---> output$distPlot
# 그림 추가

shinyServer(function(input, output) {
  output$plotOut <- renderPlot({
    hist(faithful$eruptions, breaks = as.numeric(input$nBreaks))
    if (input$individualObs)
      rug(faithful$eruptions)
  })
  
  output$tableOut <- renderTable({
    if (input$individualObs)
      faithful
    else
      NULL
  })
})

# 그림추가


fib <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))

shinyServer(function(input, output) {
  output$nthValue    <- renderText({ fib(as.numeric(input$n)) })
  output$nthValueInv <- renderText({ 1 / fib(as.numeric(input$n)) })
})


# 개선

fib <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))

shinyServer(function(input, output) {
  currentFib         <- reactive({ fib(as.numeric(input$n)) })
  
  output$nthValue    <- renderText({ currentFib() })
  output$nthValueInv <- renderText({ 1 / currentFib() })
})

# 그림추가 

library(shiny)

fib <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))

ui <- fluidPage(
  
  titlePanel("Fibonacci"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("n",
                  "n",
                  min = 3,
                  max = 50,
                  value = 10)
    ),
    
    mainPanel(
      verbatimTextOutput("nthValue"),
      verbatimTextOutput("nthValueInv")
    )
  )
)

server <- function(input, output, session) {
  currentFib         <- reactive({ fib(as.numeric(input$n)) })
  
  output$nthValue    <- renderText({ currentFib() })
  output$nthValueInv <- renderText({ 1 / currentFib() })
}

shinyApp(ui, server)

# isolation : avoiding dependency

## Version1 - reactive
library(shiny)

ui <- pageWithSidebar(
  headerPanel("Click the button"),
  sidebarPanel(
    sliderInput("obs", "Number of observations:",
                min = 0, max = 1000, value = 500)
  ),
  mainPanel(
    plotOutput("distPlot")
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}

shinyApp(ui, server)

# version 2 
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

#version 3
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
  output$distPlot <- renderPlot({
    input$run
    dist <- isolate(rnorm(input$obs))
    hist(dist)
  })
}

shinyApp(ui, server)
