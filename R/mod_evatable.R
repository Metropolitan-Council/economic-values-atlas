#' evatable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_evatable_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' evatable Server Function
#'
#' @noRd 
mod_evatable_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_evatable_ui("evatable_ui_1")
    
## To be copied in the server
# callModule(mod_evatable_server, "evatable_ui_1")
 
