# M Schrandt
# Mapping for Robinson Preserve Acoustics Proposal

library(tidyverse)
library(sf)
library(mapview)
library(ggpubr)
library(png)

#### Prep spatial data layers ####

# read in Tampa Bay Shoreline shapefile
TBshore <- st_read('shapefiles/Tampa_Bay_Shoreline.shp', quiet = T) %>%
  st_transform(4326)

# read in Robinson Preserve outline polygon from Manatee County
preservedat <- st_read('shapefiles/Parks_and_Preserves.shp', quiet = T) %>%
  filter(NAME == 'Robinson Preserve') %>%
  select(NAME, TOTADDRESS, ZIPCODE, PARK_TYPE, ACREAGE, MANAGEMENT, OWNER_NAME, geometry)
preservedat.shp <- preservedat %>%
  st_transform(4326)
  
# the county shapefile is in WGS 84 and is a multipolygon

# read in Robinson Preserve expansion project outline polygon
expansiondat <- st_read('shapefiles/RobPres_Expansion_Poly.shp', quiet = T) %>%
  select(Entity, Layer, DocName, DocType, geometry) %>%
  #need to transform from NAD83 to WGS 84
  st_transform(4326)

#read in FIM pond outlines
ponddat <- st_read('shapefiles/Robinson_Preserve.shp', quiet = T) %>%
  mutate(Pond = str_sub(FolderPath, 24, 29)) %>%
  mutate(Type = case_when(Pond %in% c("Pond_6", "Pond_7") ~ "Natural",
                          TRUE ~ "Restored")) %>%
  #group by ponds and make them into polygon outlines
  group_by(Pond, Type) %>%
  summarise() %>%
  st_cast("POLYGON") %>%
  #for the outer polygon
  st_convex_hull()
ponddat
# the FIM pond outlines are WGS 84 and are points

#pond outlines, as points, are also readable as individual layers from
#test <- st_read("Robinson_Preserve_2019.final.kml")

#locations of water loggers installed during restoration monitoring (different grant than acoustics)
loggerdat <- read.csv("shapefiles/RobPres_WaterLogger_loc.csv", header = T, stringsAsFactors = F)
logger.shp <- loggerdat %>%
  filter(Logger.. != 31) %>%
  select(Logger.Type, Pond = Location, Notes, LAT_DD, LONG_DD) %>%
  #specify lat/long and the WGS coord system as 4326
  st_as_sf(coords = c('LONG_DD', 'LAT_DD'), crs = 4326)
logger.shp

#POTENTIAL locations of acoustic receivers
receiverdat <- read.csv("shapefiles/RobPres_PotAcousticReceiver_loc.csv", header = T, stringsAsFactors = F)
receiver.shp <- receiverdat %>%
  #specify lat/long and the WGS coord system as 4326
  st_as_sf(coords = c('LONG_DD', 'LAT_DD'), crs = 4326)
receiver.shp

#appprocimate location of Rob Preserve entry/exit points
openingdat <- read.csv("shapefiles/RobPres_IngressEgress_loc.csv", header = T, stringsAsFactors = F)
opening.shp <- openingdat %>%
  #specify lat/long and the WGS coord system as 4326
  st_as_sf(coords = c('LONG_DD', 'LAT_DD'), crs = 4326)
opening.shp

#### Interactive Mapview Map ####
mapviewOptions(basemaps = c("Esri.WorldImagery", "OpenStreetMap"),
               legend.pos = "topright")
mapview(preservedat, col.regions = "lightgreen", alpha.regions = 0.2, layer.name = "Robinson Preserve") +
  mapview(ponddat, col.regions = "lightblue", layer.name = "Ponds") +
  mapview(opening.shp, zcol = "Type", col.regions = c("Red", "Black"), 
          alpha.regions = 10, cex = 5, layer.name = "Exit/Entry Points") +
  mapview(logger.shp, col.regions = "blue", cex = 4.5, layer.name = "Water_Air Loggers") +
  mapview(receiver.shp, col.regions = "yellow", cex = 8, alpha.regions = 10, layer.name = "Possible Receiver Locations")


#### Static Map ####
## NEED TO WORK ON THIS ##
#set fill colors in order used

#let's combine all point data to make a simple legend
pointdat <- read.csv("shapefiles/RobPres_pointstructures.csv", header = T, stringsAsFactors = F)
pointdat$Structure_Type <- factor(pointdat$Structure_Type, levels = c("Main ingress/egress",
                                                                      "Mosquito ditching",
                                                                      "Water logger",
                                                                      "Air logger",
                                                                      "Acoustic receiver"),
                                  labels = c("Main ingress/egress",
                                             "Mosquito ditch ingress/egress",
                                             "Water logger",
                                             "Air logger",
                                             "Acoustic receiver"))
pointdat.shp <- pointdat %>%
  #specify lat/long and the WGS coord system as 4326
  st_as_sf(coords = c('LONG_DD', 'LAT_DD'), crs = 4326)

# pallette <- c("red", "black", "blue", "pink", "yellow")
# shapes <- c(17, 17, 19, 13, 7)
# 
# p <- ggplot(data = TBshore) +
#   geom_sf(data = subset(TBshore, ATTRIBUTE == "LAND", select = c("OBJECTID", "ATTRIBUTE", "geometry")), fill = "light gray") +
#   geom_sf(data = subset(TBshore, ATTRIBUTE == "WATER", select = c("OBJECTID", "ATTRIBUTE", "geometry")), fill = "light blue") +
#   geom_sf(data = preservedat, fill = "light green", color = "dark green", alpha = 0.5) +
#   geom_sf(data = ponddat, fill = "light blue") +
#   geom_sf(data = pointdat.shp, aes(col = Structure_Type, shape = Structure_Type), size = 3.5) +
#   scale_color_manual(values = pallette) +
#   scale_shape_manual(values = shapes) +
#   coord_sf(xlim = c(-82.692, -82.65), ylim = c(27.49, 27.53), expand = FALSE) +
#   theme(
#     panel.background = element_rect(fill = "transparent"), # bg of the panel
#     plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
#     panel.grid.major = element_blank(), # get rid of major grid
#     panel.grid.minor = element_blank(), # get rid of minor grid
#     legend.background = element_rect(fill = "transparent"), # get rid of legend bg
#     legend.box.background = element_rect(fill = "transparent") # get rid of legend panel bg
#   )
# 
# p
# 
# 
# ggsave(p, filename = "test1.png",  bg = "transparent")

#### A better option for printing/saving to a static map ####
mapviewOptions(basemaps = c("Esri.WorldImagery"),
               legend.pos = "topright")
mapview(preservedat, color = "lightgreen", lwd = 3, col.regions = "lightgreen", alpha.regions = 0.02,
        layer.name = "Robinson Preserve", legend.opacity = 1) +
  mapview(expansiondat, color = "lightcyan3", lwd = 3, col.regions = "lightcyan3", alpha.regions = 0.05,
          layer.name = "Restoration Phase IIB", legend.opacity = 1) +
  #mapview(ponddat, col.regions = "lightblue", layer.name = "Ponds") +
  mapview(pointdat.shp, zcol = "Structure_Type", 
          col.regions = c("red", "orange", "blue", "pink", "yellow"),
          layer.name = "Structure Type",
          alpha.regions = 10,
          legend.opacity = 1)


