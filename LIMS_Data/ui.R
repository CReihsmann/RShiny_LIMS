library(shiny)
source('module_login.R')

shinyUI(
  navbarPage(
    title = 'BLUE',
    collapsible = T,
    theme = shinytheme('flatly'),
    
    tabPanel(
      title = 'Home',
      useShinyjs(),
  
      login_ui(id='module_login', title = 'Login'),
      
      uiOutput(outputId = 'display_app')
    ),
    tabPanel(
      title = 'test',
      textOutput('username')
    )
  )
)
