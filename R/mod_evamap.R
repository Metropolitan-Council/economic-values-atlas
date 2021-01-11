#' evamap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_evamap_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    leafletOutput(ns("map"), height = 700),
    
    wellPanel(textOutput(ns("selected_tract")))
    
  )
}
    
#' evamap Server Function
#'
#' @noRd 
mod_evamap_server <- function(input, output, session,
                              selected_map_vars,
                              util_layers){
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
      
      
      addMapPane("trans", zIndex = 430) %>%
      addCircles(
        data = eva_app::trans_stops,
        group = "Transit",
        radius = 20,
        fill = T,
        stroke = TRUE,
        weight = 2, 
        color = councilR::colors$transitRed,
        fillColor = councilR::colors$transitRed,
        options = pathOptions(pane = "trans")
      ) %>%
      
      addMapPane("tractoutline", zIndex = 699) %>%
      addPolygons( #just need to add the tract outline
        data = tractoutline,
        stroke = T, weight = .2,
        fillColor = "black", 
        fillOpacity = 0,
        color = councilR::colors$suppGray,
        popup = ~paste0("Tract ID: ", tractoutline$GEOID),
        highlightOptions = highlightOptions(
          stroke = TRUE,
          color = "black",
          weight = 6,
          bringToFront = TRUE
        ),
        options = pathOptions(pane = "tractoutline"),
        layerId = ~GEOID) %>%
      
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
   
  observeEvent(selected_map_vars$input_eva,
               {
                 if ("pov185rate" %in% selected_map_vars$input_eva)
                 {
                   leafletProxy("map") %>%
                     addPolygons(
                       data = eva_app::acs_tract %>% select("pov185rate"),
                       stroke = TRUE,
                       color = councilR::colors$suppGray,
                       opacity = 0.6,
                       weight = 0.25,
                       fillOpacity = 0.3,
                       smoothFactor = 0.2,
                       fillColor = ~ colorNumeric(
                         n = 9,
                         palette = "Blues",
                         domain = eva_app::acs_tract %>% select("pov185rate") %>% .[[1]]
                       )(eva_app::acs_tract %>% select("pov185rate") %>% .[[1]])
                     )
                 }
               })
  
  observeEvent(selected_map_vars$input_eva,
               {
                 if ("avgcommute" %in% selected_map_vars$input_eva)
                 {
                   leafletProxy("map") %>%
                     addPolygons(
                       data = eva_app::acs_tract %>% select("avgcommute"),
                       stroke = TRUE,
                       color = councilR::colors$suppGray,
                       opacity = 0.6,
                       weight = 0.25,
                       fillOpacity = 0.3,
                       smoothFactor = 0.2,
                       fillColor = ~ colorNumeric(
                         n = 9,
                         palette = "Blues",
                         domain = eva_app::acs_tract %>% select("avgcommute") %>% .[[1]]
                       )(eva_app::acs_tract %>% select("avgcommute") %>% .[[1]])
                     )
                 }
               })
  
  observeEvent(selected_map_vars$input_eva,
               {
                 if ("jobs" %in% selected_map_vars$input_eva)
                 {
                   leafletProxy("map") %>%
                     addPolygons(
                       data = eva_app::job_tract %>% select("jobs"),
                       stroke = TRUE,
                       color = councilR::colors$suppGray,
                       opacity = 0.6,
                       weight = 0.25,
                       fillOpacity = 0.3,
                       smoothFactor = 0.2,
                       fillColor = ~ colorNumeric(
                         n = 9,
                         palette = "Blues",
                         domain = eva_app::job_tract %>% select("jobs") %>% .[[1]]
                       )(eva_app::job_tract %>% select("jobs") %>% .[[1]])
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
  
  #this works, but want to save it
  # vals1 <- reactiveValues()
  observe({
    event <- input$map_shape_click
    output$selected_tract <- renderText(tractoutline$GEOID[tractoutline$GEOID == event$id])
    # print(selected_tract)
  })
  # return(vals1)
  

  # make_barg_data <- reactive({
  #   p <- eva_app::acs_tract %>%
  #     filter(GEOID == selected_tract) #%>%
  #     # select(selected_map_vars$input_eva)
  # })
  # 
  # vals2 <- reactiveValues()
  # observe({ 
  #   vasl2$barg_data <- make_barg_data()
  # })
  # print(vals2)
  
  # observe({
  #   vals <- make_map_data()
  #   print(vals)
  # })
    
}
    
## To be copied in the UI
# mod_evamap_ui("evamap_ui_1")
    
## To be copied in the server
# callModule(mod_evamap_server, "evamap_ui_1")
 
