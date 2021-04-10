#' map_overview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_overview_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    leafletOutput(ns("map"), height = 700)#,
    
    # wellPanel(textOutput(ns("selected_tract")))
    
  )
}
    
#' map_overview Server Function
#'
#' @noRd 
mod_map_overview_server <- function(input, output, session,
                                    map_selections,
                                    map_util){
  ns <- session$ns
  
  # base leaflet -------------
  output$map <-renderLeaflet({ #  map --------
    leaflet() %>%
      setView(
        lat = 44.963,
        lng = -93.22,
        zoom = 9
      ) %>%
      addMapPane(name = "Stamen Toner", zIndex = 430) %>%
      addProviderTiles("Stamen.TonerLines",
                       group = "Stamen Toner"
      ) %>%
      addProviderTiles("Stamen.TonerLabels", 
                       options = leafletOptions(pane = "Stamen Toner"),
                       group = "Stamen Toner") %>%
      
      addMapPane(name = "Carto Positron", zIndex = 430) %>%
      addProviderTiles("CartoDB.PositronOnlyLabels", 
                       options = leafletOptions(pane = "Carto Positron"),
                       group = "Carto Positron") %>%
      addProviderTiles("CartoDB.PositronNoLabels",
                       group = "Carto Positron"
      ) %>%
      addProviderTiles(
        provider = providers$Esri.WorldImagery,
        group = "Esri Imagery"
      ) %>%
      
      
      # addMapPane("trans", zIndex = 430) %>%
      # addCircles(
      #   data = eva.app::trans_stops,
      #   group = "Transit",
      #   radius = 20,
      #   fill = T,
      #   stroke = TRUE,
      #   weight = 2, 
      #   color = councilR::colors$transitRed,
      #   fillColor = councilR::colors$transitRed,
      #   options = pathOptions(pane = "trans")
      # ) %>%
      # 
      # addMapPane("tractoutline", zIndex = 699) %>%
      # addPolygons( #just need to add the tract outline
      #   data = eva_tract_geometry,
      #   stroke = T, weight = .2,
      #   fillColor = "black", 
      #   fillOpacity = 0,
      #   color = councilR::colors$suppGray,
      #   popup = ~paste0("Tract ID: ", eva_tract_geometry$GEOID), #eva_tract_geometry
      #   highlightOptions = highlightOptions(
      #     stroke = TRUE,
      #     color = "black",
      #     weight = 6,
      #     bringToFront = TRUE
      #   ),
      #   options = pathOptions(pane = "tractoutline"),
      #   layerId = ~GEOID) %>%
      # 
      addLayersControl(
        position = "bottomright",
        # overlayGroups = c(),
        baseGroups = c(
          "Carto Positron",
          "Stamen Toner",
          "Esri Imagery"
        ),
        options = layersControlOptions(collapsed = T)
      ) %>%
      hideGroup(c("Transit")) 
  })
  
  
  # #printing this works, but unclear how to save it....  
  # map_layer_selection <- reactiveValues()
  # observe({
  #   selected_groups <- req(input$map_groups)
  #   # print(selected_groups)
  #   return(selected_groups)
  #   })
  
  #leaflet observe events -----------
  
  # this stackoverflow was helpful: https://stackoverflow.com/questions/47465896/having-trouble-with-leafletproxy-observeevent-and-shiny-leaflet-application
  
  toListen_mainleaflet <- reactive({
    list(
      # current_tab,
      map_util$map_data2,
      map_selections$goButton
    )
  })
  
  observeEvent(toListen_mainleaflet(),
               {
                 if (is.null(map_util$map_data2)) {
                   print('nodata')
                 } else {
                   print("rendering polygons")
                   leafletProxy("map") %>%
                     clearGroup("zscore") %>%
                     addMapPane("zscore", zIndex = 400) %>%
                     addPolygons(
                       data = map_util$map_data2 %>% st_transform(4326),
                       group = "zscores",
                       stroke = TRUE,
                       color = councilR::colors$suppGray,
                       opacity = 0.9,
                       weight = 0.25,
                       fillOpacity = 0.7,
                       smoothFactor = 0.2,
                       fillColor = ~ colorNumeric(
                         n = 5,
                         palette = "BrBG",
                         domain = map_util$map_data2 %>% select("MEAN") %>% .[[1]]
                       )(map_util$map_data2 %>% select("MEAN") %>% .[[1]]),
                       popup = ~paste0("Tract ID: ", map_util$map_data2$tr10, 
                                       "<br>Average z-score: ", round(map_util$map_data2$MEAN, 3),
                                       "<br>Rank of z-score: ", map_util$map_data2$RANK, " out of ", nrow(map_util$map_data2)),
                       options = pathOptions(pane = "zscore"),
                       layerId = ~tr10
                     ) %>%
                     
                     addLegend(
                       labFormat = labelFormat2(),#labelFormat(prefix = "(", suffix = ")", digits = 5),
                       title = "Average z-scores",
                       position = "bottomleft",
                       group = "zscores",
                       layerId = "zscores",
                       pal = colorNumeric(
                         n = 5,
                         palette = "BrBG",
                         domain = map_util$map_data2 %>% select("MEAN") %>% .[[1]]
                       ),
                       values = (map_util$map_data2 %>% select("MEAN") %>% .[[1]])
                     )
                   
                 }
               })
  

  #leaflet print geoid -----------
  
  #ideally want to do nested reactive values?!?
  #https://rtask.thinkr.fr/communication-between-modules-and-its-whims/
  #but this is not working out well for me right now....
  # r <- reactiveValues(test = reactiveValues())
  # observe({
  #   event <- input$map_shape_click
  #   r$test$selected_tract <- (tractoutline$GEOID[tractoutline$GEOID == event$id])
  # })
  # # return(selected_tract)
  
  # #this works, but want to save it
  # observe({
  #   event <- input$map_shape_click
  #   output$selected_tract <- renderText(map_util$map_data2$tr10[map_util$map_data2$tr10] == event$id)#renderText(tractoutline$GEOID[tractoutline$GEOID == event$id])
  # })

  #save the selected tract
  vals <- reactiveValues()
  observe({
    event <- input$map_shape_click
    vals$selected_tract <- (map_util$map_data2$tr10[map_util$map_data2$tr10 == event$id])#(tractoutline$GEOID[tractoutline$GEOID == event$id])
  })
  
  return(vals)
 
}
    
## To be copied in the UI
# mod_map_overview_ui("map_overview_ui_1")
    
## To be copied in the server
# callModule(mod_map_overview_server, "map_overview_ui_1")
 
