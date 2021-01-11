#' layerselection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_layerselection_ui <- function(id){
  ns <- NS(id)
  tagList(

      HTML("<form class='well'>
                  <div id='layerselection_ui_1-input_eva' class='form-group shiny-input-checkboxgroup shiny-input-container shiny-bound-input'>
                    <label class='control-label' id='layerselection_ui_1-input_eva-label' for='layerselection_ui_1-input_eva'>
                    
                      <h5>Map Layers</h5>
                    </label>
                    <div class='shiny-options-group'>
                    
                    

                      
                                            <h6>Equity</h6>

                      <div class='checkbox'>
                        <label>
                          <input type='checkbox' name='layerselection_ui_1-input_eva' value='avgcommute' checked='checked'>
                          <span>Commute length</span>
                        </label>
                      </div>
                      <div class='checkbox'>
                        <label>
                          <input type='checkbox' name='layerselection_ui_1-input_eva' value='pov185rate'>
                          <span>Concentrated poverty</span>
                        </label>
                      </div>
                                   
                                          <h6>Infrastructure</h6>

                      <div class='checkbox'>
                        <label>
                          <input type='checkbox' name='layerselection_ui_1-input_eva' value='jobs'>
                          <span>Existing jobs</span>
                        </label>
                      </div>       
                      
                    </div>
                  </div>
                </form>")
    ) 
}

    
#' layerselection Server Function
#'
#' @noRd 
mod_layerselection_server <- function(input, output, session){
  ns <- session$ns
 
  input_values <- reactiveValues() # start with an empty reactiveValues object.
  
  observeEvent(input$input_eva, { # only update when the user changes the eva input
    input_values$input_eva <- input$input_eva # create/update the eva input value in our reactiveValues object
  })
  
  return(input_values)
  
}
    
## To be copied in the UI
# mod_layerselection_ui("layerselection_ui_1")
    
## To be copied in the server
# callModule(mod_layerselection_server, "layerselection_ui_1")
 



# 
# <h6>Infrastructure</h6>
#   
#   <div class='checkbox'>
#   <label>
#   <input type='checkbox' name='layerselection_ui_1-input_eva' value='adj_anydis_per'>
#   <span>Highway accessibility</span>
#   </label>
#   </div>
#   <div class='checkbox'>
#   <label>
#   <input type='checkbox' name='layerselection_ui_1-input_eva' value='adj_anydis_per'>
#   <span>Job density</span>
#   </label>
#   </div>
#   
#   <h6>Resilience</h6>
#   
#   <div class='checkbox'>
#   <label>
#   <input type='checkbox' name='layerselection_ui_1-input_eva' value='adj_ageunder15_per'>
#   <span>Job sector diversity</span>
#   </label>
#   </div>
  
