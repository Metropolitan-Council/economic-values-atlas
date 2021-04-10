#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    tableOutput(ns("table"))
    
  )
}
    
#' table Server Function
#'
#' @noRd 
mod_table_server <- function(input, output, session,
                             tract_selections = tract_selections,
                             map_util = map_util){
  ns <- session$ns
 
  make_table_vals <-  reactive({

    selected_tract <- map_util$plot_data2 %>%
      # eva_data_main %>%
      ungroup() %>%
      group_by(tr10) %>%
      summarise(`Average z-score` = mean(opportunity_zscore, na.rm = T))
    
    all_tracts <- #eva_data_main %>% 
      map_util$plot_data2 %>%
      ungroup() %>%
      select(tr10, name, raw_value, opportunity_zscore) %>%
      pivot_wider(names_from = c(name), values_from = c(opportunity_zscore, raw_value)) 
    names(all_tracts) <- gsub(x = names(all_tracts), pattern = "opportunity_zscore_", replacement = "Z-score; ")
    names(all_tracts) <- gsub(x = names(all_tracts), pattern = "raw_value_", replacement = "Raw value; ")
    
    fulltable <- full_join(selected_tract, all_tracts) %>%
      rename(`Tract ID` = tr10)

    return(fulltable)
  })
  
  output$table <- renderTable({
    if(identical(tract_selections$selected_tract, character(0))) {
      print("nodata")
      tibble()
    } else {
      make_table_vals()
    }
  })
}
    
## To be copied in the UI
# mod_table_ui("table_ui_1")
    
## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
 
