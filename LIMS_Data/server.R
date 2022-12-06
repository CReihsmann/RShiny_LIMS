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
 
  
  validate_password_module <- callModule(
    module = validate_credentials,
    id = 'module_login'
  )
  
  username <- callModule(
    module = username_func,
    id = 'module_login'
  )
  
  password <- callModule(
    module = password_func,
    id = 'module_login'
  )
  
  output$username <- renderText(username())
  
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
