#' layerutils UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_layerutils_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' layerutils Server Function
#'
#' @noRd 
mod_layerutils_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_layerutils_ui("layerutils_ui_1")
    
## To be copied in the server
# callModule(mod_layerutils_server, "layerutils_ui_1")
 
