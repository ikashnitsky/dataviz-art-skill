#===============================================================================
# 2021-06-17 -- MPIDR dataviz
# Geocoding address example
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# Deriving coordinates from a sting of text that represents a physical location on Earth is a common geo data processing task. A common case would be an address question in a survey. There is a way to automate queries to a special GIS service so that it takes a text sting as an input and returns the geographic coordiantes. Here I give an example with the birth places that you kindly contributed.
# Data (no longer editable): 
# https://docs.google.com/spreadsheets/d/1votBvnnKwa-m04Il5eZFAEB8UrUCxxx9mQcwyJmnjjY/edit?usp=sharing 

library(tidyverse)
library(sf)
library(ggdark)

# download the data
# https://stackoverflow.com/a/28986107/4638884
library(gsheet)

raw <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1votBvnnKwa-m04Il5eZFAEB8UrUCxxx9mQcwyJmnjjY")

df <- raw %>% 
  janitor::clean_names() %>% 
  drop_na() %>% 
  mutate(text_to_geocode = paste(city_settlement, country, sep = ", "))

# now geocode
# there is a new brilliant package tidygeocoder
library(tidygeocoder)

df_geocoded <- df %>% 
  geocode(text_to_geocode, method = "osm")

# convert coordinates to an sf object
df_plot <- df_geocoded %>% 
  st_as_sf(
    coords = c("long", "lat"),
    crs = 4326
  )


# get world map outline (you might need to install the package)
world_outline <- spData::world %>% 
  st_as_sf()

# let's use a fancy projection
world_outline_robinson <- world_outline %>% 
  st_transform(crs = 54030)

country_borders <- world_outline_robinson %>% 
  rmapshaper::ms_innerlines()


# map!
world_outline_robinson %>% 
  ggplot()+
  geom_sf(fill = 7, color = NA)+
  geom_sf(data = country_borders, size = .5, color = "#ffffff")+
  geom_sf(data = df_plot, color = 2, size = 1.5, shape = 16)+
  dark_theme_minimal()+
  labs(
    title = "Birth places of the participants",
    subtitle = "IDEM 181 Dataviz course at MPIDR, June 2021",
    caption = "@ikashnitsky"
  )+
  theme(
    plot.background = element_rect(fill = "#222222")
  )

ggsave("out/map-birth-places.png", width = 7, height = 5)  
