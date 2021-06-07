#===============================================================================
# 2021-06-15 -- MPIDR dataviz
# Population pyramid example
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================


# load the package
library(tidyverse)
library(magrittr)


# download eurostat data
library(eurostat)

eu_pop <- get_eurostat("demo_pjan")


# clean the dataset
df_dk <- eu_pop %>% 
    filter(
        !age %in% c("TOTAL", "UNK", "Y_OPEN"),
        geo == "DK"
    ) %>% 
    mutate(
        year = time %>% lubridate::year(),
        age = age %>% 
            paste %>% 
            str_replace("Y_LT1", "Y_0") %>% 
            str_remove("_") %>%  
            str_remove("Y") %>% 
            as.numeric()
    ) %>% 
    arrange(time, sex, age)


save(df_dk, file = "data/df_dk.rda")


df_dk %>% 
    filter(
        year == 2018, sex == "T"
    ) %>% 
    ggplot(aes(age, values))+
    geom_col()
    
    
# both sex, coord_flip    

df_dk %>% 
    filter(
        year == 2018, !sex == "T"
    ) %>% 
    pivot_wider(names_from = sex, values_from = values) %>% 
    ggplot(aes(age))+
    geom_step(aes(y = `F`), color = "purple")+
    geom_step(aes(y = -M), color = "orange")+
    coord_flip()+
    scale_y_continuous(
        breaks = seq(-40000, 40000, 10000),
        labels = seq(-40000, 40000, 10000) %>% abs %>% paste %>% 
            str_replace("0000", "0K")
    )

# two years and annotations
df_dk %>% 
    filter(
        year %in% c(1960, 2018), !sex == "T"
    ) %>% 
    spread(sex, values) %>% 
    ggplot(aes(age))+
    geom_hline(yintercept = 0, size = .5, color = "gray20")+
    geom_path(aes(y = `F`, linetype = year %>% factor), color = "purple")+
    geom_path(aes(y = -M, linetype = year %>% factor), color = "orange")+
    coord_flip()+
    scale_y_continuous(
        breaks = seq(-40000, 40000, 10000),
        labels = seq(-40000, 40000, 10000) %>% 
            abs %>% divide_by(1000) %>% as.character()  %>% paste0(., "K")
        
    )+
    annotate(geom = "text", x = 100, y = -4e4, label = "MALES", hjust = 0, vjust = 1)+
    annotate(geom = "text", x = 100, y = 4e4, label = "FEMALES", hjust = 1, vjust = 1)



# compare two countries ---------------------------------------------------

df_two <- eu_pop %>% 
    filter(
        !age %in% c("TOTAL", "UNK", "Y_OPEN"),
        geo %in% c("IT", "BG")
    ) %>% 
    mutate(
        year = time %>% lubridate::year(),
        age = age %>% 
            paste %>% 
            str_replace("Y_LT1", "Y_0") %>% 
            str_remove("_") %>%  
            str_remove("Y") %>% 
            as.numeric()
    ) %>% 
    arrange(time, sex, age) %>% 
    group_by(sex, geo, time) %>% 
    mutate(values = values / sum(values))


df_two %>% 
    filter(
        year == 2018, sex == "T"
    ) %>% 
    ggplot(aes(age, values, color = geo))+
    geom_step()+
    coord_cartesian(expand = F)+
    scale_y_continuous(labels = scales::percent)+
    theme_minimal()+
    theme(legend.position = c(.9,.9))


# wrap the comparison as a function
compare_pop <- function(cntr = c("IT", "BG")) {
    
    df_sub <- eu_pop %>% 
        filter(
            !age %in% c("TOTAL", "UNK", "Y_OPEN"),
            geo %in% cntr 
        ) %>% 
        mutate(
            year = time %>% lubridate::year(),
            age = age %>% 
                paste %>% 
                str_replace("Y_LT1", "Y_0") %>% 
                str_remove("_") %>%  
                str_remove("Y") %>% 
                as.numeric()
        ) %>% 
        arrange(time, sex, age) %>% 
        group_by(sex, geo, time) %>% 
        mutate(values = values / sum(values))
    
    
    df_sub %>% 
        filter(
            year == 2018, sex == "T"
        ) %>% 
        ggplot(aes(age, values, color = geo))+
        geom_step()+
        coord_cartesian(expand = F)+
        scale_y_continuous(labels = scales::percent)+
        theme_minimal()+
        theme(legend.position = c(.9,.8))
}


c("UK", "ES", "IT", "DE", "FR") %>% compare_pop()


# a glance at interactive plotly magic
library(plotly)
gg <- ggplot2::last_plot()
ggplotly(gg) 

# plotly book
# https://plotly-r.com/introduction.html

