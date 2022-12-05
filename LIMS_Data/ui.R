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
      
      # div(
      #   id = 'login',
      #   style = "width: 500px; max-width: 100%; margin: 0 auto;",
      #   
      #   div(
      #     class = 'well',
      #     h4(class='text-center', 'Login'),
      #     
      #     textInput(
      #       inputId = 'lims_email',
      #       label = tagList(icon('user'),
      #                       'User Name'),
      #       placeholder = 'Enter user name'
      #     ),
      #     
      #     passwordInput(
      #       inputId = 'lims_password', 
      #       label = tagList(icon('unlock-alt'),
      #                 'Password'),
      #       placeholder = 'Enter password'
      #     ),
      #     
      #     div(
      #       class = 'text-center',
      #       actionButton(
      #         inputId = 'login_button',
      #         label = 'Log in',
      #         class = 'btn-primary'
      #         
      #       )
      #     )
      #   )
      # ),
      login_ui(id='module_login', title = 'Login'),
      
      uiOutput(outputId = 'display_app')
    )
  )
)
