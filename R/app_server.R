#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here

  callModule(mod_evamap_server, "evamap_ui_1")
  
  callModule(mod_evabar_server, "evabar_ui_1")

  callModule(mod_evaspider_server, "evaspider_ui_1")

  }
