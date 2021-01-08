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
 
  )
}
    
#' evabar Server Function
#'
#' @noRd 
mod_evabar_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_evabar_ui("evabar_ui_1")
    
## To be copied in the server
# callModule(mod_evabar_server, "evabar_ui_1")
 
