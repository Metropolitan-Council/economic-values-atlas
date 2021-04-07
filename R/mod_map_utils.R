#' map_utils UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_utils_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' map_utils Server Function
#'
#' @noRd 
mod_map_utils_server <- function(input, output, session,
                                 map_selections){
  ns <- session$ns
 
  make_map_data <- reactive({
    p <- eva.app::acs_tract %>% select("avgcommute", pov185rate)
    # dplyr::select(
    # var %in% c("avgcommute", "pov185rate"))#selected_map_vars$input_eva) 
    return(p)
  })
  
  ##-------------
  
  vals <- reactiveValues()
  
  observe({
    vals$map_data <- make_map_data()
  })
  
  return(vals)
  
}
    
## To be copied in the UI
# mod_map_utils_ui("map_utils_ui_1")
    
## To be copied in the server
# callModule(mod_map_utils_server, "map_utils_ui_1")
 
