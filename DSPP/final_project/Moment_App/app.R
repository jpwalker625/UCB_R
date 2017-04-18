
library(shiny)
library(leaflet)

source("data/helpers.R")

months <- levels(pickups$month)
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
                                        selectInput(inputId = "month",
                                                    label = "Select Month",
                                                    choices = months),
                                        
                                        sliderInput(inputId = "days",
                                                    label = "Select Day",
                                                    min = 1, 
                                                    max = 31,
                                                    value = 1, 
                                                    step = 1),
                                       
                                        selectInput(inputId = "time_of_day",
                                                   label = "Select Time of Day",
                                                   choices = periods))),
                 tabPanel("Data",
                          dataTableOutput('data.table')
                          )
                 )

                 

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  by.weekday <- reactive({
    pickups %>% filter(month == input$month &
                       day == input$days & 
                         time_of_day == input$time_of_day)
  })
  
  output$phone_use.map <- renderLeaflet({
    leaflet(data = by.weekday) %>%
      addProviderTiles(provider = providers$OpenStreetMap.France) %>%
      setView(lat = 37.73, lng = -122.4194, zoom = 10)
  })
  
  observe({
    leafletProxy('phone_use.map', data = by.weekday()) %>%
      clearMarkerClusters() %>%
      addCircleMarkers(clusterOptions = markerClusterOptions())
  })
  
  
  output$data.table <- renderDataTable(data.frame(by.weekday()))
   }

# Run the application 
shinyApp(ui = ui, server = server)

