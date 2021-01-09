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
    
    #WAHT
    fluidRow(
      column(3),
      column(6,
             shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
             shiny::HTML("<h5>An interactive tool exploring the economic values of the Twin Cities region. These values are specific to our region and are shaped by our 30-year regional plan. We seek to promote sustainable infrastructure development, a resilient economy, and shared prosperity throughout our region.</h5>")
      ),
      column(3)
    ),
    
    tags$hr(),
    
    # HOW
    fluidRow(
      column(3),
      column(6,
             shiny::HTML("<br><br><center> <h1>How it can help you</h1> </center><br>"),
             shiny::HTML("<h5>Integrating information about spatial patterns in business, people, and place can help articulate and define opportunities and track results.bro</h5>")
      ),
      column(3)
    ),
    
    tags$hr(),
    
    #FUTURE
    fluidRow(
      column(3),
      column(6,
             shiny::HTML("<br><br><center> <h1>What's coming next</h1> </center><br>"),
             shiny::HTML("<h5>Future goals, etc.</h5>")
      ),
      column(3)
    )
    
    
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
 
