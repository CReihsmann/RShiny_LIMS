# pulls functions for login
source('module_login.R')

shinyServer(function(input, output) {
    
    source('plots.R', local = T)
    source('api_filter.R', local = T)
    source('datatables.R', local = T)
    source('ui_home.R', local = T)
    source('ui_plots.R', local = T)
    source('ui_tables.R', local = T)
    
    
#   ----------------------
#    Modules
#   ----------------------

    # calls modules from module_login.R
    
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
})
