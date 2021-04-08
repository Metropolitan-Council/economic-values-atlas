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
    
    shinyWidgets::pickerInput(ns("peopleInput"),
                              label = shiny::HTML(paste0("<h4>Equity & People</h4>", "Some description about this group of variables.")), 
                              choices = filter(eva_vars, type == "people")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = filter(eva_vars, type == "people")$name),
    hr(),
    shinyWidgets::pickerInput(ns("placeInput"),
                              label = shiny::HTML("<h4>Infrastructure & Place</h4>Some description about this group of variables."), 
                              choices=filter(eva_vars, type == "place")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"), 
                              multiple = T,
                              selected = filter(eva_vars, type == "place")$name),
    
    hr(),
    shinyWidgets::pickerInput(ns("businessInput"),
                              label = shiny::HTML("<h4>Resilience & Business</h4>Some description about this group of variables."), 
                              choices=filter(eva_vars, type == "business")$name, 
                              options = list(`actions-box` = TRUE, 
                                             size = 10,
                                             `selected-text-format` = "count > 1"),
                              multiple = T,
                              selected = filter(eva_vars, type == "business")$name),
    
    hr(),
    actionButton(ns("goButton"), "Update map", class = "btn-success"),
    
    # shiny::h4("Selected variables"),
    textOutput(ns("selectedvars0")),
    # textOutput(ns("selectedvars25"))
    

  )
}
    
#' map_selections Server Function
#'
#' @noRd 
mod_map_selections_server <- function(input, output, session){
  ns <- session$ns
  
  output$selectedvars0 <- renderPrint({
    input$goButton
    toprint <- isolate(input$peopleInput %>% 
      rbind(input$placeInput) %>%
        rbind(input$businessInput))
    toprint
    })
  # output$selectedvars25 <- renderText(input$peopleInput %>% rbind(input$placeInput))
  
  input_values <- reactiveValues() # start with an empty reactiveValues object.
  
  # eventReactive(input$goButton, {
  #   input_values$buttonInput <- input$peopleInput
  # })
  # 
  # observeEvent(input$peopleInput, { # only update when the user changes the eva input
  #   input_values$peopleInput <- input$peopleInput # create/update the eva input value in our reactiveValues object
  # })
  # 
  # observeEvent(input$placeInput, { # only update when the user changes the eva input
  #   input_values$placeInput <- input$placeInput # create/update the eva input value in our reactiveValues object
  # })
  # 
  # observeEvent(input$businessInput, { # only update when the user changes the eva input
  #   input_values$businessInput <- input$businessInput # create/update the eva input value in our reactiveValues object
  # })
  
  return(input_values)
  
}
    
## To be copied in the UI
# mod_map_selections_ui("map_selections_ui_1")
    
## To be copied in the server
# callModule(mod_map_selections_server, "map_selections_ui_1")
 
