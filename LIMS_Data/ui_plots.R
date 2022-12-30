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

#   ----------------------
#    PLOTS SERVER
#   ----------------------

# updates choices to filter by options in histogram UI
histo_filters <- observeEvent(req(input$histo_initial_filt!=""), {
    updateSelectizeInput(
        inputId = 'histo_initial_filt_choices',
        choices = histo_df() %>% select(input$histo_initial_filt) %>% unique() %>% as.list(),
        options = list(
            placeholder = 'Please Select Group Above',
            onInitialize = I('function() { this.setValue (""); }')
        )
    )
})