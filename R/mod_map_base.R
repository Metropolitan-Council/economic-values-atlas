#' map_base UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_base_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' map_base Server Function
#'
#' @noRd 
mod_map_base_server <- function(input, output, session){
  ns <- session$ns
  
  output$ns <-renderLeaflet(quoted = TRUE, { #  map --------
    leaflet() %>%
      setView(
        lat = st_coordinates(map_centroid)[2], #44.963,
        lng = st_coordinates(map_centroid)[1], #-93.22,
        zoom = 10
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
}
    
## To be copied in the UI
# mod_map_base_ui("map_base_ui_1")
    
## To be copied in the server
# callModule(mod_map_base_server, "map_base_ui_1")
 
