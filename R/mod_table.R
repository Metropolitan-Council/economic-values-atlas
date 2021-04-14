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
    dataTableOutput(ns("table"))
    
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
      filter(tract_string == tract_selections$selected_tract) %>%
      # eva_data_main %>%
      ungroup() %>%
      select(name, raw_value, overall_rank, COUNT)  %>%
      mutate(raw_value= round(raw_value, 1)) %>%
      mutate_if(is.numeric, format, big.mark = ",")  %>%
      rename(`Selected tract` = raw_value,
             `Rank of variable` = overall_rank,
             `Total tracts with data` = COUNT)
    
    avg_tracts <- #
      # eva_data_main %>% 
      map_util$plot_data2 %>%
      ungroup() %>%
      group_by(name) %>%
      summarise(`Average tract`= round(mean(raw_value, na.rm = T), 1)) %>%
      mutate_if(is.numeric, format, big.mark = ",") 
    
    fulltable <- full_join(avg_tracts, selected_tract) %>%
      rename(`Variable name` = name)
    
    return(fulltable)
  })
  
  output$table <- renderDataTable({
    if(identical(tract_selections$selected_tract, character(0))) {
      print("nodata")
      tibble()
    } else {
      (make_table_vals()
       # options = list(pageLength =5)
       )
    }
  })
}
    
## To be copied in the UI
# mod_table_ui("table_ui_1")
    
## To be copied in the server
# callModule(mod_table_server, "table_ui_1")
 
