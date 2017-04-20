#Server Side of the app

function(input, output){

  #############################  
  ### Tab - Interactive Map ###

  by.month <- reactive({cal.merged[cal.merged$period == input$months, ]
  })
    
  by.stat <- reactive({
    switch(input$statistic,
             "employed" = by.month()$employed,
             "labor_force" = by.month()$labor_force,
             "unemployed" = by.month()$unemployed,
             "unemployed_rate" = by.month()$unemployed_rate
         )
  })
  
  my_colors <- reactive({
    colorNumeric(palette = "RdYlBu", reverse = TRUE, domain = by.stat())
  })
  
  output$county.map <- renderLeaflet({
    leaflet(data = cal.merged) %>%
      addProviderTiles(provider = providers$OpenStreetMap.France) %>%
      setMaxBounds(lng1 = -125, lat1 = 31, lng2 = -113, lat2 = 43) %>%
      setView(lng = -119.417931, lat = 36.778259, zoom = 6)
  }) #end of output$county.map
  
  observe({
    pal <- my_colors()
    
     
      add_labels <- paste(by.month()$name,':', by.stat())
    
    leafletProxy('county.map', data = by.month()) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(by.stat()),
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
                  label = add_labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "bold",
                                 padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
                  )
     
    })
  
  observe({
    proxy <- leafletProxy("county.map", data = by.month())

    proxy %>% clearControls()
    if (input$legend) {
    proxy %>% addLegend(position = "topright",
                        pal = my_colors(),
                        opacity = .7,
                        values = ~by.stat(),
                        title = paste(input$statistic,'for', input$months)
                        )
      }
    }) # End of Observe
  
##################  
### Tab - Data ###
  
  output$data.table <- renderDataTable(data.frame(by.month()[ , c('name', 
                                                                  'period', 
                                                                  input$statistic)]))
    } #end of function
