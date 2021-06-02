#' download_scores UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_download_scores_ui <- function(id){
  ns <- NS(id)
  tagList(
    downloadButton(outputId = ns("download_button"), label = "Download all tract scores", style = "background-color:#5cb85c; color:#FFFFFF")
    
  )
}
    
#' download_scores Server Function
#'
#' @noRd 
mod_download_scores_server <- function(input, output, session,
                                       tract_selections = tract_selections,
                                       map_util = map_util){
  ns <- session$ns
  
  output$download_button <- downloadHandler(
    filename = paste0("EVA_", Sys.Date(), ".csv"),
    contentType = "text/csv",
    content = function(con) {
      utils::write.csv(
        x =
          map_util$map_data2 %>%
          as_tibble() %>%
          arrange(-MEAN) %>%
          rename(`Tract score` = MEAN,
                 `Score rank` = RANK) %>%
          select(-geometry),
        file = con,
        row.names = FALSE
      )
    }
  )
 
  
  
  
}
    
## To be copied in the UI
# mod_download_scores_ui("download_scores_ui_1")
    
## To be copied in the server
# callModule(mod_download_scores_server, "download_scores_ui_1")
 
