#-----Packages
source('dependencies.R', local = T)

#   -------------------------------------------------------------------
#    API CALL DEFINITIONS/INFO - FOUND IN MODULE_LOGIN.R & API_FILTER.R
#   -------------------------------------------------------------------
#
# url for log in (module_login.R)
# - called in validate_credentials()
# -- use metadata api call as reacts much faster
login_url = 'https://na1.platformforscience.com/609546918/odata/$metadata'

# url for whole database api call (api_filter.R)
# - called in imported_data()
data_url = 'https://na1.platformforscience.com/609546918/odata/DONOR'

# headers used in GET() call (api_filter.R)
# - called in imported_data()
headers = c('Content-Type' = 'application/json;odata.metadata=minimal;charset=UTF-8',
            'Prefer'='odata.maxpagesize=1500')

#   -----------------------------------------------
#    API DATAFRAME FILTERS - FOUND IN API_FILTER.R
#   -----------------------------------------------

# csv with original column name conversions to new column names
# - called in imported_data()
col_conv <- read_csv('20221206-col_conversions.csv')

# base columns used for plot generation
# - called in bargraph_df() & histo_df()
graph_cols <- c('Date Pancreas/Islets received', 'Isolation Center','Race',
                'Donor Disease','Gender','Age (years)', 'BMI', 'Age Groups', 'Year')

# all numeric columns for histogram
# - called in histo_df()
numeric_cols <- c('Disease Duration (yrs)','Age','Height (cm)','Weight (kg)','BMI',
                  'C-peptide Level (ng/mL)','Pancreas Weight (g)','Cold ischemic Time (hrs)',
                  '# Blood lots','# FACS lots','# Islet lots','# Islet Transplant Lots',
                  'flash frozen','paraffin embedding','serum','electron microscopy embedding',
                  'collagen I gel embedded islets','DNA','plasma','frozen unpurified',
                  'clarity','RNA','ATACseq','pseudoislets','cytospin','islet distribution',
                  'spleen distribution','lymph node distribution','matrix','single cell RNA',
                  'aDIST','Frozen Unpurified','flash frozen CMC','PFA-fixed CMC-embedded',
                  'RNA-sequencing')

#   ---------------
#    WIDGET CHOICES
#   ---------------

# choices for initial histogram filter which will be used to update choices
histo_filt <- c('Isolation Center','Race','Donor Disease','Gender','Age Groups')

#   --------------
#    COLUMN LISTS
#   --------------

# for category table
universal_cols <- c('Name','Barcode','Donor UNOS ID','Secondary ID/Reference','Age (years)',
                    'Gender', 'Race','Freezer Box Location(s)')
donor_info_cols <- c('Donor Disease','Disease Duration (yrs)','Date Pancreas/Islets received',
                     'Date Pancreas Processed','Age','Age Units','Height (cm)',
                     'Weight (kg)','BMI','Cause of Death','Time on Ventilator (days)',
                     'Pancreatic Tissue','Islets_bool','Perifused_bool','Isolation Center',
                     'Plasma_bool','Serum_bool','Blood Group','Blood Group Subtypes','HbA1c',
                     'C-peptide Level (ng/mL)','Autoantibody IAA','Autoantibody GAD65',
                     'Autoantibody IA-2','Autoantibody ZnT8','Comments_Donor Info',
                     'GEO Accession Number')
hla_cols <- c('A1','A2','B1','B2','BW4','BW6','CW1','CW2','DR1','DR2','DR51','DR52','DR53',
              'DPA1-1','DPA1-2','DPB1-1','DPB1-2','DQA1-1','DQA1-2','DQ1 (DQB1)','DQ2 (DQB1)')
organ_cols <- c('Date/Time of Death','Date/Time of Cross-Clamp','Time of Pancreas Procurement',
                'Pancreas Weight (g)','Cold ischemic Time (hrs)','Warm ischemic Time (hrs)',
                'Islet Culture Time (hrs)')
patient_cols <- c('Hospital Medications','Home Medications','Taking Insulin_bool',
                  'Past Medical History','Cigarette Use (>20 pack years)','Social Drug Use',
                  'Heavy Alcohol (2+ drinks/daily)','Serology - HIV 1/2','Serology - HBsAg',
                  'Serology - HBsAb','Serology HBcAb Total','Serology - HBcAb IgG',
                  'Serology - HBcAb IgM','Serology - HCV','Serology - RPR/STS','Serology - CMV',
                  'Serology - HTLV1/2','Serology - EBV IgG','Serology - EBV IgM',
                  'Comments_Patient chart')
sample_lot_cols <- c('# Blood lots','# FACS lots','# Islet lots','# Islet Transplant Lots',
                     '# Lymph Node Lots','# Pancreas Lots','# Spleen Lots')
stock_processed_cols <- c('frozen fixed','flash frozen','paraffin embedding','serum',
                          'electron microscopy embedding','collagen I gel embedded islets',
                          'DNA','plasma','frozen unpurified','clarity','RNA','ATACseq',
                          'pseudoislets','cytospin','islet distribution','spleen distribution'
                          ,'lymph node distribution','isolated T-cells','matrix',
                          'single cell RNA','aDIST','Frozen Unpurified','flash frozen CMC',
                          'PFA-fixed CMC-embedded','RNA-sequencing')
# tells which columns to target for shortening in table output
# - used in both lims_table() and personalized() outputs
long_col_names <- c('Freezer Box Location(s)', 'Cause of Death', 'Hospital Medications', 
                    'Home Medications', 'Past Medical History', 'Comments_Donor Info')
# columns to use in ui_home.R to look up individual patient info
comments <- c('Past Medical History', 'Comments_Donor Info', 'Comments_Patient Chart')
