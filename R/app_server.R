#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here

  
  output$num_trips <- renderText({
    d_clean %>% 
      filter(trip_or_order_status == "COMPLETED") %>% 
      nrow()
  })
  
}
