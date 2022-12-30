#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
source('module_login.R')
# Define server logic required to draw a histogram
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

#   ----------------------
#    Downloads
#   ----------------------
    
    # instructs download of csv of filtered tables
    
    # output$download_lims <- downloadHandler(
    #     filename = 'categorized_data.csv',
    #     content = function(file) {
    #         write_csv(lims_df(), file)
    #     }
    # )
    # 
    # output$download_personalized <- downloadHandler(
    #     filename = 'personalized_data.csv',
    #     content = function(file) {
    #         write_csv(personalized_df(), file)
    #     }
    # )
    
    # output$freezer <- renderText({
    #     imported_data() %>% 
    #         filter(Name == input$donor_freezer) %>% 
    #         pull(`Freezer Box Location(s)`)
    #     
    # })
    # 
    # output$assorted <- renderText({
    #     imported_data() %>% 
    #         filter(Name == input$donor_assorted) %>% 
    #         pull(!!as.name(input$column_assorted))
    # })
})
