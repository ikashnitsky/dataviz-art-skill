#===============================================================================
# 2024-07-18 -- BSSD dataviz
# Geocoding address example
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# Deriving coordinates from a sting of text that represents a physical location on Earth is a common geo data processing task. A common case would be an address question in a survey. There is a way to automate queries to a special GIS service so that it takes a text sting as an input and returns the geographic coordiantes. Here I give an example with the birth places that you kindly contributed.
# Data (no longer editable): 
# https://docs.google.com/spreadsheets/d/1YlfLQc_aOOiTqaSGu5TI70OQy1ewTa_Ti0qAEOEcy58

library(tidyverse)
library(sf)
library(ggdark)

# download the data
# https://stackoverflow.com/a/28986107/4638884
library(gsheet)

raw <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1YlfLQc_aOOiTqaSGu5TI70OQy1ewTa_Ti0qAEOEcy58")

df <- raw |> 
    janitor::clean_names() |> 
    drop_na() |> 
    mutate(text_to_geocode = paste(city_settlement, country, sep = ", "))

# now geocode
# there is a new brilliant package tidygeocoder
library(tidygeocoder)

df_geocoded <- df |> 
    geocode(text_to_geocode, method = "osm")

# convert coordinates to an sf object
df_plot <- df_geocoded |> 
    drop_na() |> 
    st_as_sf(
        coords = c("long", "lat"),
        crs = 4326
    )


# get world map outline (you might need to install the package)
world_outline <- spData::world |> 
    st_as_sf()

# let's use a fancy projection
world_outline_robinson <- world_outline |> 
    st_transform(crs = "ESRI:54030")

country_borders <- world_outline_robinson |> 
    rmapshaper::ms_innerlines()


# map!
world_outline_robinson |> 
    filter(!iso_a2 == "AQ") |> 
    ggplot()+
    geom_sf(fill = "#673862", color = NA)+
    geom_sf(data = country_borders, size = .25, color = "#BD92B7FF")+
    geom_sf(
        data = df_plot, fill = "#FDD15E", 
        color = "#FDD15E" |> prismatic::clr_darken(),
        size = 1.5, shape = 21
    )+
    coord_sf(datum = NA)+
    dark_theme_minimal(base_family = "Atkinson Hyperlegible")+
    labs(
        title = "Birth places of the participants",
        subtitle = "BSSD Dataviz course at CED, July 2022",
        caption = "@ikashnitsky"
    )+
    theme(
        plot.background = element_rect(fill = "#15202b", color = NA),
        axis.text = element_blank(),
        plot.title = element_text(face = 2, size = 18)
    )

ggsave("out/map-birth-places.png", width = 5.33, height = 3)  
