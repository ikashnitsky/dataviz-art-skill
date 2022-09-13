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
    theme_minimal() +
    theme(legend.position = "none")


# improve -----------------------------------------------------------------

library(countrycode)


life_exp <- e0M %>% 
  mutate(
    name = country_code %>% 
      countrycode(origin = "iso3n", destination = "country.name")
  ) %>% 
  drop_na(name) %>% 
  select(-last.observed) %>%
  pivot_longer(cols = 3:15, names_to = "period", values_to = "e0") 



# population counts
data(pop)

exposures <- pop %>% 
  pivot_longer(cols = 3:16, names_to = "year", values_to = "pop") %>% 
  group_by(name) %>% 
  transmute(
    period = paste(lag(year), year, sep = "-"),
    exposures = (pop + lag(pop)) / 2
  ) %>% 
  ungroup()

# join life expectancy and exposures
df <- left_join(life_exp, exposures, by = c("name", "period")) %>% 
  group_by(period) %>% 
  mutate(w = exposures %>% scales::rescale()) %>% 
  ungroup() %>% 
  drop_na(w)


df %>% 
  ggplot(aes(x = e0, y = period %>% fct_rev())) +
  # walk-around solution taken from here
  # https://github.com/wilkelab/ggridges/issues/5#issuecomment-338444835
  geom_density_ridges(
    aes(
      height = ..density..,
      weight = w,
      fill = period
    ),    
    scale = 2,
    stat ="density"
  ) +
  # geom_density_ridges(aes(fill = period, weight = exposures)) +
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
  theme_minimal() +
  theme(legend.position = "none")
