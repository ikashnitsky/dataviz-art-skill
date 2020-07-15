#===============================================================================
# 2020-07-16 -- MPIDR dataviz
# heatmap example
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)

# to do -- change to twitter ikashnitsky example


# load data --  New York Daily Death Records  1957--1967
load("data/death-by-day.rda")

# calendar plot of death tolls by day
df %>% 
    ggplot(aes(week, wday, fill = n))+
    geom_tile()+
    scale_fill_viridis_c("#deaths",option = "B")+
    scale_x_continuous(breaks = c(1:9, 20, 30, 52))+
    facet_grid(year~month, scales = "free")+
    theme_minimal(base_family = "mono")+
    theme(panel.grid = element_blank())+
    labs(x = "week of the year", y = NULL,
         title = "Numbers of deaths in New York State",
         caption = "Data: Genealogical Research Death Index: Beginning 1957\nhttps://www.healthdata.gov/dataset/genealogical-research-death-index-beginning-1957")
