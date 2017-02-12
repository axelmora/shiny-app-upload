library(shiny)

server <- function(input, output) {
  output$contents <- renderTable({

    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    dt <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
             quote=input$quote)
    
  })
  
  output$ui <- renderUI({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    dt <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    
    cols <- colnames(datos)
    
    tabPanel("Columnas",
    selectInput("cols1", "X", cols),
    selectInput("cols2", "Y", cols),
    selectInput("cols3", "Clases", cols)
    )
  })
  
  output$txt <- renderText({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    dt <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    datos <- dt
    x <- input$cols1
    y <- input$cols2
    cl <- input$cols3
    
    info <- paste("x: ",x,"y: ",y,"clases: ",cl)
  })
}

ui <- fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
      uiOutput("ui"),
      textOutput("txt")
    ),
    mainPanel(
      tableOutput('contents')
    )
  )
)

shinyApp(ui = ui, server = server)