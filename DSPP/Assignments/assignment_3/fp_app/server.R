#Server Side of the app


function(input, output){
  
  by.month <- reactive({cal.merged[month(cal.merged$period, label = TRUE) == input$months, ]
  })
  
  selected.data <- reactive({
    
    stats <- switch(input$statistic,
                    "employed" = by.month[ , c('name', 'period','employed')],
                    "labor force" = by.month,
                    "unemployed" = by.month$unemployed,
                    "uneployed rate" = by.month$unemployed_rate)
    
     })
  
  output$county.map <- renderLeaflet({
    leaflet(data = cal.merged) %>%
      addProviderTiles(provider = providers$OpenStreetMap.France) %>%
      setMaxBounds(lng1 = -125, lat1 = 31, lng2 = -113, lat2 = 43) %>%
      setView(lng = -119.417931, lat = 36.778259, zoom = 6)
  }) #end of output$county.map
  
  observe({
    
    leafletProxy('county.map', data = by.month()) %>%
      clearShapes() %>%
      addPolygons(
        highlight = highlightOptions(weight = 2,
                                               fillColor = 'silver',
                                               color = 'blue',
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE) 
                  
                  )
    })

} #end of function