#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source('module_login.R')
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # validate_credentials <- eventReactive(input$login_button,
  #                                       {
  #                                         response = GET(lims_url,
  #                                                        add_headers(.headers = headers),
  #                                                        authenticate(user = input$lims_email,
  #                                                                     password = input$lims_password,
  #                                                                     type = 'basic'))
  #                                         
  #                                         validate <- F
  #                                         
  #                                         if(response$status_code == 200) {
  #                                           validate <- T
  #                                         }
  #                                       }
  #   
  # )
  # 
  # observeEvent(validate_credentials(), {
  #   shinyjs::hide(id = 'login')
  # })
  # 

  
  validate_password_module <- callModule(
    module = validate_credentials,
    id = 'module_login'
  )
  
  username <- callModule(
    module = username,
    id = 'module_login'
  )
  
  password <- callModule(
    module = password,
    id = 'module_login'
  )
  
  output$display_app <- renderUI({
    req(validate_password_module())
    
    div(
      class = "bg-success",
      id = "success_basic",
      h4("Access confirmed!"),
      p("Welcome to your basically-secured application!")
    )
  })

})
