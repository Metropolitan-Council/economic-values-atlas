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
    
    pickerInput(
      inputId = "myPicker", 
      label = "Select/deselect all + format selected", 
      choices = LETTERS, 
      options = list(
        `actions-box` = TRUE, 
        size = 10,
        `selected-text-format` = "count > 3"
      ), 
      multiple = TRUE
    ),
    br(),
    shinyWidgets::pickerInput("equityInput","Equity & People", choices=c("Poverty level (% households below 185% poverty line)", "% BIPOC persons"), options = list(`actions-box` = TRUE, 
                size = 10,
      `selected-text-format` = "count > 1"), multiple = T),
    hr(),
    
    shinyWidgets::pickerInput("infInput","Infrastructure & Place", choices=c("Number of jobs accessible in 20 min, peak am SOV", "Land value", "Floor area ratio"), options = list(`actions-box` = TRUE),multiple = T),

    shinyWidgets::pickerInput("resInput","Resilience & Business", choices=c("Total jobs", "Employment sector evenness", "Average employees per establishment"), options = list(`actions-box` = TRUE),multiple = T)

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
 
