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

output$histogram <- renderPlot({
  
  histo_df() %>% 
    # filter(Gender != 'Unknown') %>% 
    ggplot(aes(x=!!as.name(input$numeric_choices))) + #, color = Gender)) +
    geom_histogram(bins = input$bin_slider, position = 'dodge', alpha = 0.5)+
    scale_color_viridis_d(option = 'magma') +
    scale_fill_viridis_d(option = 'magma')
  
})