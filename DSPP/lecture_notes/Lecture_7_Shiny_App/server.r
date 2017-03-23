library(shiny)

shinyServer(function(input,output){
  output$Diamonds_Data <- renderText({
    input$Diamonds_Data
  })
  output$ShowMeAPlot <- renderPlot({
    ggplot(diamonds,aes(input$Diamonds_Data,cut))+
      geom_point()
  })
}
)
