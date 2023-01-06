#   ----------------------
#    TABLES UI
#   ----------------------

# updates UI after password validation
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

#   ----------------------
#    TABLES SERVER
#   ----------------------

# instructs download of a csv for categorized datatable
output$download_lims <- downloadHandler(
    filename = 'categorized_data.csv',
    content = function(file) {
        write_csv(lims_df(), file)
    }
)

# instructs download of a csv for personalized datatable
output$download_personalized <- downloadHandler(
    filename = 'personalized_data.csv',
    content = function(file) {
        write_csv(personalized_df(), file)
    }
)