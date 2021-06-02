#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  callModule(mod_intro_server, "intro_ui_1")
  
  map_selections <- callModule(mod_map_selections_server, "map_selections_ui_1")
  
  # observe({print(map_selections$allInputs)}) #to check that selections are working
  
  map_util <- callModule(mod_map_utils_server, "map_utils_ui_1",
                         map_selections = map_selections)
  
  # observe({print((map_util$map_data2))}) #to check that data summary is working
  # observe({print((map_util$plot_data2))}) #to check that plot summary is working
  
  tract_selections <- callModule(mod_map_overview_server, "map_overview_ui_1",
             map_selections = map_selections,
             map_util = map_util)#,
             # current_tab = input$nav)
  
  observe({print(tract_selections$selected_tract)}) #to check that tract clicking is working
  
  callModule(mod_plot_tract_server, "plot_tract_ui_1",
             tract_selections = tract_selections,
             map_util = map_util)
  
  callModule(mod_download_scores_server, "download_scores_ui_1",
             tract_selections = tract_selections,
             map_util = map_util)
  
  callModule(mod_table_server, "table_ui_1",
             tract_selections = tract_selections,
             map_util = map_util)
  
  }
