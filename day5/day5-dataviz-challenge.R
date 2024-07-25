#===============================================================================
# 2024-07-19 -- BSSD dataviz
# Dataviz challenge
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# Please submit your dataviz by the link in the main course's github README
# https://github.com/ikashnitsky/dataviz-bssd?tab=readme-ov-file#links-to-submit-in-class-assignments

# load required/suggested packages
library(tidyverse)
library(sf)

# the data
ufo_sightings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-25/ufo_sightings.csv") |> 
    # clean up a bit
    mutate(
        date_time = date_time |> parse_date_time('mdy_HM'),
        month = date_time |> month(label = TRUE) |> as.factor(),
        year = date_time |> year(),
        day = date_time |> day(),
        week = date_time |> week(),
        wday = date_time |> wday(week_start = 1, label = TRUE),
        date_documented = date_documented |> parse_date_time('mdy'),
        gap_doc = as.duration(date_documented - date_time) / 
            as.duration(years(1))
    )
