library(httr)
library(tidyverse)
library(jsonlite)
library(rvest)
library(lubridate)

url = 'https://na1.platformforscience.com/609546918/odata/DONOR'

username <- 'chunhua.dai@vanderbilt.edu'
password <- 'Core#2017'
response = GET(data_url,
               add_headers(.headers = headers),
               authenticate(user = username,
                            password = password,
                            type = 'basic'))
response$status_code

data <- content(response, as = 'text') %>% 
  fromJSON()

class(data[2])
class(data[[2]])
api_data <- as_tibble(data[[2]])

#------lims to api metadata conversion csv

col_conv <- read_csv('../data/20221206-col_conversions.csv')
w_api_cols <- col_conv$API_col
w_lims_cols <- col_conv$LIMS_col

#-----filtering down api_data

filt_cols <- api_data %>% 
  select(w_api_cols)

#-----made column for age in years & fixed discrepancies in isolation centers

select_data <- filt_cols %>% 
  mutate(AGE_IN_YEARS = round(if_else((CI_DONOR_AGE_UNITS == 'months'), (CI_DONOR_AGE/12), 
                       if_else((CI_DONOR_AGE_UNITS == 'days'), (CI_DONOR_AGE/365), CI_DONOR_AGE)), 4)) %>% 
  mutate(ISLETS_ISOLATION_CENTER = if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Pennsyl') == T, 'University of Pennsylvania',
                                    if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Louisville') == T, 'University of Louisville',
                                            if_else(str_detect(ISLETS_ISOLATION_CENTER, 'UCSF') == T, 'USCF',
                                                    if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Southern California') == T, 'Southern California',
                                                            if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Prodo') == T, 'Prodo',
                                                                    if_else(str_detect(ISLETS_ISOLATION_CENTER, 'The\\sScharp|(?<!\\s)Scharp') == T, 'Scharp-Lacy',
                                                                            if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Alberta') == T, 'University of Alberta',
                                                                                    if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Pittsburgh') == T, 'University of Pittsburgh',
                                                                                            if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Cincinnati') == T, "Cincinnati Children's",
                                                                                                    if_else(str_detect(ISLETS_ISOLATION_CENTER, 'Tennessee') == T, 'Tennessee Donor Services',ISLETS_ISOLATION_CENTER)))))))))))

#-----parsing out DONOR_PROCESSING_FROM_LOT      

lot_processing <- select_data$DONOR_PROCESSING_FROM_LOT
lot_processing <- lot_processing[!is.na(lot_processing)]
lot_processing_list <- str_c(lot_processing, collapse = '-')
lot_processing_list <- str_split(lot_processing_list, '-')
processing_unique <- sapply(lot_processing_list, unique)

remove <- c('PFA', 'fixed CMC', 'embedded', 'unknown', 'sequencing')
processing_unique <- append(processing_unique[! processing_unique %in% remove], c('PFA-fixed CMC-embedded', 'RNA-sequencing'))

for (i in processing_unique) {
  variable <- as.symbol(i)
  select_data <- select_data %>% 
    mutate(variable = str_count(DONOR_PROCESSING_FROM_LOT, i)) %>% 
    rename_with(~ gsub('variable', i, .x, fixed = T))
}
select_data <- select_data %>% 
  mutate(RNA = RNA - `RNA-sequencing`) %>% 
  select(-DONOR_PROCESSING_FROM_LOT)

date_cols = c('DATE_PANCREAS_ISLET_RECEIVED','CI_DATE_PANCREAS_PROCESSED')
date_time_cols = c('DATE___TIME_OF_DEATH', 'DATE___TIME_OF_CROSS_CLAMP')
date_time_cols_2 = c('TIME_PANCREAS_PROCUREMENT')
to_numeric = c('C_PEPTIDE_LEVELS', 'COLD_ISCHEIC_TIME')
# hla_chr_num_conv = c('DONOR_A1', 'DONOR_A2', 'DONOR_B1', 'DONOR_B2')


select_data <- select_data %>% 
  mutate_at(vars(contains(date_cols)), ymd) %>% 
  mutate_at(vars(contains(date_time_cols)), ymd_hms) %>% 
  mutate_at(vars(contains(date_time_cols_2)), mdy_hm) %>% 
  mutate(C_PEPTIDE_LEVEL = if_else(C_PEPTIDE_LEVEL == '<0.02', '0.01', C_PEPTIDE_LEVEL)) %>% 
  mutate_at(vars(contains(to_numeric)), as.numeric) 

write_csv(select_data, '../data/20221207-fixed_cols.csv')

