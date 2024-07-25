#===============================================================================
# 2024-07-17 -- BSSD dataviz
# heatmap example
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)


# load data --  New York Daily Death Records  1957--1967
load("data/death-by-day.rda")

# calendar plot of death tolls by day
df |>
    ggplot(aes(week, wday, fill = n)) +
    geom_tile() +
    scale_fill_viridis_c("#deaths", option = "B") +
    scale_x_continuous(breaks = c(1:9, 20, 30, 52)) +
    facet_grid(year ~ month, scales = "free") +
    theme_minimal(base_family = "mono") +
    theme(panel.grid = element_blank()) +
    labs(
        x = "week of the year",
        y = NULL,
        title = "Numbers of deaths in New York State",
        caption = "Data: Genealogical Research Death Index: Beginning 1957\nhttps://www.healthdata.gov/dataset/genealogical-research-death-index-beginning-1957"
    )


# another example with twitter data
# https://twitter.com/ikashnitsky/status/1265570413997953024

# and one more using twitter data
# https://twitter.com/ikashnitsky/status/1546012109720506369

# see also
# https://twitter.com/favstats/status/1546141616003584006
