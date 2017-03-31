#UI side of the app

#Defined Variables accessible to both UI and Server
source("global.r", local = FALSE)

#Choices for 'statistic' drop down

vars <- c("employed" = "employed",
          "labor force" = "labor_force",
          "unemployed" = "unemployed",
          "unemployed rate" = "unemployed_rate")
          

navbarPage(title = "California Counties Employment - 2016", id = 'nav',
           tabPanel('Interactive Map',
                    
                    leafletOutput('county.map', 
                                  width = "800px", 
                                  height = "800px"),
                    
                    absolutePanel(id = "controls", 
                                  fixed = TRUE, 
                                  draggable = TRUE, 
                                  top = 100, 
                                  left = 20, 
                                  right = "auto",
                                  bottom = "auto",
                                  width = "auto", 
                                  height = "auto",
                                  selectInput(inputId = "months", 
                                              label = "Select Month", 
                                              choices = sort(month(cal.merged$period, label = TRUE))
                                  ),# end of select input
                                  
                                  selectInput(inputId = 'statistic',
                                              label = 'Select Statistic',
                                              choices = vars
                                  )
                    ) #end of absolute panel
           ), # End of tab panel 1
           
           tabPanel('Data',
                    
                    dataTableOutput('data.table')
                    )# end of tab panel 2
) #end of navbar page


