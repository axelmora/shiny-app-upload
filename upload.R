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
    

    cols <- (colnames(dt))
    
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
    cols <- (colnames(datos))
    
    x1 <- which(cols == input$cols1)
    y1 <- which(cols == input$cols2)
    cl1 <- which(cols == input$cols3)
    
    x <- datos[,x1]
    y <- datos[,y1]
    cl <- datos[,cl1]
    
    print(cl)
    
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