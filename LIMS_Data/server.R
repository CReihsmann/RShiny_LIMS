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
  
  validate_password_module <- callModule(
    module = validate_credentials,
    id = 'module_login'
  )
  
  # data_module <- callModule(
  #   module = generate_data,
  #   id = 'module_login'
  # )
  
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
  
  output$display_plots <- renderUI({
    req(validate_password_module())
    
    tabsetPanel(type = 'tabs',
                tabPanel('Barcharts',
                         sidebarPanel(
                           width = 3,
                           radioButtons(
                             'bar_primary',
                             'Primary Filter',
                             choices = list('Age Group' = 'AGE_GROUPS',
                                            'Race' = 'CI_DONOR_RACE',
                                            'Isolation Center' = 'ISLETS_ISOLATION_CENTER',
                                            'Year Processed' = 'YEAR',
                                            'Disease Status' = 'CI_DONOR_DISEASE'),
                                       ),
                           radioButtons(
                             'bar_secondary',
                             'Secondary Filter',
                             choices = list('None' = '',
                                            'Sex' = 'CI_DONOR_GENDER',
                                            'Age Group' = 'AGE_GROUPS',
                                            'Race' = 'CI_DONOR_RACE',
                                            'Isolation Center' = 'ISLETS_ISOLATION_CENTER',
                                            'Year Processed' = 'YEAR',
                                            'Disease Status' = 'CI_DONOR_DISEASE')
                           )
                                      ),
                         mainPanel(
                           plotlyOutput('barChart')
                           # dataTableOutput('table')
                           )
                ),
                # dataTableOutput('table')),
                tabPanel('Histograms'),
                tabPanel('Boxplots'))
    
  })
  
  
  output$table <-renderDataTable({imported_data()})
  
  output$text <- renderText(username())
  
})
