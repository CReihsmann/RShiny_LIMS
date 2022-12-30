#   ----------------------
#    HOME UI
#   ----------------------

# updates UI after password validation
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

#   ----------------------
#    HOME Server
#   ----------------------

# renders freezer locations in response to query
output$freezer <- renderText({
    imported_data() %>% 
        filter(Name == input$donor_freezer) %>% 
        pull(`Freezer Box Location(s)`)
    
})

# renders assorted info locations in response to query
output$assorted <- renderText({
    imported_data() %>% 
        filter(Name == input$donor_assorted) %>% 
        pull(!!as.name(input$column_assorted))
})
