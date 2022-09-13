#===============================================================================
# 2022-09-14 -- LCDS dataviz
# dotplot and ggtext
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# https://ikashnitsky.github.io/2019/dotplot

# Aburto, J. M., Schöley, J., Kashnitsky, I., Zhang, L., Rahal, C., Missov, T. I., Mills, M. C., Dowd, J. B., & Kashyap, R. (2021). Quantifying impacts of the COVID-19 pandemic through life-expectancy losses: A population-level study of 29 countries. International Journal of Epidemiology, dyab207. https://doi.org/10.1093/ije/dyab207

# https://github.com/OxfordDemSci/ex2020

# https://www.zeileis.org/news/euro2020

# EURO 2020 predictions
# https://twitter.com/ikashnitsky/status/1403645553637011461


# The one we'll replicate
# #RotateTheDamnPlot (https://twitter.com/DamnPlot)
# https://twitter.com/ikashnitsky/status/1521960898440613889



# ggtext-example ----------------------------------------------------------

# Royal longevity
# https://twitter.com/ikashnitsky/status/1382595760756244481

# below goes just a copy of the code from the gist linked in the tweet above, I only changed the lines that load cohort life tables for the UK, which are now in the "data" repository, and the lines with `ggsave()` calls to save all the plots in "out" directory

#===============================================================================
# 2021-04-19 -- critique
# Re-analysis of Royal family members longevity
# https://theconversation.com/amp/long-live-the-monarchy-british-royals-tend-to-survive-a-full-three-decades-longer-than-their-subjects-158766
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

library(tidyverse)
library(magrittr)
library(lubridate)
library(hrbrthemes)
library(ggtext)
library(ggdark)

dates <- tibble::tribble(
    ~person, ~sex, ~ruller,       ~birth,       ~death,  ~coronation,
    "Queen Victoria*",  "f",    TRUE, "1819-05-24", "1901-01-22", "1837-06-20",
    "Prince Albert*",  "m",   FALSE, "1819-08-26", "1861-12-14", "1837-06-20",
    "King Edward VII",  "m",    TRUE, "1841-11-09", "1910-05-06", "1901-01-22",
    "Alexandra of Denmark",  "f",   FALSE, "1844-12-01", "1925-11-20", "1901-01-22",
    "King George V",  "m",    TRUE, "1865-06-03", "1936-01-20", "1910-05-06",
    "Queen Mary",  "f",   FALSE, "1867-05-26", "1953-03-24", "1910-05-06",
    "King Edward VIII",  "m",    TRUE, "1894-06-23", "1972-05-28", "1936-01-20",
    "Wallis Simpson**",  "f",   FALSE, "1896-06-19", "1986-04-24", "1936-01-20",
    "King George VI",  "m",    TRUE, "1895-12-14", "1952-02-06", "1936-11-11",
    "Lady Elizabeth Bowes-Lyon",  "f",   FALSE, "1900-08-04", "2002-03-30", "1936-11-11",
    "Queen Elizabeth II***",  "f",    TRUE, "1926-04-21", "2021-04-15", "1952-02-06",
    "Prince Philip",  "m",   FALSE, "1921-06-21", "2021-04-09", "1952-02-06"
) %>%
    transmute(
        person = person %>% as_factor %>% fct_rev,
        sex, ruller,
        birth = birth %>% ymd,
        death = death %>% ymd,
        coronation = coronation %>% ymd,
        birth_year = birth %>% year,
        # coronation_year = coronation %>% year,
        age_at_coronation = (coronation - birth) %>% as.duration() %>%
            as.numeric("years") %>% floor,
        longevity = (death - birth) %>% as.duration() %>% as.numeric("years"),
        birth_year_fix = birth_year %>% if_else(.<1842, 1841, .)
    )

# load cohort life tables of the UK
load("data/uk_clt.rda")

# remaining cohort life expectancy for the population at coronation age
comp <- dates %>%
    left_join(
        uk_clt %>% select(sex, year, age, ex),
        by = c("sex", "birth_year_fix" = "year", "age_at_coronation" = "age")
    ) %>%
    mutate(
        cohort_ex = age_at_coronation + ex
    )

# visualize
comp %>%
    ggplot(aes(longevity, person))+
    geom_hline(
        data = . %>% slice(seq(1,11,2)),
        aes(yintercept = person), size = 9, color = "#eaeaea"
    )+
    geom_vline(xintercept = 0, color = 8, size = 1)+
    geom_point(color = "#B5223B", size = 2)+
    geom_point(aes(x = cohort_ex), color = "#64B6EE", shape = 124, size = 5)+
    scale_x_continuous(limits = c(0, 105), expand = c(0,0), position = "top")+
    theme_minimal(base_family = font_rc)+
    theme(
        plot.title = element_markdown(family = "Roboto Slab", face = 2),
        plot.subtitle = element_markdown(),
        axis.text.y = element_text(size = 12, face = 2),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank()
    )+
    labs(
        title = "Longevity of the <span style = 'color:#B5223B;'>UK monarchs and their spouses</span>",
        subtitle = "Compared with the people of their <span style = 'color:#64B6EE;'>birth cohort</span> who survived to the age of their coronation",
        caption = "Notes: *For Queen Victoria and Prince Albert the earliest available cohort life table, 1841, was used; **Wallis Simpson was never crowned, King Edward VIII's\ncoronation date is used; ***Queen Elizabeth II's current age is shown. Data: Human Mortality Database | Analysis and graphic: Ilya Kashnitsky, @ikashnitsky",
        y = NULL,
        x = "Longevity, years"
    )+
    annotate(
        "text", x = c(65, 50), y = c("King Edward VIII", "King George VI"),
        label = c("Reference subjects", "Monarchs"), hjust = 1,
        size = 4, family = "Roboto Slab", color = c("#64B6EE", "#B5223B")
    )

ggsave(
    "out/royal-survival.png", width = 8, height = 4.5, type = "cairo-png", bg = "#ffffff"
)


# average gap
comp %>% summarise(avg_premium = mean(longevity - cohort_ex))


# survival percentiles ----------------------------------------------------

surv_coronation <- dates %>%
    left_join(
        uk_clt %>% select(sex, year, age, lx),
        by = c("sex", "birth_year_fix" = "year", "age_at_coronation" = "age")
    ) %>%
    mutate(
        lx_coronation = lx,
        prop_surv_coronation = lx/1e5
    )

surv_death <- dates %>%
    mutate(age_at_death = longevity %>% floor) %>%
    left_join(
        uk_clt %>% select(sex, year, age, lx, dx),
        by = c("sex", "birth_year_fix" = "year", "age_at_death" = "age")
    ) %>%
    mutate(lx_death = lx - (longevity-age_at_death)*dx)

prop_outlived <- left_join(
    surv_coronation %>% select(person, lx_coronation, prop_surv_coronation),
    surv_death %>% select(person, longevity, lx_death)
) %>%
    mutate(prop_outlived = 1 - (lx_death / lx_coronation))


# visualize
prop_outlived %>%
    ggplot(aes(prop_outlived, person))+
    geom_hline(
        data = . %>% slice(seq(1,11,2)),
        aes(yintercept = person), size = 9, color = "#eaeaea"
    )+
    geom_vline(xintercept = c(0, .5, 1), color = 8, size = 1)+
    geom_point(color = "#B5223B", size = 2)+
    scale_x_percent(limits = c(0, 1), expand = c(0,0), position = "top")+
    theme_minimal(base_family = font_rc)+
    theme(
        plot.title = element_markdown(family = "Roboto Slab", face = 2),
        axis.text.y = element_text(size = 12, face = 2),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank()
    )+
    labs(
        title = "Relative survival of the <span style = 'color:#B5223B;'>UK monarchs and their spouses</span>",
        subtitle = "Compared with the people of their birth cohort who survived to the age of their coronation",
        caption = "Notes: *For Queen Victoria and Prince Albert the earliest available cohort life table, 1841, was used; **Wallis Simpson was never crowned, King Edward VIII's\ncoronation date is used; ***Queen Elizabeth II's current age is shown. Data: Human Mortality Database | Analysis and graphic: Ilya Kashnitsky, @ikashnitsky",
        y = NULL,
        x = "Relative survival"
    )

ggsave(
    "out/royal-survival-relative.png", width = 8, height = 4.5, type = "cairo-png"
)



# try combining both plots ------------------------------------------------
# UPD  2021-04-16 ------------------------------

comb_peers <- uk_clt %>%
    right_join(dates, by = c("year" = "birth_year_fix", "sex")) %>%
    filter(age %>% is_weakly_greater_than(age_at_coronation)) %>%
    mutate(person = person %>% as_factor()) %>% 
    group_by(person) %>%
    mutate(
        prop_peers_alive = lx / lx[1] * 100
    )

# unified plot
comb_peers %>%
    ggplot(aes(age, person))+
    geom_vline(xintercept = c(0), color = 8, size = 1)+
    geom_tile(aes(fill = prop_peers_alive), height =.7)+
    scale_fill_viridis_c(
        option = "mako",
        guide = guide_colorbar(
            barwidth = 25, barheight = 1, reverse = TRUE,
            title.position = "top"
        )
    )+
    geom_point(
        data = . %>% filter(age == age_at_coronation),
        aes(x = age_at_coronation + ex),
        color = "#ffffff",
        shape = 124, size = 4
    )+
    geom_point(
        aes(x = longevity),
        fill = "#B5223B", color = "#ffffff",
        shape = 21, size = 2
    )+
    # annotate outliving peers
    geom_text(
        data = prop_outlived,
        aes(
            x = longevity,
            label = prop_outlived %>% multiply_by(1e2) %>%
                round(1) %>% paste0("%")
        ),
        hjust = 1.2, size = 3.2, family = font_rc, color = "#B5223B"
    )+
    # annotate suvrivorship to coronation
    geom_text(
        data = . %>% filter(age == age_at_coronation),
        aes(label = paste0((lx/1e3) %>% round(1), "%")),
        hjust = 1.2, size = 3.2, family = font_rc, color = "#64B6EE"
    )+
    # annotate blue % text explainer
    annotate(
        "text", x = 5, y = "King Edward VII",
        label = "Percentage of the birth cohort\nalive at monarch's coronation age",
        hjust = 0, size = 4, family = font_rc, face = 2,
        lineheight = .7, vjust = .8, color = "#64B6EE"
    )+
    # annotate red % text explainer
    annotate(
        "text", x = 100, y = "Queen Victoria*",
        label = "Percentage of the reference birth cohort outlived",
        hjust = 1, size = 4, family = font_rc, face = 2,
        lineheight = .7, vjust = -.9, color = "#B5223B"
    )+
    scale_x_continuous(limits = c(0, 105), expand = c(0,0))+
    scale_y_discrete(expand = c(0, 1.5))+
    dark_theme_minimal(base_family = font_rc)+
    theme(
        plot.title = element_markdown(family = "Roboto Slab", face = 2),
        plot.subtitle = element_markdown(),
        legend.title = element_markdown(),
        axis.text.y = element_text(size = 12, face = 2),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid = element_line(color = "#eaeaea77"),
        plot.background = element_rect(fill = "#000000", color = NA),
        legend.position = "top"
    )+
    labs(
        title = "Longevity of the <span style = 'color:#B5223B;'>UK monarchs and their spouses</span>",
        subtitle = "Compared with the people of their birth cohort who survived to the age of their coronation",
        caption = "Notes: *For Queen Victoria and Prince Albert the earliest available cohort life table, 1841, was used; **Wallis Simpson was never crowned, King Edward VIII's\ncoronation date is used; ***Queen Elizabeth II's current age is shown. Data: Human Mortality Database | Analysis and graphic: Ilya Kashnitsky, @ikashnitsky",
        y = NULL,
        x = "Longevity, years",
        fill = "Proportion of the (remaining after coronation age) <span style = 'color:#64B6EE;'>reference birth cohort</span> still alive, %"
    )

ggsave(
    "out/royal-survival-combined.png", width = 8, height = 4.5, type = "cairo-png"
)
