#===============================================================================
# 2022-09-14 -- LCDS dataviz
# Geofaceting & treemap
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================



# links --------------------------------------------------------------------

# Geofaceted Mexico in our recent paper
# https://twitter.com/ikashnitsky/status/1159314320909623297


# We will replicate the minimal example from here
# https://hafen.github.io/geofacet/

# See also the examples with TidyTuesday #School Diversity dataset
# https://twitter.com/CedScherer/status/1178010248084381696
# https://twitter.com/MYMRockMama/status/1178312979508391936
# https://twitter.com/_Gil_Henriques/status/1176909412503441408

# and especially
# https://twitter.com/zhiiiyang/status/1176894911083212801

# On the advantage of waffle plot
# https://twitter.com/ikashnitsky/status/1178266669828988928

# Once again a stub at pie charts
# https://www.darkhorseanalytics.com/blog/salvaging-the-pie

# and once more
# https://twitter.com/hrbrmstr/status/1184515671872462849


# plot ---------------------------------------------------------------

library(tidyverse)
library(geofacet)
library(magrittr)

state_unemp %>% 
    ggplot(aes(year, rate)) +
    geom_line() +
    facet_geo(~ state, grid = "us_state_grid2", label = "name") +
    scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
    labs(title = "Seasonally Adjusted US Unemployment Rate 2000-2016",
         caption = "Data Source: bls.gov",
         x = "Year",
         y = "Unemployment Rate (%)") +
    ggdark::dark_theme_minimal()+
    theme(strip.text.x = element_text(size = 6))



# real life example -------------------------------------------------------

# treemap example using TidyTuesday Schools Ethnic Diversity dataset
df <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-24/school_diversity.csv")

#  calculate statstic to plot
eth <- df %>% 
    pivot_longer(Asian:Multi, names_to = "race",  values_to = "prop") %>% 
    group_by(ST, race, SCHOOL_YEAR) %>% 
    summarise(prop = weighted.mean(prop, Total)) %>% 
    ungroup()

library(treemapify)
library(prismatic)

# choosing colors for race
col <- RColorBrewer::brewer.pal(8, "Accent")

col %>% prismatic::color() %>% plot

pal <- col %>% extract(c(1, 8, 6,  5, 3))

pal %>% color 
pal %>% color %>% prismatic::clr_grayscale()
pal %>% color %>% prismatic::clr_deutan()

eth %>% 
    filter(SCHOOL_YEAR == "2016-2017") %>% 
    ggplot(aes(area = prop, fill = race))+
    geom_treemap()+
    scale_fill_manual(values = pal)+
    facet_geo(~ST, grid = "us_state_grid2", label = "name")


# SCHOOL_YEAR == "1994-1995"
