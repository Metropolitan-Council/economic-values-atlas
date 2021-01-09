#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
 
    navbarPage(title = img(src="www/main-logo.png", height = "70px"), id = "navBar",
                theme = "www/style.css",
                collapsible = TRUE,
                inverse = TRUE,
                windowTitle = "EVA",
                position = "fixed-top",
                header = tags$style(
                  ".navbar-right {
                       float: right !important;
                       }",
                  "body {padding-top: 75px;}"),
               
               
               tabPanel("HOME", mod_home_ui("home_ui_1")
    ),
    
    tabPanel("MAP", 
             sidebarPanel(mod_layerselection_ui("layerselection_ui_1")),
             mainPanel(
               
               fluidRow(mod_evamap_ui("evamap_ui_1")),
               hr(),
               fluidRow(mod_evabar_ui("evabar_ui_1")),
               hr(),
               fluidRow(mod_evaspider_ui("evaspider_ui_1")),
               
                 )
               ),
    
    tabPanel("NOTES", mod_notes_ui("notes_ui_1"))
    
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'eva_app'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

