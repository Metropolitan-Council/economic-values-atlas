## code to prepare `census_tract` dataset goes here

date <- format(Sys.time(), "%Y%m%d")
# pkgload::load_all()

requireNamespace("readxl", quietly = TRUE)
requireNamespace("fs", quietly = TRUE)
requireNamespace("tigris", quietly = TRUE)
requireNamespace("janitor", quietly = TRUE)

library(dplyr)
library(fs)
library(sf)
library(tigris)
library(janitor)

temp <- tempfile()
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_census_acs/xlsx_society_census_acs.zip",
  destfile = temp
)

ct <- readxl::read_xlsx(unzip(temp, "CensusACSTract.xlsx")) %>%
  janitor::clean_names() #%>%
  # filter(tcflag == 1)

fs::file_delete("CensusACSTract.xlsx")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
ct_equity <- ct %>%
  select(geoid, geoid2, 
         avgcommute, 
         pov185rate) 

## ------------------------------------------------------------------------------------------------------------------------------------------------------
ct_merge <- (ct_equity) %>% #right_join()
  gather("var", "value", -geoid, -geoid2) 

  
ct_summary <- ct_merge %>%
  group_by(var) %>%
  summarise(MEAN = mean(value, na.rm = T), 
            SD = sd(value, na.rm = T)) %>%
  full_join(ct_merge) %>%
  mutate(zscore = (value - MEAN) / SD) %>%
  select(geoid2, var, zscore) %>%
  pivot_wider(names_from = "var", values_from = "zscore")


## ----------------------------------------------------------------------------------------------------------------------------------------------------
MNtract <- tigris::tracts(
  state = "MN",
  county = c(
    "Anoka", "Carver", "Dakota", "Hennepin", "Ramsey", "Scott", "Washington",
    "Sherburne", "Isanti", "Chisago", "Goodhue", "Rice", "Le Sueur", "Sibley", "McLeod", "Wright"
  ),
  class = "sf"
) %>%
  select(GEOID)

WItract <- tigris::tracts(
  state = "WI",
  county = c("St. Croix", "Polk", "Pierce"),
  class = "sf"
) %>%
  select(GEOID) 

acs_tract <- bind_rows(MNtract, WItract) %>%
  left_join((ct_summary), 
            by = c("GEOID" = "geoid2")) %>% 
  st_transform(4326) # for leaflet

usethis::use_data(acs_tract, overwrite = TRUE)

#--------
#need to get just tract outlines too
tractoutline <- acs_tract %>% select(GEOID) %>% 
  st_transform(4326)
usethis::use_data(tractoutline, overwrite = TRUE)
