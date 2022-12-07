library(tidyverse)
library(ggplot2)
library(plotly)

lims_data <- read_csv('../data/20221207-fixed_cols.csv')

graph_cols <- c('DATE_PANCREAS_ISLET_RECEIVED','ISLETS_ISOLATION_CENTER','CI_DONOR_RACE',
                'CI_DONOR_DISEASE','CI_DONOR_GENDER','AGE_IN_YEARS', 'CI_DONOR_BMI_MANUAL')

graph_data <- lims_data %>% 
  select(contains(graph_cols)) %>% 
  mutate(AGE_GROUPS = if_else((AGE_IN_YEARS > 0&AGE_IN_YEARS <= 10), '1-10',
                              if_else((AGE_IN_YEARS > 10&AGE_IN_YEARS <= 20), '11-20',
                                      if_else((AGE_IN_YEARS > 20&AGE_IN_YEARS <= 30), '21-30',
                                              if_else((AGE_IN_YEARS > 30&AGE_IN_YEARS <= 40), '31-40',
                                                      if_else((AGE_IN_YEARS > 40&AGE_IN_YEARS <= 50), '41-50',
                                                              if_else((AGE_IN_YEARS > 50&AGE_IN_YEARS <= 60), '51-60',
                                                                      if_else((AGE_IN_YEARS > 60&AGE_IN_YEARS <= 70), '61-70',
                                                                              if_else((AGE_IN_YEARS > 70&AGE_IN_YEARS <= 80), '71-80',
                                                                                      if_else((AGE_IN_YEARS > 80&AGE_IN_YEARS <= 90), '81-90',
                                                                                              if_else((AGE_IN_YEARS > 90&AGE_IN_YEARS <= 100), '91-100', 'NA'))))))))))) %>% 
  mutate(YEAR = as.character(year(DATE_PANCREAS_ISLET_RECEIVED)))
#-----Isolation Center bar
graph_data %>% 
  ggplot(aes(x = fct_infreq(ISLETS_ISOLATION_CENTER, ordered = F), fill = CI_DONOR_RACE)) +
  geom_bar()+
  coord_flip() +
  labs(x = "Isolation Center")+
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_fill_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme(legend.spacing.y = unit(0.15, 'cm')) +
  guides(fill = guide_legend(byrow = T))

#-----Disease State bar
lims_data %>% 
  ggplot(aes(x = fct_infreq(CI_DONOR_DISEASE), fill = CI_DONOR_GENDER)) +
  geom_bar()+
  coord_flip() +
  labs(x = "Isolation Center") +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_fill_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme(legend.spacing.y = unit(0.15, 'cm')) +
  guides(fill = guide_legend(byrow = T))

#-----Age Groups
lims_data %>% 
  ggplot(aes(x = fct_infreq(AGE_GROUPS, ordered = F), fill = ISLETS_ISOLATION_CENTER)) +
  geom_bar()+
  coord_flip() +
  labs(x = "Age Groups")+
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_fill_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme(legend.spacing.y = unit(0.15, 'cm')) +
  guides(fill = guide_legend(byrow = T))

#-----Years
ggplotly(graph_data %>% 
  ggplot(aes(x = YEAR, fill = ISLETS_ISOLATION_CENTER)) +
  geom_bar()+
  coord_flip() +
  labs(x = "Year")+
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  scale_fill_discrete(labels = function(x) str_wrap(x, width = 20)))


test <- lims_data %>% 
  select()
  group_by(YEAR) %>% 
  summarise()
  
  
  plot_ly(x = ~fct_infreq(ISLETS_ISOLATION_CENTER), y = ~ISLETS_ISOLATION_CENTER, type = 'bar', color = ~CI_DONOR_RACE) %>% 
  layout(barmode = 'stack')

lims_data %>% 
  ggplot(aes(x = AGE_IN_YEARS)) + 
  geom_histogram()

ages <- lims_data %>% 
  select(AGE_IN_YEARS, AGE_GROUPS) %>% 
  filter(AGE_IN_YEARS < 10)
