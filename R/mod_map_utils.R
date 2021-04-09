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
 
  #we need to make this data for a bar plot, or something like that
  make_plot_data2 <- reactive({
    p <- eva.app::eva_data_main %>% 
      filter(name %in% map_selections$allInputs$value)
    return(p)
  })
  
  #but we want to get a single averaged value for every tract to put on the map
  make_map_data2 <- reactive({
    p <- eva.app::eva_data_main %>% 
      filter(name %in% map_selections$allInputs$value) %>%
      group_by(tr10) 
      
    
    eva_data_main %>%
      group_by(tr10) %>%
      mutate(z_score = if(interpret_high_value == "high_opportunity") (z_score) else if(interpret_high_value == "low_opportunity") (z_score * (-1)))
      summarise(MEAN = mean(z_score, na.rm = T))
    
    # dplyr::select(
    # var %in% c("avgcommute", "pov185rate"))#selected_map_vars$input_eva) 
    return(p)
  })
  
  ##-------------
  
  vals <- reactiveValues()
  
  observe({
    vals$map_data2 <- make_map_data2()
  })
  
  return(vals)
  
}
    
## To be copied in the UI
# mod_map_utils_ui("map_utils_ui_1")
    
## To be copied in the server
# callModule(mod_map_utils_server, "map_utils_ui_1")
 
