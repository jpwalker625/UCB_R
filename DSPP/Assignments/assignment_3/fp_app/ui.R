#UI side of the app

#Defined Variables accessible to both UI and Server
source("global.r")

navbarPage(title = "California Counties Employment - 2016", id = 'nav',
           tabPanel('Interactive Map',
                    
                    leafletOutput('county.map', 
                                  width = "800px", 
                                  height = "800px"),
                    
                    absolutePanel(id = "controls", 
                                  fixed = TRUE, 
                                  draggable = TRUE, 
                                  top = "auto", 
                                  left = 20, 
                                  right = "auto",
                                  bottom = 100,
                                  width = "auto", 
                                  height = "auto",
                                  selectInput(inputId = "statistic",
                                              label = 'Select Statistic',
                                              choices = c("employed",
                                                          "labor_force",
                                                          "unemployed", 
                                                          "unemployed_rate")
                                              ),
                                  
                                  selectInput(inputId = "months", 
                                              label = "Select Month", 
                                              choices = sort(cal.merged$period) 
                                              ),
                                  
                                  checkboxInput(inputId = "legend",
                                                label = "Show Legend",
                                                value = FALSE)
                                  ) #end of absolute panel
           ), # End of tab panel 1
           
           tabPanel('Data',
                    
                    dataTableOutput('data.table')
                    )# end of tab panel 2
) #end of navbar page



