# library(tidyverse)
# library(googlesheets4)
# library(googledrive)
# 
# output$test <- renderDataTable({
# # 
# options(gargle_oauth_cache = '.secrets',
#         gargle_oauth_email = 'alpowerslab@gmail.com')
# drive_auth()
# gs4_auth(token = drive_token())
# list.files('.secrets/')
# gs4_deauth()
# gs4_auth(cache = '.secrets/', email = 'alpowerslab@gmail.com')
# 
# file.remove(list.files('.secrets/', full.names = T))
# # gargle::gargle_oauth_cache()
# test_df <- read_sheet('https://docs.google.com/spreadsheets/d/10oHfplMnj5eRoQ5kqoXrBN_lbz7bVf_4yXL4kxVn2Ww/edit#gid=0')
# datatable(test_df)
# })