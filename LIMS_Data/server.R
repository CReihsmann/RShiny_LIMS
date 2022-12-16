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
                tabPanel(
                  'Barcharts',
                  sidebarPanel(
                    width = 3,
                    radioButtons(
                      'bar_primary',
                      'Primary Filter',
                      choices = list('Age Groups',
                                     'Race',
                                     'Isolation Center',
                                     'Year',
                                     'Donor Disease'),
                    ),
                    radioButtons(
                      'bar_secondary',
                      'Secondary Filter',
                      choices = list('None' = '',
                                     'Gender',
                                     'Age Groups',
                                     'Race',
                                     'Isolation Center',
                                     'Year',
                                     'Donor Disease')
                    )
                  ),
                  mainPanel(
                    plotOutput('barChart')
                    # dataTableOutput('table')
                  )
                ),
                tabPanel(
                  'Histograms',
                  sidebarPanel(
                    selectizeInput(
                      'numeric_choices',
                      'Numeric Filter',
                      choices = as.list(numeric_cols),
                      options = list(
                        placeholder = 'Please select Numeric Column',
                        onInitialize = I('function() { this.setValue (""); }')
                        )
                    ),
                    sliderInput(
                      'bin_slider',
                      'Number of Bins',
                      min = 30,
                      max = 100,
                      value = 30
                    ),
                    selectizeInput(
                      'histo_initial_filt',
                      'Filter By',
                      choices = as.list(histo_filt),
                      options = list(
                        placeholder = 'Select filter',
                        onInitialize = I('function() { this.setValue (""); }')
                      )
                    ),
                  ),
                  mainPanel(
                    plotOutput('histogram')
                  )
                  ),
                tabPanel('Boxplots'))
    
  })
  
  
  output$table <-renderDataTable({plot_df()})
  
  output$text <- renderText(username())
  
})
