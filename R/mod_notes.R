#' notes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_notes_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::div(
      id = "notes",
      includeMarkdown(system.file("app/www/notes.md", package = "eva.app"))
    )
  )
}
    
#' notes Server Function
#'
#' @noRd 
mod_notes_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_notes_ui("notes_ui_1")
    
## To be copied in the server
# callModule(mod_notes_server, "notes_ui_1")
 
