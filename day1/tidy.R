#===============================================================================
# 2024-07-15 -- BSSD dataviz
# Tidy data
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the package
library(tidyverse)
library(magrittr)

# PIPES: from %>% to R native |> [shift+cmd/crtl+M]


# Read the data with readxl -----------------------------------------------

library(readxl)

# see the names of the sheets
readxl::excel_sheets("data/data-denmark.xlsx")

deaths <- read_excel(path = "data/data-denmark.xlsx", sheet = "deaths")
pop <- read_excel(path = "data/data-denmark.xlsx", sheet = "pop")


# Reshaping data with tidyr -----------------------------------------------

# to wide format
pop_w <- pivot_wider(
    data = pop,
    names_from = year,
    values_from = value
)

# equivalently we can start using the piping operator ( |> )
pop_w <- pop |>
    pivot_wider(names_from = year, values_from = value)

# back to long format
pop_l <- pop_w |> pivot_longer(contains("200"), names_to = "year")


# Basic dplyr functions ---------------------------------------------------

# filter
pop_filt <- pop |> filter(year == "y2003", !sex == "b")

# magrittr !!!

# select
pop_select <- pop |> select(contains("a"))


# bind dfs
df_bind <- bind_rows(pop, deaths)


# join
df_joined <- left_join(deaths, pop, by = c("year", "region", "sex", "age"))


# rename
df_re <- df_joined |>
    rename(deaths = value.x, pop = value.y)


# mutate
df <- df_re |> mutate(mx = deaths / pop)

# transmute as a shortcut for both rename and mutate (+select)
df_tr <- df_joined |> transmute(region, sex, mx = value.x / value.y)



# group |> summarize |> ungroup
df_sum <- pop |>
    group_by(region, sex, age) |>
    summarise(mean = mean(value)) |>
    ungroup()


# summarise_if(is.numeric, ...)
df_sum_if <- pop |>
    pivot_wider(names_from = year, values_from = value) |>
    group_by(sex, age) |>
    summarise_if(.predicate = is.numeric, .funs = mean)


# now we save the data frame to be used later
df <- inner_join(deaths, pop, by = c("year", "region", "sex", "age")) |>
    rename(deaths = value.x, pop = value.y) |>
    mutate(mx = deaths / pop)



# saving data in Rdata (rda) format ---------------------------------------

save(df, file = "data/denmark.Rdata")
# # equivalently we can use
# save(df, file = "data/denmark.rda")

rm(list = ls()) # NOTE! forbidden line, never use mindlessly
# Have a look at the detailed explanation by Jenny Bryant
# https://www.tidyverse.org/blog/2017/12/workflow-vs-script/

# load the result again
load("data/denmark.Rdata")