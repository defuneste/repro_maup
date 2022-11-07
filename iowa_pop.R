# Date november 2022
# Author Olivier Leroy, branchtwigleaf.com
# Goal: clean a bit the pop 1970 Iowa from nhgis_ds95_1970

library(dplyr)
library(tidyr)

us_pop_raw <- read.csv("data/raw/nhgis0001_ds95_1970_county.csv", skip = 1)

iowa_pop_raw <- us_pop_raw[us_pop_raw$State.Name == "Iowa",]

iowa_pop <- tidyr::pivot_longer(iowa_pop_raw,
                    cols = names(iowa_pop_raw)[17:218],
                    names_to = "cat",
                    values_to = "count") |>
  dplyr::select("County.Name", "cat", "count")

## extract number for age, if more than one could be pb
extract_number <- function(x) {
regmatches(x, regexpr(pattern = "[[:digit:]]+",
     x)) |> as.numeric()}

iowa_pop$age <- sapply(iowa_pop$cat, extract_number)


iowa_old <- iowa_pop[iowa_pop$age >= 60,]

(iowa_old_county <- aggregate(iowa_old$count,
                      by =list(iowa_old$County.Name),
                      FUN = sum))

names(iowa_old_county) <- c("County", "pop_geq_60")

write.csv(iowa_old_county, "data/iowa_pop.county.csv")
saveRDS(iowa_old_county, "data/iowa_county_pop")
