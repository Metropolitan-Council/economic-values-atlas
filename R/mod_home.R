#' home UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_home_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    tabPanel("HOME", value = "home",
             
             shinyjs::useShinyjs(),
             
             tags$head(tags$script(HTML('
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName("a");
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute("data-value") == tabName) {
                                                       link.click();
                                                       };
                                                       }
                                                       };
                                                       ')))),

    
    fluidRow(
      HTML("
                                     
                                     <section class='banner'><br><br>
                                     <h2 class='parallax'>ECONOMIC VALUES ATLAS DEMO</h2>
                                     <p class='parallax_description'>A demonstration of how RShiny could be used with the EVA project.</p>
                                     </section>
                                     ")
    ),
    
    tags$hr(),
    
    # WAHT
    fluidRow(name = "what",
      column(7,
             shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
             shiny::HTML("<p>An interactive tool exploring the economic values of the Twin Cities region. The economic values are specific to our region and are shaped by our 30-year regional plan. We seek to promote sustainable infrastructure development, a resilient economy, and shared prosperity throughout our region.
                         <br><br> This project is motivated by the fact that our region shares common goals for ecomonic development (as outlined in Thrive 2040 and predecessors), and yet divergent outcomes for economic prosperity exist across our region. Developing and leveraging this 'economic values atlas' (EVA) with a shared language for economic development is one proposed intervention. EVA can bring an objective lens to project evaluation and decision-making processes that guide regional economic investments, re-investments, and development.
                         <br><br> Here we have synthesized existing and complex datasources to produce accessible conclusions. This tool allows users to find 'opportunity zones' where economic investments could have disproportionately positive impacts for the future prosperity of our entire region.<br></p>")
      ),
      column(5,
             div(style="display: inline-block;",img(src="www/eva_schematic.png", height=500)))
    ),
  
    
    tags$hr()
    
    
  )
}
    
#' home Server Function
#'
#' @noRd 
mod_home_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_home_ui("home_ui_1")
    
## To be copied in the server
# callModule(mod_home_server, "home_ui_1")
 
