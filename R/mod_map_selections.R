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
                              choices = filter(eva_vars, type == "people")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = filter(eva_vars, type == "people")$name),
    hr(),
    
    shinyWidgets::pickerInput("infInput","Infrastructure & Place", 
                              choices=filter(eva_vars, type == "place")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = filter(eva_vars, type == "place")$name),
    
    hr(),

    shinyWidgets::pickerInput("resInput","Resilience & Business", 
                              choices=filter(eva_vars, type == "business")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"),
                              multiple = T,
                              selected = filter(eva_vars, type == "business")$name)

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
 
