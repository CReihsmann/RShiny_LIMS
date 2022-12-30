#   ------------
#    DATATABLES
#   ------------

# generates data table for category tab in ui_tables.R
output$lims_table <-renderDataTable({
    
    select_cols <- colnames(lims_df())
    
    targets <- select_cols[select_cols %in% long_col_names]
    
    datatable(
        lims_df(),
        options = list(
            columnDefs = list(list(
                targets = targets,
                render = JS(
                    "function(data, type, row, meta) {",
                    "return type === 'display' && data.length > 10 ?",
                    "'<span title=\"' + data + '\">' + data.substr(0, 10) + '...</span>' : data;",
                    "}")
            )))
    )
    
})

# generates data table for personalized tab in ui_tables.R
output$personalized <-renderDataTable({
    
    all_cols <- all_cols()
    
    targets <- all_cols[all_cols %in% long_col_names]
    
    
    datatable(
        personalized_df(),
        options = list(
            columnDefs = list(list(
                targets = targets,
                render = JS(
                    "function(data, type, row, meta) {",
                    "return type === 'display' && data.length > 10 ?",
                    "'<span title=\"' + data + '\">' + data.substr(0, 10) + '...</span>' : data;",
                    "}")
            )))
        
    )
    
})

#   ------------------------
#    TIBBLES FOR DATA FRAMES
#   ------------------------

# generates filtered tibble for category table
# - passed to lims_table()
# - used for download in ui_tables.R
lims_df <- reactive({
    if (input$lims_div == 'Basic Info') {
        
        # lims_filt <- imported_data() %>% 
        #     select(contains(universal_cols))
        input_cols <- c()
        
    }
    
    else if(input$lims_div == 'All') {
        
        input_cols <- colnames(imported_data())
        
        input_cols <- input_cols[! input_cols %in% universal_cols]
    }
    
    else if (input$lims_div == 'Donor Info'){
        input_cols <- donor_info_cols
    }
    else if(input$lims_div == 'HLA'){
        input_cols <- hla_cols
    }
    else if(input$lims_div == 'Patient Info'){
        input_cols <- patient_cols
    }
    else if(input$lims_div == 'Sample Lots'){
        input_cols <- sample_lot_cols
    }
    else {
        input_cols <- stock_processed_cols
    }
    
    select_cols = c(universal_cols, input_cols)
    
    lims_filt <- imported_data() %>%
        select(contains(select_cols)) %>% 
        filter(Name %in% donors_lims(),
               `Age (years)` >= input$age_input_1_lims & `Age (years)` <= input$age_input_2_lims,
               Gender %in% input$gender_lims,
               Race %in% input$race_lims)
    
})

# generates filtered tibble for personalized table
# - passed to personalized()
# - used for download in ui_tables.R
personalized_df <- reactive({
    base_cols <- c('Name', 'Secondary ID/Reference', 'Barcode', 'Gender', 
                   'Race', 'Age (years)', 'Donor Disease')
    
    all_cols <- all_cols()
    
    filt_df <- imported_data() %>% 
        select(contains(all_cols)) %>% 
        filter(Name %in% donors_personalized(),
               `Age (years)` >= input$age_input_1_personalized & `Age (years)` <= input$age_input_2_personalized,
               Gender %in% input$gender_personalized,
               Race %in% input$race_personalized)
})

#   --------------------------------
#    FUNCTIONS FOR TIBBLE GENERATION
#   --------------------------------

df_cols <- reactive({
    base_cols <- c('Name', 'Secondary ID/Reference', 'Barcode', 'Gender', 
                   'Race', 'Age (years)', 'Donor Disease')
    imported_data() %>% 
        select(!contains(base_cols)) %>% 
        colnames()
})

selected_cols <- eventReactive(input$select_cols, {
    input$personalized
})

all_cols <- reactive({
    base_cols <- c('Name', 'Secondary ID/Reference', 'Barcode', 'Gender', 
                   'Race', 'Age (years)', 'Donor Disease')
    
    if(is.null(input$personalized)) {
        all_cols <- base_cols
    }
    else {
        all_cols <- c(base_cols, input$personalized)
    }
})

donors_lims <- reactive({
    if(is.null(input$donors_lims)) {
        unique(imported_data()$Name)
    }
    else {
        filtered <- imported_data() %>% 
            filter(Name %in% input$donors_lims)
        unique(filtered$Name)
    }
})

donors_personalized <- reactive({
    if(is.null(input$donors_personalized)) {
        unique(imported_data()$Name)
    }
    else {
        filtered <- imported_data() %>% 
            filter(Name %in% input$donors_personalized)
        unique(filtered$Name)
    }
})
