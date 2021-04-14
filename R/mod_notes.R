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
    tags$iframe(style="height:600px; width:100%", src="www/notes.pdf"
    # div(style="display: inline-block;", embed(src="www/notes.pdf", height="100%")
    # shiny::div(
    #   id = "notes",
    #   includeMarkdown(system.file("app/www/notes.pdf", package = "eva.app"))
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
 
