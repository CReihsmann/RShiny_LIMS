output$lims_table <-renderDataTable({
  
  
  if (input$lims_div == 'Basic Info') {
    
    lims_filt <- imported_data() %>% 
      select(contains(universal_cols))
    
    datatable(
      lims_filt,
      options = list(
        columnDefs = list(list(
          targets = 'Freezer Box Location(s)',
          render = JS(
            "function(data, type, row, meta) {",
            "return type === 'display' && data.length > 10 ?",
            "'<span title=\"' + data + '\">' + data.substr(0, 10) + '...</span>' : data;",
            "}")
        )))
    )
  }
  
  else if(input$lims_div == 'All') {
    
    datatable(
      imported_data(),
      options = list(
        columnDefs = list(list(
          targets = long_col_names,
          render = JS(
            "function(data, type, row, meta) {",
            "return type === 'display' && data.length > 10 ?",
            "'<span title=\"' + data + '\">' + data.substr(0, 10) + '...</span>' : data;",
            "}")
        )))
    )
  }
  
  else {
    
    if (input$lims_div == 'Donor Info'){
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
      select(contains(select_cols))

    targets <- select_cols[select_cols %in% long_col_names]

    datatable(
      lims_filt,
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
  }
  
})

output$personalized <-renderDataTable({
  
})