
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
                            selectInput(inputId = "weekdays",
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
  
  by.weekday <- reactive({
    pickups %>% filter(weekdays == input$weekdays & time_of_day == input$time_of_day)
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

