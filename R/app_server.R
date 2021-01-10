#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  selected_map_vars <- callModule(mod_layerselection_server, "layerselection_ui_1")
  
  util_layers <- callModule(mod_layerutils_server, "layerutils_ui_1",
                            selected_map_vars = selected_map_vars)
  
  observe({
    print(selected_map_vars$input_eva)
  })
  
  callModule(mod_evamap_server, "evamap_ui_1",
             selected_map_vars = selected_map_vars,
             util_layers = util_layers)
  
  # observe({
  #   print(evamap_ui_1-vals1)
  # })

  callModule(mod_evabar_server, "evabar_ui_1")

  callModule(mod_evaspider_server, "evaspider_ui_1")

  }
