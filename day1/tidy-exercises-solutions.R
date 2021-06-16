#===============================================================================
# 2021-06-14 -- MPIDR dataviz
# Tidy exercises
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================


# load the package
library(tidyverse)


# Read the data with readxl -----------------------------------------------

library(readxl)

# see the names of the sheets
readxl::excel_sheets('data/data-denmark.xlsx')

deaths <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'deaths')
pop <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'pop')


# Ex 1. deaths dataframe --------------------------------------------------

# - subset only total number of deaths among men in year 2003 (filter)
# Q: which region had the largest number of deaths?

deaths %>% 
  filter(year == "2003", sex == "m", age == "total") %>% 
  arrange(value %>% desc) # sort in descending order by value
deaths %>% 
  filter(year == "2003", sex == "m", age == "total") %>% 
  filter(value == max(value))

# A: Region DK01 (which is Copenhagen area, no wonder here)


# Ex 2. pop dataframe -----------------------------------------------------

# - subset only the year 2004
# - transform to wide format using the column "sex" (pivot_wider)
# - get rid of the column for both sex
# - calculate the sex ratio (males to females)
# Q: in which region the SR is highest at ages 15, 45, over75 (coded as "open")

pop %>% 
  filter(year == "2004") %>% 
  pivot_wider(names_from = sex, values_from = value) %>% 
  select(-b) %>% 
  mutate(sr = m / f) %>% 
  filter(age %in% c(15, 45, "open")) %>% 
  group_by(age) %>% 
  arrange(sr %>% desc) %>% 
  slice(1) # with this line we take only the first observation from each group

# A: DK01 at age 15;  DK03 at age 45; DK05 at age 75+



# Ex 3. joined dataframe --------------------------------------------------

# - join the two dataframes (left_join OR inner_join)
# - calculate age specific death ratios
# - subset only the ages 15-59 and year 2001
# Q: what is the average ratio of male ASDR to female ASDR in each region? 
# Tip: use summarize

df <- pop %>% 
  inner_join(deaths, by = c("year", "region", "sex", "age")) %>% 
  rename(pop = value.x, deaths = value.y) %>% 
  mutate(mx = deaths / pop)

df %>% 
  filter(age %in% 15:59, year == "2001") %>% 
  select(-year, -pop, -deaths) %>% 
  pivot_wider(names_from = sex, values_from = mx) %>% 
  select(-b) %>% 
  mutate(sr_mx = (m / f) %>% na_if(Inf)) %>% # replace Inf with NAs
  group_by(region) %>% 
  summarise(avg_mx_sr = sr_mx %>% mean(na.rm = TRUE)) %>% 
  ungroup()

# A:   
# region avg_mx_sr
# <chr>      <dbl>
# 1 DK01        1.77
# 2 DK02        2.22
# 3 DK03        2.34
# 4 DK04        2.06
# 5 DK05        1.93



# Ex 4. joined dataframe (df) ---------------------------------------------

# - subset only both sex
# - transform to wide format using the column "year" (pivot_wider)
# - calculate the growth of ASDR between 2005 and 2001
# Q: in which region the average growth/decrease in ASDR was largest?

df %>% 
  filter(sex == "b") %>% 
  select(-pop, -deaths) %>% 
  pivot_wider(names_from = year, values_from = mx) %>% 
  mutate(mx_growth = (`2005`/`2001`) %>% na_if(Inf)) %>% # note the `` -- bare numbers are not allowed for R objects
  group_by(region) %>% 
  summarise(avg_mx_growth = mx_growth %>% mean(na.rm = TRUE)) %>% 
  arrange(avg_mx_growth %>% desc)
  
# A: largest growth DK01 -- 1.03; largest decrease DK03 -- 0.9 