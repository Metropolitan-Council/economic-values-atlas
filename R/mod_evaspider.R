#' evaspider UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_evaspider_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    plotOutput(ns("spider"), height = 300),
    
  )
}
    
#' evaspider Server Function
#'
#' @noRd 
mod_evaspider_server <- function(input, output, session){
  ns <- session$ns
 
  
  set.seed(99)
  data <- as.data.frame(matrix( sample( 0:20 , 6 , replace=F) , ncol=3))
  colnames(data) <- c("Infrasctructure" , "Equity" , "Resilience" )
  rownames(data) <- paste("tract" , c("selected", "average") , sep="-")
  
  # To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each variable to show on the plot!
  data <- rbind(rep(20,5) , rep(0,5) , data)
  
   
  output$spider <- renderPlot({
    
   radarchart(data, 
               axistype=1 , 
               #custom polygon
               pcol=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9)) , pfcol=c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4)) , plwd=4 , plty=1,
               #custom the grid
               cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
               #custom labels
               vlcex=0.8)
  
    legend(x=0.7, y=1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9)) , text.col = "grey", cex=1.2, pt.cex=3)
    
  })
}
    
## To be copied in the UI
# mod_evaspider_ui("evaspider_ui_1")
    
## To be copied in the server
# callModule(mod_evaspider_server, "evaspider_ui_1")
 
