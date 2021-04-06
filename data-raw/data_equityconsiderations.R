## code to prepare `census_tract` dataset goes here

date <- format(Sys.time(), "%Y%m%d")
# pkgload::load_all()

requireNamespace("readxl", quietly = TRUE)
requireNamespace("fs", quietly = TRUE)
requireNamespace("tigris", quietly = TRUE)
requireNamespace("janitor", quietly = TRUE)


## -------------------------------------------------

temp <- tempfile()
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_equity_considerations/xlsx_society_equity_considerations.zip",
  destfile = temp
)

equity <- readxl::read_xlsx(unzip(temp, "EquityConsiderations_Full.xlsx")) %>%
  janitor::clean_names() 

fs::file_delete("EquityConsiderations_Full.xlsx")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
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
         luse_undev)

## ------------------------------------------------------------------------------------------------------------------------------------------------------


# #wide data
# eva_data_main <- eva_data_raw %>% 
#   transmute(tr10,
#             across(c(2:ncol(.)), 
#                    list(zscore = ~scale(.x, center = T, scale = T)),
#                    # list(mean = ~mean(.x, na.rm = T), sd = ~sd(.x, na.rm = T)),
#                    .names = "{.col}.{.fn}")) 

# #long data
eva_data_main <- eva_data_raw %>%
  gather("variable", "raw_value", -tr10) %>%
  group_by(variable) %>%
  mutate(MEAN = mean(raw_value, na.rm = T),
         SD = sd(raw_value, na.rm = T),
         z_score = (raw_value - MEAN)/SD) %>%
  select(-MEAN, -SD) 

usethis::use_data(eva_data_main, overwrite = TRUE)

