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
  
  
  ##### updated map
  
  map_selections <- callModule(mod_map_selections_server, "map_selections_ui_1")
  
  map_util <- callModule(mod_map_utils_server, "map_utils_ui_1",
                         map_selections = map_selections)
  
  
  
  observe({print(map_selections$goButton)})
  
  # observe({print(map_selections$input_values)})
  
  # observe({print(map_selections$peopleInput)})
  # observe({print(map_selections$placeInput)})
  # observe({print(map_selections$businessInput)})
  
  callModule(mod_map_overview_server, "map_overview_ui_1",
             map_selections = map_selections,
             map_util = map_util)
  

  ########
  
  # observe({
  #   print(mod_evamap_server$output$selected_tract)
  # })

  callModule(mod_evabar_server, "evabar_ui_1")

  callModule(mod_evaspider_server, "evaspider_ui_1")

  }
