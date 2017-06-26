fluidPage(
  # Application title
  titlePanel("Analysis of documents"),

  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose a book:",
                  choices = books),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),

    # Show Word Cloud
    mainPanel(
      tabsetPanel(
        tabPanel("Word Cloud", plotOutput("plot")),
        tabPanel("Frequency Words", plotOutput("plot2")),
        tabPanel("tf", plotOutput("plottf")), #analiza taksonomiczna
        tabPanel("tf-idf", plotOutput("plotidf")), #ważone częstości logarytmiczne
        tabPanel("LSA", plotOutput("plotLSA")), #LSA analiza ukrytych składowych sematycznych
        tabPanel("tf contra LSA", plotOutput("plottfLSA")), #tf kontra LSA 
        tabPanel("LDA", plotOutput("plotLDA")) #LDA
      )
      
    )
    
    
    
  )
)
