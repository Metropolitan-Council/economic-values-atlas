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
#' @import ggplot2
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
    # st_drop_geometry() %>%
    group_by(name) %>% 
    summarise(MEAN = mean(opportunity_zscore, na.rm = T))
    return(p)
  })

  make_selected_vals <-  reactive({
    p <- map_util$plot_data2 %>%
    ungroup() %>%
    # st_drop_geometry() %>%
    filter(tr10 %in% tract_selections$selected_tract)
    return(p)
  })
  
  make_niceplot <- reactive({
    p <- if(is.numeric(tract_selections$selected_tract)) {
      ggplot() +
        geom_point(data = make_tract_avgs, aes(y = name, x = opportunity_zscore), col = "black") 
    } else {
      ggplot() +
        geom_point(data = eva_vars, aes(y = name, x = n), col = "green")
    }
    return(p)
  })
  
  # vals2 <- reactiveValues()
  # 
  # observe({
  #   vals2$avgs <- make_tract_avgs()
  # })
  # 
  # observe({
  #   vals2$selected <- make_selected_vals()
  # })
  # 
  # 
  # return(vals2)
  
  
  # output$bargraph <- renderPlot({
  #   print("making graph")
  #   ggplot() + geom_point(aes(x = MEAN, y = name), data = make_tract_avgs())
  #   # vals2$niceplot
  #     # ggplot() +
  #     #   geom_point(data = make_tract_avgs, aes(y = name, x = opportunity_zscore), col = "black") +
  #     # # geom_point(data = make_selected_vals, aes(y = name, x = opportunity_zscore), col = "blue") +
  #     # theme_bw() #+
  #     # scale_fill_brewer(palette = "Paired") +
  #     # facet_grid(Category~.,  space = "free_y", scales = "free_y") +
  #     # theme(legend.position = "bottom")
  # })
  
  
  
  
  #### more elegant??
  make_plot_vals <-  reactive({
    selected_tract <- map_util$plot_data2 %>%
      ungroup() %>%
      filter(tr10 == tract_selections$selected_tract) %>%
      rename(ZSCORE = z_score,
             RAW = raw_value) %>%
      mutate(dsource = "Selected tract") %>%
      select(name, ZSCORE, RAW, dsource)
    
    tract_avgs <- map_util$plot_data2 %>%
      # eva.app::eva_data_main %>%
      ungroup() %>%
      group_by(name) %>% 
      summarise(ZSCORE = mean(opportunity_zscore, na.rm = T),
                RAW = mean(raw_value, na.rm = T)) %>%
      mutate(dsource = "All tracts \n(average)")
    
    toplot <- bind_rows(selected_tract, tract_avgs)
    
    return(toplot)
  })
  
  output$bargraph <- renderPlot({
    print("making graph")
    ggplot() + geom_point(aes(x = ZSCORE, y = name, col = dsource), data = make_plot_vals()) +
    # vals2$niceplot
    # ggplot() +
    #   geom_point(data = make_tract_avgs, aes(y = name, x = opportunity_zscore), col = "black") +
    # # geom_point(data = make_selected_vals, aes(y = name, x = opportunity_zscore), col = "blue") +
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
 
