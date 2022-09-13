#===============================================================================
# 2022-09-14 -- LCDS dataviz
# ggridges
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================



# ggridges ----------------------------------------------------------------

# https://twitter.com/ikashnitsky/status/1367856010476613632

library(tidyverse)
library(ggridges)
library(wpp2015)

# data on male life expectancy at birth
data(e0M)

# UN locations
data(UNlocations)

countries <- UNlocations %>% 
  filter(location_type == 4) %>% 
  pull(name)



e0M %>% 
    filter(country %in% countries) %>%
    select(-last.observed) %>%
    pivot_longer(cols = 3:15, names_to = "period", values_to = "value") %>%
    ggplot(aes(x = value, y = period %>% fct_rev())) +
    geom_density_ridges(aes(fill = period)) +
    scale_fill_viridis_d(
        option = "B",
        direction = -1,
        begin = .1,
        end = .9
    ) +
    labs(
        x = "Male life expectancy at birth",
        y = "Period",
        title = "Global convergence in male life expectancy at birth since 1950",
        subtitle = "UNPD World Population Prospects 2015 Revision, via wpp2015",
        caption = "ikashnitsky.github.io"
    ) +
    theme_minimal(base_family =  "mono") +
    theme(legend.position = "none")


