library(tidyverse)
library(ggplot2)
library(plotly)

lims_data <- read_csv('../data/20221207-fixed_cols.csv')

lims_data <- lims_data %>% 
  mutate(AGE_GROUPS = if_else((AGE_IN_YEARS > 0&AGE_IN_YEARS <= 10), '1-10',
                              if_else((AGE_IN_YEARS > 10&AGE_IN_YEARS <= 20), '11-20',
                                      if_else((AGE_IN_YEARS > 20&AGE_IN_YEARS <= 30), '21-30',
                                              if_else((AGE_IN_YEARS > 30&AGE_IN_YEARS <= 40), '31-40',
                                                      if_else((AGE_IN_YEARS > 40&AGE_IN_YEARS <= 50), '41-50',
                                                              if_else((AGE_IN_YEARS > 50&AGE_IN_YEARS <= 60), '51-60',
                                                                      if_else((AGE_IN_YEARS > 60&AGE_IN_YEARS <= 70), '61-70',
                                                                              if_else((AGE_IN_YEARS > 70&AGE_IN_YEARS <= 80), '71-80',
                                                                                      if_else((AGE_IN_YEARS > 80&AGE_IN_YEARS <= 90), '81-90',
                                                                                              if_else((AGE_IN_YEARS > 90&AGE_IN_YEARS <= 100), '91-100', 'NA')))))))))))

lims_data %>% 
  ggplot(aes(x = fct_rev(fct_infreq(ISLETS_ISOLATION_CENTER, ordered = F)), fill = CI_DONOR_RACE)) +
  geom_bar()+
  coord_flip()

lims_data %>% 
  ggplot(aes(x = AGE_IN_YEARS)) + 
  geom_histogram()

ages <- lims_data %>% 
  select(AGE_IN_YEARS, AGE_GROUPS) %>% 
  filter(AGE_IN_YEARS < 10)
