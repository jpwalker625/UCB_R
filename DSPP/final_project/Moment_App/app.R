
library(shiny)
library(leaflet)

source("data/helpers.R")


weekdays <- levels(pickups$weekdays)
periods <- levels(pickups$time_of_day)

# Define UI for application that draws a histogram
ui <- navbarPage(title = "Moment App Smartphone Usage",
                 tabPanel("Interactive Map",
                          leafletOutput(outputId = 'phone_use.map',
                                        width = "800px",
                                        height = "800px"),
                          absolutePanel(fixed = TRUE, 
                                        draggable = TRUE, 
                                        top = "auto", 
                                        left = 20, 
                                        right = "auto",
                                        bottom = 100,
                                        width = "auto", 
                                        height = "auto",
                            selectInput(inputId = "weekday",
                                                   label = "Select Weekday",
                                                   choices = weekdays),
                                       selectInput(inputId = "time_of_day",
                                                   label = "Select Time of Day",
                                                   choices = periods))),
                 tabPanel("Data",
                          dataTableOutput('data.table')
                          )
                 )

                 

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

