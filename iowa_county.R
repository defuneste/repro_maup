# Date november 2022
# Author Olivier Leroy, branchtwigleaf.com
# Goal: clean a bit the exported Iowa from query-raw_iowa.txt
#

iowa <- sf::st_read("data/raw/iowa_osm.geojson")

iowav2 <- iowa[!is.na(iowa$name),]
iowa_clea <- iowav2[c("alt_name", "name")]

sf::st_write(iowa_clea, "data/iowa_county.gpkg")
saveRDS(iowa_clea, "data/iowa_county"):w
