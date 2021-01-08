#' evamap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_evamap_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' evamap Server Function
#'
#' @noRd 
mod_evamap_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_evamap_ui("evamap_ui_1")
    
## To be copied in the server
# callModule(mod_evamap_server, "evamap_ui_1")
 
