## code to prepare `census_tract` dataset goes here

date <- format(Sys.time(), "%Y%m%d")
# pkgload::load_all()

requireNamespace("readxl", quietly = TRUE)
requireNamespace("fs", quietly = TRUE)
requireNamespace("tigris", quietly = TRUE)
requireNamespace("janitor", quietly = TRUE)


## -------------------------------------------------

temp <- tempfile()
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_census_acs/xlsx_society_census_acs.zip",
  destfile = temp
)

ct <- readxl::read_xlsx(unzip(temp, "CensusACSTract.xlsx")) %>%
  janitor::clean_names() #%>%
  # filter(tcflag == 1)

fs::file_delete("CensusACSTract.xlsx")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
acs_equity <- ct %>%
  select(geoid, geoid2, 
         poptotal,
         avgcommute, 
         pov185rate,
         medianhhi, 
         whitenh,
         bachelors, 
         popover25,
         burdown,
         burdrent,
         burd_denom) %>%
  mutate(bachelor_per = bachelors / popover25,
         poc_per = 1 - (whitenh / poptotal),
         burhouse = (burdown + burdrent) / burd_denom) %>%
  select(-whitenh, 
         -popover25,
         -burdrent, 
         -burdown, 
         -burd_denom)

#should have older acs data so we can get change over time. if we're just using tract data, we might want to consider using the 1 year data, so the temporal piece is a bit more explicit. 

## ------------------------------------------------------------------------------------------------------------------------------------------------------


acs_merge <- (acs_equity) %>% #right_join()
  gather("var", "value", -geoid, -geoid2) 

  
