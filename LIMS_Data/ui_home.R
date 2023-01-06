#   ----------------------
#    HOME UI
#   ----------------------

# updates UI after password validation
output$display_app <- renderUI({
  req(validate_password_module())
  
  tabsetPanel(type = 'tabs',
              tabPanel(
                  'Data Search',
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
                          choices = str_sort(unique(imported_data()$Name)),
                          options = list(
                            placeholder = 'Please select an option below',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
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
                          choices = str_sort(unique(imported_data()$Name)),
                          options = list(
                            placeholder = 'Please select an option below',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
                        ),
                        selectizeInput(
                          'column_assorted',
                          'Column',
                          choices = imported_data() %>% 
                            select(!contains(comments),
                                   -`Freezer Box Location(s)`,
                                   -Name) %>% 
                            colnames(),
                          options = list(
                            placeholder = 'Please select an option below',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
                        ),
                        h5(strong('Selected Data')),
                        div(class = 'myclass',
                            verbatimTextOutput(
                              'assorted'))
                      )
                    )
                  ),
                  fluidRow(
                    column(
                      12,
                      align = 'center',
                      h4(strong('Notes')),
                      wellPanel(
                        selectizeInput(
                          'donor_notes',
                          'Donor Name',
                          choices = str_sort(unique(imported_data()$Name)),
                          options = list(
                            placeholder = 'Please select an option below',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
                        ),
                        selectizeInput(
                          'comments_notes',
                          'Choose Notes',
                          choices = comments,
                          options = list(
                            placeholder = 'Please select an option below',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
                        ),
                        h5(strong('Selected Notes')),
                        div(class = 'myclass',
                            verbatimTextOutput(
                              'comments'
                            ))
                      )
                    )
                  )
                ),
              tabPanel(
                'Donor Search',
                sidebarPanel(
                  selectizeInput(
                    'search_name',
                    'Full Name',
                    choices = unique(donor_search_table()$Name),
                    multiple = T
                  ),
                  selectizeInput(
                    'search_barcode',
                    'Donor ID',
                    choices = unique(donor_search_table()$Barcode),
                    multiple = T
                  ),
                  selectizeInput(
                    'search_age',
                    'Age',
                    choices = unique(donor_search_table()$Age),
                    multiple = T
                  ),
                  checkboxGroupInput(
                    'search_ageUnits',
                    'Age Unit',
                    choices = list('years',
                                   'months',
                                   'days'),
                    selected = list('years',
                                    'months',
                                    'days')
                  )
                ),
                mainPanel(dataTableOutput('donor_search'))
              ))
})

#   ----------------------
#    HOME Server
#   ----------------------

# renders freezer locations in response to query
output$freezer <- renderText({
  shiny::validate(
    need(input$donor_freezer != '', 'Please Choose Donor')
  )
  
  imported_data() %>% 
    filter(Name == input$donor_freezer) %>% 
    pull(`Freezer Box Location(s)`)
  
})

# renders assorted info locations in response to query
output$assorted <- renderText({
  shiny::validate(
    need(input$donor_assorted != '' & input$column_assorted != '',
         'Please Choose Donor and Non-empty Column field')
  )
  
  imported_data() %>% 
    filter(Name == input$donor_assorted) %>% 
    pull(!!as.name(input$column_assorted))
})

# renders comments in response to query
output$comments <- renderText({
  shiny::validate(
    need(input$donor_notes != '' & input$comments_notes != '',
         'Please Choose Donor and Non-empty Notes field')
  )
  
  imported_data() %>% 
    filter(Name == input$donor_notes) %>% 
    pull(!!as.name(input$comments_notes))
})