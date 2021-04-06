#' map_selections UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_selections_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    # pickerInput(
    #   inputId = "myPicker", 
    #   label = "Select/deselect all + format selected", 
    #   choices = LETTERS, 
    #   options = list(
    #     `actions-box` = TRUE, 
    #     size = 10,
    #     `selected-text-format` = "count > 3"
    #   ), 
    #   multiple = TRUE
    # ),
    # br(),
    shinyWidgets::pickerInput("equityInput","Equity & People", 
                              choices = people_vars, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = people_vars),
    hr(),
    
    shinyWidgets::pickerInput("infInput","Infrastructure & Place", 
                              choices=place_vars, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = place_vars),
    
    hr(),

    shinyWidgets::pickerInput("resInput","Resilience & Business", 
                              choices=business_vars, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"),
                              multiple = T,
                              selected = business_vars)

  )
}
    
#' map_selections Server Function
#'
#' @noRd 
mod_map_selections_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_map_selections_ui("map_selections_ui_1")
    
## To be copied in the server
# callModule(mod_map_selections_server, "map_selections_ui_1")
 
