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
 
  )
}
    
#' evaspider Server Function
#'
#' @noRd 
mod_evaspider_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_evaspider_ui("evaspider_ui_1")
    
## To be copied in the server
# callModule(mod_evaspider_server, "evaspider_ui_1")
 
