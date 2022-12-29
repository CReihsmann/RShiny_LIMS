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
