output$barChart <- renderPlotly({
  
  test <- graph_data %>% 
    filter(!is.na(ISLETS_ISOLATION_CENTER)) %>% 
    group_by(YEAR, ISLETS_ISOLATION_CENTER) %>% 
    summarise(centers = n()) 
  test_2 <- graph_data %>% 
    filter(is.na(ISLETS_ISOLATION_CENTER)) %>% 
    mutate(ISLETS_ISOLATION_CENTER = replace_na(ISLETS_ISOLATION_CENTER, 'NA')) %>% 
    group_by(YEAR, ISLETS_ISOLATION_CENTER) %>% 
    summarise(centers = n()) 
  
  plot_ly() %>% 
    add_trace(y = ~test$YEAR, x = ~test$centers, type = 'bar', color = ~test$ISLETS_ISOLATION_CENTER,
              hovertemplate = paste(
                '<b><i>Count</i>: %{x}'
              ), 
              colors = 'Set1') %>% 
    add_trace(y = ~test_2$YEAR, x = ~test_2$centers, type = 'bar', color = ~test_2$ISLETS_ISOLATION_CENTER,
              hovertemplate = paste(
                '<b><i>Count</i>: %{x}'
              ),
              marker = list(color = '#79cdcd')) %>% 
    layout(barmode = ('stack'),
           plot_bgcolor = '#F5F5F5')
  
})