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

    # selected_tract <- map_util$plot_data2 %>%
    #   # eva_data_main %>%
    #   ungroup() %>%
    #   group_by(tract_string) %>%
    #   summarise(`Average z-score` = mean(opportunity_zscore, na.rm = T))
    
    # all_tracts <- #eva_data_main %>% 
    #   map_util$plot_data2 %>%
    #   ungroup() %>%
    #   select(tract_string, name, raw_value) %>% #, opportunity_zscore) %>%
    #   pivot_wider(names_from = c(name), values_from = c(raw_value))#c(opportunity_zscore, raw_value)) 
    # names(all_tracts) <- gsub(x = names(all_tracts), pattern = "opportunity_zscore_", replacement = "Z-score; ")
    # names(all_tracts) <- gsub(x = names(all_tracts), pattern = "raw_value_", replacement = "Raw value; ")
    
    # fulltable <- full_join(selected_tract, all_tracts) %>%
    #   rename(`Tract ID` = tract_string)

    
    selected_tract <- map_util$plot_data2 %>%
      filter(tract_string == tract_selections$selected_tract) %>%
      # eva_data_main %>%
      ungroup() %>%
      select(name, raw_value)  %>%
      mutate(raw_value= round(raw_value, 1)) %>%
      mutate_if(is.numeric, format, big.mark = ",")  %>%
      rename(`Selected tract` = raw_value)
    
    avg_tracts <- #
      # eva_data_main %>% 
      map_util$plot_data2 %>%
      ungroup() %>%
      group_by(name) %>%
      summarise(`Average tract`= round(mean(raw_value, na.rm = T), 1)) %>%
      mutate_if(is.numeric, format, big.mark = ",") 
    
    fulltable <- full_join(selected_tract, avg_tracts) %>%
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
 
