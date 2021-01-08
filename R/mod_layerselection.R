#' layerselection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_layerselection_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' layerselection Server Function
#'
#' @noRd 
mod_layerselection_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_layerselection_ui("layerselection_ui_1")
    
## To be copied in the server
# callModule(mod_layerselection_server, "layerselection_ui_1")
 
