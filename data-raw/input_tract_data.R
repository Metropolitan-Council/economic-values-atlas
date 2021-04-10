#` this is a description
#`
## code to prepare `census_tract` dataset goes here

date <- format(Sys.time(), "%Y%m%d")
# pkgload::load_all()

requireNamespace("readxl", quietly = TRUE)
requireNamespace("fs", quietly = TRUE)
requireNamespace("tigris", quietly = TRUE)
requireNamespace("janitor", quietly = TRUE)

###################
# download data sources of interest and select relevant variables
###################

## ----------- equity considerations data

temp <- tempfile()
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_equity_considerations/xlsx_society_equity_considerations.zip",
  destfile = temp
)

equity <- readxl::read_xlsx(unzip(temp, "EquityConsiderations_Full.xlsx")) %>%
  janitor::clean_names() 

fs::file_delete("EquityConsiderations_Full.xlsx")


## --------------variables of interest from equity considerations
eva_data_raw <- equity %>%
  select(tr10, 
         p_englimit,
         pwhitenh,
         ppov185,
         work_denom,
         pwk_nowork,
         mdern_ftyr,
         phftransit,
         job_total,
         pjob_le15k,
         mdlandv20,
         luse_comm,
         luse_indus,
         luse_undev) %>%
  rowwise() %>%
  mutate(luse_commind = sum(luse_comm, luse_indus, na.rm=T),
         pnonwhite = 1 - pwhitenh) %>%
  select(-luse_comm, -luse_indus,
         -pwhitenh) %>%
  rename(tract_string = tr10)

###################
# add some human-readable metadata
###################

## -------------------------------describe data
eva_data_codes <- tribble(~variable, ~name, ~type, ~interpret_high_value,
                          "p_englimit", "Share of population with limited English proficiency", "people", "high_opportunity",
                          "pnonwhite", "Share of population that is BIPOC", "people", "high_opportunity",
                          "ppov185", "Share of population below 185% of poverty line", "people",  "high_opportunity",
                          "work_denom", "Working age population (total persons age 16-64)", "people", "high_opportunity",
                          "pwk_nowork", "Share of unemployed working age population", "people", "high_opportunity",
                          "mdern_ftyr", "Median annual earnings for full-time workers (in 2019 dollars)", "people", "low_opportunity",
                          "phftransit", "Proportion of residents nearby (<0.5 mile) high frequency transit", "place", "high_opportunity",
                          "job_total", "Total jobs", "business", "low_opportunity",
                          "pjob_le15k", "Proportion of jobs that are low income (<15,000 / year)", "business", "high_opportunity",
                          "mdlandv20", "Median land value per acre (in 2020)", "place", "low_opportunity",
                          "luse_commind", "Proportion of acres used for commercial or industrial uses", "place", "high_opportunity",
                          "luse_undev", "Proportion of acres that are undeveloped", "place", "high_opportunity")


# ###################
# # gather spatial elements
# ###################
# ## ---------------get tracts via tigris
# MNtract <- tigris::tracts(
#   state = "MN",
#   county = c(
#     "Anoka", "Carver", "Dakota", "Hennepin", "Ramsey", "Scott", "Washington"#,
#     # "Sherburne", "Isanti", "Chisago", "Goodhue", "Rice", "Le Sueur", "Sibley", "McLeod", "Wright" #if want to add collar counties
#   ),
#   class = "sf"
# ) %>%
#   select(GEOID)
# 
# eva_tract_geometry <- MNtract %>% 
#   st_transform(4326)
# 
# usethis::use_data(eva_tract_geometry, overwrite = TRUE)

###################
# create final dataset - no spatial data
#note spatial data should be joined after any summarizing is done to save some computation time
###################

# #long data
eva_data_main <- eva_data_raw %>%
  gather("variable", "raw_value", -tract_string) %>%
  group_by(variable) %>%
  mutate(MEAN = mean(raw_value, na.rm = T),
         SD = sd(raw_value, na.rm = T),
         z_score = (raw_value - MEAN)/SD) %>%
  select(-MEAN, -SD) %>%
  left_join(eva_data_codes) %>%
  #we want high opportunity to be a high value, so this reorders those values if needed
  mutate(opportunity_zscore = if (interpret_high_value == "high_opportunity")
    (z_score)
    else if (interpret_high_value == "low_opportunity")
      (z_score * (-1))) 

usethis::use_data(eva_data_main, overwrite = TRUE)

