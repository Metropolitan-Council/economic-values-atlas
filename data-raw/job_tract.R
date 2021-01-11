## code to prepare `` dataset goes here

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
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_job_and_activity_centers/gpkg_society_job_and_activity_centers.zip",
  destfile = temp
)

jobs <- read_sf(unzip(temp, "society_job_and_activity_centers.gpkg")) %>% 
  janitor::clean_names()  #%>%
  # filter(tcflag == 1)

fs::file_delete("society_job_and_activity_centers.gpkg")


## ----------------------------------------------------------------------------------------------

temp <- tempfile()
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_job_density/gpkg_society_job_density.zip",
              destfile = temp
)

jobdens <- read_sf(unzip(temp, "society_job_density.gpkg")) %>% 
  janitor::clean_names() #%>%
# filter(tcflag == 1)

fs::file_delete("society_job_density.gpkg")

jobdens %>%
  ggplot() + 
  geom_sf(aes(fill = label))


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

tracts <- bind_rows(MNtract, WItract) %>% 
  st_transform(4326)

jobs2 <- jobs %>% 
  st_transform(4326)

job_tract_raw <- st_join(tracts, jobs2) %>% #tracts first since want all geoids in order to rescale
  # right_join(tracts) %>% #since want to get all geoids in order to rescale, should check to make sure that this is okay process
    mutate(jobs = replace_na(jobs, 0))

# job_tract_raw %>% 
#   ggplot()+
#   geom_sf(aes(fill = jobs)) #%>% 
#   st_transform(4326) # for leaflet
  
sum_job <-  job_tract_raw %>%
    st_drop_geometry() %>%
    summarise(MEAN = mean(jobs, na.rm = T), 
              SD = sd(jobs, na.rm = T)) 
job_MEAN <- sum_job[ ,1]
job_SD <- sum_job[ ,2]

job_tract <- job_tract_raw %>%
    mutate(zscore = (jobs - job_MEAN) / job_SD) %>%
    select(GEOID, zscore) %>% 
  rename(jobs = zscore) %>%
  st_transform(4326)

usethis::use_data(job_tract, overwrite = TRUE)
