#   -------
#    PLOTS
#   -------

# generates barchart
output$barChart <- renderPlot({
    
    primary = input$bar_primary
    secondary = input$bar_secondary
    
    if (secondary != '') {
        bargraph_df() %>% 
            ggplot(aes(x = fct_infreq(!!as.name(primary), ordered = F), fill = !!as.name(secondary))) +
            geom_bar()+
            coord_flip() +
            labs(x = primary)+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
            scale_fill_discrete(labels = function(x) str_wrap(x, width = 15)) +
            theme(legend.spacing.y = unit(0.15, 'cm')) +
            guides(fill = guide_legend(byrow = T))
    }
    else {
        bargraph_df() %>% 
            ggplot(aes(x = fct_infreq(!!as.name(primary), ordered = F))) +
            geom_bar()+
            coord_flip() +
            labs(x = primary)+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
            scale_fill_discrete(labels = function(x) str_wrap(x, width = 15)) +
            theme(legend.spacing.y = unit(0.15, 'cm')) +
            guides(fill = guide_legend(byrow = T))
    }
    
})

# generates histogram
output$histogram <- renderPlot({
    
    shiny::validate(
        need(input$numeric_choices != '', 'Choose Numeric Column')
    )
    
    if(is.null(input$histo_initial_filt_choices) & input$histo_group == '') {
        histo_df() %>% 
            ggplot(aes(x=!!as.name(input$numeric_choices))) + 
            geom_histogram(bins = input$bin_slider)+
            scale_color_viridis_d(option = 'magma') +
            scale_fill_viridis_d(option = 'magma')
    }
    else if(is.null(input$histo_initial_filt_choices) & input$histo_group != '') {
        histo_df() %>% 
            ggplot(aes(x=!!as.name(input$numeric_choices), fill = !!as.name(input$histo_group), color = !!as.name(input$histo_group))) + 
            geom_histogram(bins = input$bin_slider, position = input$histo_orientation, alpha = 0.5)+
            scale_color_viridis_d(option = 'magma',
                                  labels = function(x) str_wrap(x, width = 15)) +
            scale_fill_viridis_d(option = 'magma',
                                 labels = function(x) str_wrap(x, width = 15))
    }
    else if(!is.null(input$histo_initial_filt_choices) & input$histo_group == '') {
        histo_df() %>% 
            filter(!!as.name(input$histo_initial_filt) %in% input$histo_initial_filt_choices) %>%
            ggplot(aes(x=!!as.name(input$numeric_choices))) + 
            geom_histogram(bins = input$bin_slider, alpha = 0.5)+
            scale_color_viridis_d(option = 'magma') +
            scale_fill_viridis_d(option = 'magma')
    }
    else {
        histo_df() %>% 
            filter(!!as.name(input$histo_initial_filt) %in% input$histo_initial_filt_choices) %>% 
            ggplot(aes(x=!!as.name(input$numeric_choices), fill = !!as.name(input$histo_group), color = !!as.name(input$histo_group))) + 
            geom_histogram(bins = input$bin_slider, position = input$histo_orientation, alpha = 0.5)+
            scale_color_viridis_d(option = 'magma',
                                  labels = function(x) str_wrap(x, width = 15)) +
            scale_fill_viridis_d(option = 'magma',
                                 labels = function(x) str_wrap(x, width = 15)) 
    }
})

#   ------------------
#    TIBBLES FOR PLOTS
#   ------------------

# tibble for bargraphs
bargraph_df <- reactive({
    
    graph_data <- imported_data()%>%
        select(contains(graph_cols)) 
})

# tibble for histograms
histo_df <- reactive({
    
    graph_data <- imported_data() %>% 
        select(numeric_cols, graph_cols) %>% 
        select(!where(is.Date))
})

