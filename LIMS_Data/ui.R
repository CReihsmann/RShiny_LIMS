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
      title = 'Plots',
      useShinyjs(),
      
      plot_login_ui(id='module_login', title = 'Navigate to Home Tab \n to Login'),
      
      uiOutput(outputId = 'display_plots')
      
    ),
    tabPanel(
      title = 'Tables',
      useShinyjs(),
      
      table_login_ui(id='module_login', title = 'Navigate to Home Tab \n to Login'),
      
      uiOutput(outputId = 'display_tables')
      
    )
  )
)
