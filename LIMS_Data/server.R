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
        
        fluidPage(
            
            tags$style(HTML("
                            .myclass pre {
                            color: black;
                            background-color: #FFFFFF")),
            
            fluidRow(
                column(
                    6,
                    align = 'center',
                    h4(strong('Freezer Locations by Donor')),
                    wellPanel(
                        selectizeInput(
                            'donor_freezer',
                            'Donor Name',
                            choices = str_sort(unique(imported_data()$Name))
                        ),
                        h5(strong('Freezer Location')),
                        div(class = 'myclass',
                            verbatimTextOutput(
                                'freezer'))
                    )
                ),
                column(
                    6,
                    align = 'center',
                    h4(strong('Assorted Info by Donor')),
                    wellPanel(
                        selectizeInput(
                            'donor_assorted',
                            'Donor Name',
                            choices = str_sort(unique(imported_data()$Name))
                        ),
                        selectizeInput(
                            'column_assorted',
                            'Column',
                            choices = imported_data() %>% 
                                select(!contains(comments),
                                       -`Freezer Box Location(s)`,
                                       -Name) %>% 
                                colnames()
                        ),
                        h5(strong('Selected Data')),
                        div(class = 'myclass',
                            verbatimTextOutput(
                                'assorted'))
                    )
                )
            )
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
                                'Category to filter by',
                                choices = as.list(histo_filt),
                                options = list(
                                    placeholder = 'Select filter',
                                    onInitialize = I('function() { this.setValue (""); }')
                                )
                            ),
                            selectizeInput(
                                'histo_initial_filt_choices',
                                'Choices to filter by',
                                choices = NULL,
                                options = list(
                                    placeholder = 'Please Select Group Above',
                                    onInitialize = I('function() { this.setValue (""); }')
                                ),
                                multiple = T
                            ),
                            selectizeInput(
                                'histo_group',
                                'Group By',
                                choices = as.list(histo_filt),
                                options = list(
                                    placeholder = 'Select',
                                    onInitialize = I('function() { this.setValue (""); }')
                                )
                            ),
                            radioButtons(
                                'histo_orientation',
                                'Layout',
                                choices = list('dodge', 'identity', 'stack')
                            )
                        ),
                        mainPanel(
                            plotOutput('histogram')
                        )
                    ),
                    tabPanel('Boxplots'))
        
    })
    
    output$display_tables <- renderUI({
        req(validate_password_module())
        
        tabsetPanel(type = 'tabs',
                    tabPanel(
                        'Category',
                        sidebarPanel(
                            width = 3,
                            radioButtons(
                                'lims_div',
                                'Category',
                                choices = list('Basic Info',
                                               'Donor Info',
                                               'HLA',
                                               'Patient Info',
                                               'Sample Lots',
                                               'Processed',
                                               'All')
                            ),
                            selectizeInput(
                                'donors_lims',
                                'Donor:',
                                choices = unique(imported_data()$Name),
                                multiple = T
                            ),
                            numericInput(
                                'age_input_1_lims',
                                'Age Range (years):',
                                value = 0,
                                min = 0,
                                max = 100
                            ),
                            numericInput(
                                'age_input_2_lims',
                                NULL,
                                value = 100,
                                min = 0,
                                max = 100
                            ),
                            checkboxGroupInput(
                                'gender_lims',
                                'Gender:',
                                choices = c('Male',
                                            'Female',
                                            'Unknown'),
                                selected = c('Male',
                                             'Female',
                                             'Unknown')   
                            ),
                            checkboxGroupInput(
                                'race_lims',
                                'Race:',
                                choices = str_sort(unique(imported_data()$Race)),
                                selected = unique(imported_data()$Race)
                            ),
                            downloadButton(
                                'download_lims',
                                'Download'
                            )
                        ),
                        mainPanel(dataTableOutput('lims_table'))
                    ),
                    tabPanel(
                        'Personalized',
                        sidebarPanel(
                            width = 3,
                            selectizeInput(
                                'personalized',
                                'Add columns:',
                                choices = df_cols(),
                                multiple = T),
                            selectizeInput(
                                'donors_personalized',
                                'Donor:',
                                choices = unique(imported_data()$Name),
                                multiple = T
                            ),
                            numericInput(
                                'age_input_1_personalized',
                                'Age Range (years):',
                                value = 0,
                                min = 0,
                                max = 100
                            ),
                            numericInput(
                                'age_input_2_personalized',
                                NULL,
                                value = 100,
                                min = 0,
                                max = 100
                            ),
                            checkboxGroupInput(
                                'gender_personalized',
                                'Gender:',
                                choices = c('Male',
                                            'Female',
                                            'Unknown'),
                                selected = c('Male',
                                             'Female',
                                             'Unknown')   
                            ),
                            checkboxGroupInput(
                                'race_personalized',
                                'Race:',
                                choices = str_sort(unique(imported_data()$Race)),
                                selected = unique(imported_data()$Race)
                            ),
                            downloadButton(
                                'download_personalized',
                                'Download'
                            )
                        ),
                        mainPanel(dataTableOutput('personalized'))
                    )
        )
    })
    
    output$download_lims <- downloadHandler(
        filename = 'categorized_data.csv',
        content = function(file) {
            write_csv(lims_df(), file)
        }
    )
    
    output$download_personalized <- downloadHandler(
        filename = 'personalized_data.csv',
        content = function(file) {
            write_csv(personalized_df(), file)
        }
    )
    
    output$freezer <- renderText({
        imported_data() %>% 
            filter(Name == input$donor_freezer) %>% 
            pull(`Freezer Box Location(s)`)
        
    })
    
    output$assorted <- renderText({
        imported_data() %>% 
            filter(Name == input$donor_assorted) %>% 
            pull(!!as.name(input$column_assorted))
    })
})
