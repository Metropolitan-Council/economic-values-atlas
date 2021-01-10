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
mod_layerutils_server <- function(input, output, session,
                                  selected_map_vars){
  ns <- session$ns
 
  make_map_data <- reactive({
    p <- eva_app::acs_tract %>% select("avgcommute", pov185rate)
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
# mod_layerutils_ui("layerutils_ui_1")
    
## To be copied in the server
# callModule(mod_layerutils_server, "layerutils_ui_1")
 
