#===============================================================================
# 2022-09-12 -- LCDS dataviz
# Tidy data
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the package
library(tidyverse)
library(magrittr)


# Read the data with readxl -----------------------------------------------

library(readxl)

# see the names of the sheets
readxl::excel_sheets("data/data-denmark.xlsx")
  
deaths <- read_excel(path = "data/data-denmark.xlsx", sheet = "deaths")
pop <- read_excel(path = "data/data-denmark.xlsx", sheet = "pop")


# Reshaping data with tidyr -----------------------------------------------

# to wide format
pop_w <- pivot_wider(data = pop, names_from = year, values_from = value)

# equivalently we can start using the piping operator ( %>% )
pop_w <- pop %>% 
  pivot_wider(names_from = year, values_from = value)

# back to long format
pop_l <- pop_w %>% pivot_longer(contains("200"), names_to = "year")



# Basic dplyr functions ---------------------------------------------------

# filter
pop_filt <- pop %>% filter(year=="2003", !sex=="b")

# select
pop_select <- pop %>% select(contains("a"))

# slice
deaths %>% slice(1:3)

# slice_max
deaths %>% slice_max(value)

# group
deaths %>% 
  group_by(region, sex) %>% 
  slice_max(value)

# group %>% summarize %>% ungroup
df_sum <- pop %>% 
  group_by(region, sex, age) %>% 
  summarise(mean = mean(value)) %>% 
  ungroup()


# join
df_joined <- left_join(deaths, pop, by = c("year", "region", "sex", "age")) 


# rename
df_re <- df_joined %>% 
  rename(deaths = value.x, pop = value.y)


# mutate 
df <- df_re %>% mutate(mx = deaths / pop)

# transmute as a shortcut for both rename and mutate (+select)
df_tr <- df_joined %>% transmute(region, sex, mx = value.x / value.y)




# saving data in Rdata (rda) format ---------------------------------------


# save clean data frame 
df <- inner_join(deaths, pop, by = c("year","region","sex","age")) %>% 
  rename(deaths = value.x, pop = value.y) %>% 
  mutate(mx = deaths / pop)

save(df, file = "data/Denmark.Rdata")

# load the result again
load("data/Denmark.Rdata")
