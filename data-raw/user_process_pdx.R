#` script to process portland data
library(tidyverse)
library(readxl)

#names from sheet 1
eva_vars <- read_xlsx("./data-raw/Portland CommunityMaster.xlsx",
                              sheet = 1) %>%
  rename(variable = Field,
         name = Name) %>%
  filter(!is.na(Order)) %>%
  mutate(interpret_high_value = case_when(Order == "Descending" ~ "high_opportunity",
                                          Order == "Ascending" ~ "low_opportunity")) %>%
  mutate(type = case_when(str_detect(variable, "cbiz") == "TRUE" ~ "business",
                          str_detect(variable, "cppl") == "TRUE" ~ "people",
                          str_detect(variable, "cplc") == "TRUE" ~ "place")) %>%
  select(variable, name, type, interpret_high_value)




#read in sheet 2, the raw data
eva_data_main <- read_xlsx("./data-raw/Portland CommunityMaster.xlsx", #place excel sheet inside the "data-raw" folder
                        sheet = 2, #if there are multiple sheets, read the sheet that contains raw values
                        skip = 5, #the dataset should start with column names. if there are extraneous rows, remove them here
                        na = c("NA") #if there are NAs in the dataset, tell R to read them as such
) %>%
select(-statename, -countyname, -tract) %>% #remove any extraneous columns
  gather("variable", "raw_value", -tract_string) %>%
  group_by(variable) %>%
  mutate(MEAN = mean(raw_value, na.rm = T),
         SD = sd(raw_value, na.rm = T),
         z_score = (raw_value - MEAN)/SD) %>%
  select(-MEAN, -SD) %>%
  right_join(eva_vars) %>%
  #we want high opportunity to be a high value, so this reorders those values if needed
  mutate(opportunity_zscore = if (interpret_high_value == "high_opportunity")
    (z_score)
    else if (interpret_high_value == "low_opportunity")
      (z_score * (-1))) 
