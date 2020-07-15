#===============================================================================
# 2020-07-16 -- MPIDR dataviz
# Equality line plot
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================



# links --------------------------------------------------------------

# https://twitter.com/cchappas/status/1076910768711446528



# play with GGP educational attainment data -------------------------------

library(tidyverse)
library(janitor)

educ <- read_csv2(here::here("data/CDB_EAUS.csv"), na = "..", skip = 2) %>% 
    pivot_longer(3:50, names_to = "year") %>% 
    mutate(value = value / 100) %>%
    pivot_wider(names_from = Sex, values_from = value) %>% 
    clean_names() %>% 
    separate(country_engl_name_nat_name, into = c("cntr", "rest"), sep = "/") %>% 
    transmute(
        id = cntr %>% str_sub(1,2),
        name = cntr %>% str_sub(3, -1),
        year,
        total,  female, male
    ) %>% 
    drop_na()

library(ggdark)
library(ggrepel)

educ %>% 
    ggplot(aes(female, male, group = name, color = year))+
    geom_abline(slope = 1)+
    geom_path()+
    geom_point(size = .3)+
    scale_color_viridis_d(option = "B", begin = .2, end = .9)+
    coord_fixed(xlim = c(0, 100), ylim = c(0, 100), expand = F)+
    geom_text_repel(
        data = . %>% 
            drop_na(total) %>% 
            group_by(name) %>% 
            arrange(year %>% desc) %>% 
            slice(1) %>% 
            dplyr::ungroup(),
        aes(label = name), size = 2, color = "white", 
        nudge_x = 2, nudge_y = 2
    )+
    dark_theme_minimal()



# one year
educ %>% 
    filter(year == "2015") %>% 
    ggplot(aes(female, male, group = name, color = total))+
    geom_abline(slope = 1)+
    geom_point(size = 2)+
    scale_color_viridis_c(option = "B", begin = .2, end = .9)+
    coord_fixed(xlim = c(0, 100), ylim = c(0, 100), expand = F)+
    geom_text_repel(
        data = . %>% 
            drop_na(total) %>% 
            group_by(name) %>% 
            slice(1) %>% 
            dplyr::ungroup(),
        aes(label = name), size = 2, color = "white"
    )+
    dark_theme_minimal()+
    theme(legend.position = "none")
