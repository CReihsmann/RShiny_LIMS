output$barChart <- renderPlotly({
  
  primary = input$bar_primary
  secondary = input$bar_secondary
  
  
  if (secondary != '') {
    filt_1 <- plot_df() %>% 
      filter(!is.na(!!as.name(primary))) %>% 
      mutate(primary_var = !!as.name(primary),
             stack_var = !!as.name(secondary)) %>% 
      group_by(primary_var, stack_var) %>% 
      summarise(secondary_numb = n()) 
    
    filt_2 <- plot_df() %>% 
      filter(is.na(!!as.name(secondary))) %>% 
      mutate(primary_var = !!as.name(primary),
             stack_var = !!as.name(secondary)) %>% 
      mutate(stack_var = replace_na(stack_var, 'NA')) %>% 
      group_by(primary_var, stack_var) %>% 
      summarise(secondary_numb = n()) 
    
    
    
    
    fig <- plot_ly() %>% 
      add_trace(y = ~filt_1$primary_var, x = ~filt_1$secondary_numb, type = 'bar', color = ~filt_1$stack_var,
                hovertemplate = paste(
                  '<b><i>Count</i>: %{x}'
                ), 
                colors = 'Set1') %>% 
      add_trace(y = ~filt_2$primary_var, x = ~filt_2$secondary_numb, type = 'bar', color = ~filt_2$stack_var,
                hovertemplate = paste(
                  '<b><i>Count</i>: %{x}'
                ),
                marker = list(color = '#79cdcd'))%>% 
      layout(barmode = ('stack'),
             plot_bgcolor = '#F5F5F5',
             legend = list(font = list(size = 10)))
    
    fig
  }
  else{
    filt_1 <- plot_df() %>% 
      filter(!is.na(!!as.name(primary))) %>%
      mutate(primary_var = !!as.name(primary)) %>% 
      group_by(primary_var) %>% 
      summarise(secondary_numb = n()) 
    
    filt_2 <- plot_df() %>% 
      filter(is.na(!!as.name(primary))) %>% 
      mutate(primary_var = !!as.name(primary)) %>% 
      mutate(primary_var = replace_na(primary_var, 'NA')) %>% 
      group_by(primary_var) %>% 
      summarise(secondary_numb = n()) 
    
    
    
    
    fig <- plot_ly() %>% 
      add_trace(y = ~filt_1$primary_var, x = ~filt_1$secondary_numb, type = 'bar',
                hovertemplate = paste(
                  '<b><i>Count</i>: %{x}'
                ), 
                colors = 'Set1',
                name = primary) %>% 
      add_trace(y = ~filt_2$primary_var, x = ~filt_2$secondary_numb, type = 'bar',
                hovertemplate = paste(
                  '<b><i>Count</i>: %{x}'
                ),
                marker = list(color = '#79cdcd'),
                name = 'NAs')%>% 
      layout(barmode = ('stack'),
             plot_bgcolor = '#F5F5F5',
             legend = list(font = list(size = 10)))
    
    fig
  }
  
})