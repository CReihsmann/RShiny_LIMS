#-----Packages
source('dependencies.R', local = T)

login_url = 'https://na1.platformforscience.com/609546918/odata/$metadata'

data_url = 'https://na1.platformforscience.com/609546918/odata/DONOR'

headers = c('Content-Type' = 'application/json;odata.metadata=minimal;charset=UTF-8',
            'Prefer'='odata.maxpagesize=1500')

col_conv <- read_csv('20221206-col_conversions.csv')

graph_cols <- c('Date Pancreas/Islets received', 'Isolation Center','Race',
                'Donor Disease','Gender','Age (years)', 'BMI', 'Age Groups', 'Year')

numeric_cols <- c('Disease Duration (yrs)','Age','Height (cm)','Weight (kg)','BMI','C-peptide Level (ng/mL)','Pancreas Weight (g)',
                  'Cold ischemic Time (hrs)','# Blood lots','# FACS lots','# Islet lots','# Islet Transplant Lots','flash frozen',
                  'paraffin embedding','serum','electron microscopy embedding','collagen I gel embedded islets','DNA',
                  'plasma','frozen unpurified','clarity','RNA','ATACseq','pseudoislets','cytospin','islet distribution','spleen distribution',
                  'lymph node distribution','matrix','single cell RNA','aDIST','Frozen Unpurified',
                  'flash frozen CMC','PFA-fixed CMC-embedded','RNA-sequencing')

histo_filt <- c('Isolation Center','Race','Donor Disease','Gender','Age Groups')