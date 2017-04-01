#Server Side of the app


function(input, output){
  
  by.month <- reactive({cal.merged[month(cal.merged$period, label = TRUE) == input$months, ]
  })
  
  output$county.map <- renderLeaflet({
    leaflet(data = cal.merged) %>%
      addProviderTiles(provider = providers$OpenStreetMap.France) %>%
      setMaxBounds(lng1 = -125, lat1 = 31, lng2 = -113, lat2 = 43) %>%
      setView(lng = -119.417931, lat = 36.778259, zoom = 6)
  })
  observe({
    
    pal <- colorBin(reverse = TRUE, palette = 'RdYlBu', domain = by.month()$unemployed_rate, pretty = TRUE)
    
    labels <- paste(by.month()$name,':', by.month()$unemployed_rate, '%')
    
    leafletProxy('county.map', data = by.month()) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(unemployed_rate),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = .7,
                  highlight = highlightOptions(weight = 2,
                                               fillColor = 'silver',
                                               color = 'blue',
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "bold",
                                 padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
      ) #end of add Polygons
    
    observe({
      proxy <- leafletProxy("county.map", data = cal.merged)
      
      proxy %>% clearControls()
      pal <- pal
      proxy %>% addLegend(position = "topright",
                          pal = pal,
                          opacity = .7,
                          values = ~unemployed_rate,
                          title = paste('Unemployment Rate for', input$months)
      )
    })
    
  })
}
  
  