#===============================================================================
# 2022-09-14 -- LCDS datavizs
# smoothed dots
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

# Zarulli V, Kashnitsky I, Vaupel JW. 2021. Death rates at specific life stages mold the sex gap in life expectancy. Proceedings of the National Academy of Sciences 118 DOI: 10.1073/pnas.2010588118

# https://github.com/ikashnitsky/sex-gap-e0-pnas

# https://twitter.com/ikashnitsky/status/1391859895264231431

library(tidyverse)
library(magrittr)

df_aq <- airquality %>%
    janitor::clean_names() %>%
    mutate(
        date = paste(day, month, "1973", sep = "-") %>%  
            lubridate::dmy(),
        month = month %>% factor
    )

df_aq %>%
    ggplot(aes(x = date, y = temp, color = month)) +
    geom_line()

df_aq %>%
    ggplot(aes(x = date, y = temp, color = month)) +
    geom_point()+
    geom_line(size = 2, alpha = .3)

df_aq %>%
    ggplot() +
    geom_point(aes(x = date, y = temp, color = month))+
    geom_smooth(se = F, aes(x = date, y = temp), color = 1)

# The one we are going to replicate
# https://twitter.com/ikashnitsky/status/1527024793136111616

# below goes just a copy of the code from the gist linked in the tweet above, I only added now a line that installs {sjrdata} from a github repository and changed the last line that saves the plot in "out" directory.

#===============================================================================
# 2022-05-18 -- sjrdata
# Illustrate the package using some demographic journals
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

library(tidyverse)
library(hrbrthemes)
remotes::install_github("ikashnitsky/sjrdata")
library(sjrdata)

df <- sjr_journals %>% view

df %>%
    filter(title %in% c(
        "Demography",
        "Population and Development Review",
        "European Journal of Population",
        "Population, Space and Place",
        "Demographic Research",
        "Genus"
    )) %>%
    mutate(year = year %>% as.numeric) %>%
    ggplot(aes(year, sjr, color = title))+
    geom_hline(yintercept = 0, size = .75, color = "#3a3a3a")+
    geom_point(aes(size = total_docs_year), alpha = .5)+
    stat_smooth(se = F, span = .85)+
    geom_text(
        data = . %>% filter(year == 2021),
        aes(label = title),
        x = 1998, y = seq(3.7, 2.7, length.out = 6),
        hjust = 0, family = font_rc
    )+
    scale_color_brewer(NULL, palette = "Dark2")+
    scale_y_continuous(limits = c(0, 3.7), position = "right")+
    theme_minimal(base_family = font_rc)+
    theme(
        legend.position = "none",
        plot.title = element_text("Roboto Slab", face = 2)
    )+
    labs(
        x = NULL,
        y = "SJR index",
        title = "Selected demographic journals",
        subtitle = "SCImago Journal Rank, 1999-2021, via #rstats {sjrdata}",
        caption = "@ikashnitsky"
    )

ggsave("out/sjr-demography.png", width = 6.4, height = 3.6, type = "cairo-png", bg = "#ffffff")
