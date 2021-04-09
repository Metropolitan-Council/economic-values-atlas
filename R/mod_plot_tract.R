#' plot_tract UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_tract_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    plotOutput(ns("bargraph"), height = 500)
    
  )
}
    
#' plot_tract Server Function
#'
#' @noRd 
mod_plot_tract_server <- function(input, output, session,
                                  tract_selections = tract_selections,
                                  map_util = map_util){
  ns <- session$ns
  
  #we need to make this data for a bar plot, or something like that
  make_plot_data2 <- reactive({
    p <- eva.app::eva_data_main %>% 
      filter(name %in% map_selections$allInputs$value)
    return(p)
  })
  
  make_tract_avgs <- reactive({
    p <- map_util$plot_data2 %>%
    ungroup() %>%
    st_drop_geometry() %>%
    group_by(name) %>% 
    summarise(MEAN = mean(opportunity_zscore, na.rm = T))
    return(p)
  })

  make_selected_vals <-  reactive({
    p <- map_util$plot_data2 %>%
    ungroup() %>%
    st_drop_geometry() %>%
    filter(tr10 %in% tract_selections$selected_tract)
    return(p)
  })
  
  output$bargraph <- renderPlot({
      ggplot() +
      geom_point(data = eva_vars, aes(y = name, x = n), col = "black") +
      # geom_point(data = make_tract_avgs, aes(y = name, x = opportunity_zscore), col = "black") +
      # geom_point(data = make_selected_vals, aes(y = name, x = opportunity_zscore), col = "blue") +
      theme_bw() #+
      # scale_fill_brewer(palette = "Paired") +
      # facet_grid(Category~.,  space = "free_y", scales = "free_y") +
      # theme(legend.position = "bottom")
    
  })
 
}
    
## To be copied in the UI
# mod_plot_tract_ui("plot_tract_ui_1")
    
## To be copied in the server
# callModule(mod_plot_tract_server, "plot_tract_ui_1")
 
