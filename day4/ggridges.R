#===============================================================================
# 2020-07-16 -- MPIDR dataviz
# ggridges
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================



# ggridges ----------------------------------------------------------------

# https://twitter.com/ikashnitsky/status/886978944985071616

library(tidyverse)
library(ggridges)
library(wpp2015)

# get the UN country names
data(UNlocations)

countries <- UNlocations %>% pull(name) %>% paste

# data on male life expectancy at birth
data(e0M)

e0M %>% 
    filter(country %in% countries) %>%
    select(-last.observed) %>%
    gather(period, value, 3:15) %>%
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


