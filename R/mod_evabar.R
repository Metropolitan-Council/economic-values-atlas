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
 
    plotOutput(ns("bargraph"), height = 500),
    
  )
}
    
#' evabar Server Function
#'
#' @noRd 
mod_evabar_server <- function(input, output, session){
  ns <- session$ns
 
  output$bargraph <- renderPlot({
    
    
    tribble(~"Category", ~"Type", ~"Selection", ~"Score",
            "Equity", "Commute", "Selected Tract", 1,
            "Equity", "Commute", "Tract Average", .5,
            "Equity", "Poverty", "Selected Tract", .5,
            "Equity", "Poverty", "Tract Average", .2,
            "Infrastructure", "Jobs", "Selected Tract", 1,
            "Infrastructure", "Jobs", "Tract Average", 2,
            "Infrastructure", "Highway proximity", "Selected Tract", 1,
            "Infrastructure", "Highway proximity", "Tract Average", 2,
            "Resilience", "Job diversity", "Selected Tract", .2,
            "Resilience", "Job diversity", "Tract Average", .8) %>%
      ggplot(aes(x = Score, 
                 y = Type, 
                 fill = Selection)) +
      geom_bar(stat = "identity",
               position = position_dodge(width = .9))+
      # council_theme() +
      theme_bw() +
      scale_fill_brewer(palette = "Paired") +
      facet_grid(Category~.,  space = "free_y", scales = "free_y") +
      theme(legend.position = "bottom")
    
  })
    
  
}
    
## To be copied in the UI
# mod_evabar_ui("evabar_ui_1")
    
## To be copied in the server
# callModule(mod_evabar_server, "evabar_ui_1")
 
