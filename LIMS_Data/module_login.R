#   ---------------
#    UI COMPONENTS
#   ---------------

# creates ui for log in
login_ui <- function(id, title) {
  
  ns <- NS(id) #namespace id
  
  div(
    id = ns('login'),
    style = "width: 500px; max-width: 100%; margin: 0 auto;",
    
    div(
      class = 'well',
      h4(class='text-center', title),
      
      textInput(
        inputId = ns('lims_email'),
        label = tagList(icon('user'),
                        'User Name'),
        placeholder = 'Enter user name'
      ),
      
      passwordInput(
        inputId = ns('lims_password'), 
        label = tagList(icon('unlock-alt'),
                        'Password'),
        placeholder = 'Enter password'
      ),
      
      div(
        class = 'text-center',
        actionButton(
          inputId = ns('login_button'),
          label = 'Log in',
          class = 'btn-primary'
          
        )
      )
    )
  )
}

# directs user to home tab from plot tab
plot_login_ui <- function(id, title) {
  
  ns <- NS(id) #namespace id
  
  div(
    id = ns('plot_login'),
    style = "width: 500px; max-width: 100%; margin: 0 auto;",
    
    div(
      class = 'well',
      h3(class = 'text-center', title)
    )
  )
}

# directs user to home tab from tables tab
table_login_ui <- function(id, title) {
  
  ns <- NS(id) #namespace id
  
  div(
    id = ns('table_login'),
    style = "width: 500px; max-width: 100%; margin: 0 auto;",
    
    div(
      class = 'well',
      h3(class = 'text-center', title)
    )
  )
}

#   ------------------
#    SERVER COMPONENTS
#   ------------------

#' takes username and password from login_ui()
#' and using metadata api call verifies permissions
validate_credentials <- function(input, output, session) {
  
  eventReactive(input$login_button,
                {
                  response = GET(login_url,
                                 authenticate(user = input$lims_email,
                                              password = input$lims_password,
                                              type = 'basic'))
                  
                  validate <- F
                  
                  if(response$status_code == 200) {
                    validate <- T
                  }
                  
                  #hide login when user confirmed 
                  if(validate) {
                    shinyjs::hide(id = 'login')
                    shinyjs::hide(id = 'plot_login')
                    shinyjs::hide(id = 'table_login')
                  }
                  
                  validate
                })
  
  
  
}

#' takes username from login_ui() to pass
#' server and be used for data api call
username_func <- function(input, output, session) {
  eventReactive(input$login_button,
                {
                  input$lims_email
                })
  
}

#' takes password from login_ui() to pass
#' server and be used for data api call
password_func <- function(input, output, session) {
  eventReactive(input$login_button,
                {
                  input$lims_password
                })
  
}
