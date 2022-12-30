imported_data <- reactive({
    response = GET(data_url,
                   add_headers(.headers = headers),
                   authenticate(user = username(),
                                password = password(),
                                type = 'basic'))
    data <- content(response, as = 'text') %>%
        fromJSON()
    
    api_data <- data[[2]]
    
    w_api_cols <- col_conv$API_col
    w_lims_cols <- col_conv$LIMS_col
    
    filt_cols <- api_data %>% 
        select(w_api_cols) 
    
    colnames(filt_cols) = w_lims_cols
    filt_cols
    
    
    #-----made column for age in years & fixed discrepencies in isolation centers
    
    select_data <- filt_cols %>% 
        mutate(`Age (years)` = round(if_else((`Age Units` == 'months'), (Age/12), 
                                             if_else((`Age Units` == 'days'), (Age/365), Age)), 4)) %>% 
        mutate(`Isolation Center` = if_else(str_detect(`Isolation Center`, 'Pennsyl') == T, 'University of Pennsylvania',
                                            if_else(str_detect(`Isolation Center`, 'Louisville') == T, 'University of Louisville',
                                                    if_else(str_detect(`Isolation Center`, 'UCSF') == T, 'USCF',
                                                            if_else(str_detect(`Isolation Center`, 'Southern California') == T, 'Southern California',
                                                                    if_else(str_detect(`Isolation Center`, 'Prodo') == T, 'Prodo',
                                                                            if_else(str_detect(`Isolation Center`, 'The\\sScharp|(?<!\\s)Scharp') == T, 'Scharp-Lacy',
                                                                                    if_else(str_detect(`Isolation Center`, 'Alberta') == T, 'University of Alberta',
                                                                                            if_else(str_detect(`Isolation Center`, 'Pittsburgh') == T, 'University of Pittsburgh',
                                                                                                    if_else(str_detect(`Isolation Center`, 'Cincinnati') == T, "Cincinnati Children's",
                                                                                                            if_else(str_detect(`Isolation Center`, 'Tennessee') == T, 'Tennessee Donor Services',`Isolation Center`)))))))))))%>%
        mutate(`Age Groups` = cut(`Age (years)`, 
                                  breaks = c(0,10,20,30,40,50,60,70,80,90,100),
                                  labels = c('0-10','11-20','21-30','31-40','41-50','51-60','61-70','71-80','81-90','90+')),
               Year = as.character(year(`Date Pancreas/Islets received`)),
               Race = na_if(Race, 'Unknown/Not Reported'))
    
    #-----parsing out Processing      
    
    lot_processing <- select_data$Processing
    lot_processing <- lot_processing[!is.na(lot_processing)]
    lot_processing_list <- str_c(lot_processing, collapse = '-')
    lot_processing_list <- str_split(lot_processing_list, '-')
    processing_unique <- sapply(lot_processing_list, unique)
    
    remove <- c('PFA', 'fixed CMC', 'embedded', 'unknown', 'sequencing', 'cells')
    processing_unique <- append(processing_unique[! processing_unique %in% remove], c('PFA-fixed CMC-embedded', 'RNA-sequencing'))
    
    for (i in processing_unique) {
        variable <- as.symbol(i)
        select_data <- select_data %>% 
            mutate(variable = str_count(Processing, i)) %>% 
            rename_with(~ gsub('variable', i, .x, fixed = T))
    }
    select_data <- select_data %>% 
        mutate(RNA = RNA - `RNA-sequencing`) %>% 
        select(-Processing) %>% 
        rename(`isolated T-cells` = `isolated T`)
    
    date_cols = c('Date Pancreas/Islets received','Date Pancreas Processed')
    date_time_cols = c('Date/Time of Cross-Clamp', 'Date/Time of Cross-Clamp')
    date_time_cols_2 = c('Time of Pancreas Procurement')
    to_numeric = c('C-peptide Level (ng/mL)', 'Cold ischemic Time (hrs)')
    
    
    select_data <- select_data %>% 
        mutate_at(vars(contains(date_cols)), ymd) %>% 
        mutate_at(vars(contains(date_time_cols)), ymd_hms) %>% 
        mutate_at(vars(contains(date_time_cols_2)), mdy_hm) %>% 
        mutate(`C-peptide Level (ng/mL)` = if_else(`C-peptide Level (ng/mL)` == '<0.02', '0.01', `C-peptide Level (ng/mL)`)) %>% 
        mutate_at(vars(contains(to_numeric)), as.numeric) 
})

bargraph_df <- reactive({
    
    
    graph_data <- imported_data()%>%
        select(contains(graph_cols)) 
})

histo_df <- reactive({
    
    graph_data <- imported_data() %>% 
        select(numeric_cols, graph_cols) %>% 
        select(!where(is.Date))
    
})

# histo_filters <- observeEvent(req(input$histo_initial_filt!=""), {
#     updateSelectizeInput(
#         inputId = 'histo_initial_filt_choices',
#         choices = histo_df() %>% select(input$histo_initial_filt) %>% unique() %>% as.list(),
#         options = list(
#             placeholder = 'Please Select Group Above',
#             onInitialize = I('function() { this.setValue (""); }')
#         )
#     )
# })
df_cols <- reactive({
    # colnames(imported_data())
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
