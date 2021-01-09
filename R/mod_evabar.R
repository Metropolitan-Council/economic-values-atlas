#' evabar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_evabar_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    plotOutput(ns("bargraph"), height = 300),
    
  )
}
    
#' evabar Server Function
#'
#' @noRd 
mod_evabar_server <- function(input, output, session){
  ns <- session$ns
 
  output$bargraph <- renderPlot({
    
    tibble(Score = c(1:6),
           Type = rep(c("Infrastructure", "Resilence", "Equity"), 2),
           Selection = rep(c("Selected Tract", "Tract Average"), each = 3)) %>%
      ggplot(aes(x = Score, 
                 y = Type, 
                 fill = Selection)) +
      geom_bar(stat = "identity",
               position = position_dodge(width = .9))+
      council_theme() +
      scale_fill_brewer(palette = "Paired") +
      theme(legend.position = "bottom")
    
  })
    
  
}
    
## To be copied in the UI
# mod_evabar_ui("evabar_ui_1")
    
## To be copied in the server
# callModule(mod_evabar_server, "evabar_ui_1")
 
