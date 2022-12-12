library(shiny)
library(shinyjs)
library(shinythemes)
library(tidyverse)
library(shinyauthr)
library(sodium)
library(httr)
library(tidyverse)
library(jsonlite)
library(rvest)
library(plotly)

login_url = 'https://na1.platformforscience.com/609546918/odata/$metadata'

data_url = 'https://na1.platformforscience.com/609546918/odata/DONOR'

headers = c('Content-Type' = 'application/json;odata.metadata=minimal;charset=UTF-8',
            'Prefer'='odata.maxpagesize=1500')

col_conv <- read_csv('20221206-col_conversions.csv')