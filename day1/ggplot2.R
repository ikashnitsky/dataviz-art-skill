#===============================================================================
# 2020-07-13 -- MPIDR dataviz
# ggplot2 basics
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)


# base --------------------------------------------------------------------


# automatic plots for linear model
obj <- lm(data = swiss, Fertility ~ Education)
plot(obj)



# blank map
library(rgdal)
shapefile <- readOGR("data/.", "shape-france")
plot(shapefile)



# ggplot2 -----------------------------------------------------------------

# The logic


ggplot()

swiss %>% View

? swiss



# geom_point
ggplot(
    data = swiss,
    aes(x = Agriculture, y = Fertility)
) +
    geom_point()

gg <- last_plot()

# saving a plot
ggsave(filename = "out/test.png", plot = gg)

# we can also save a plot as an R object
save(gg, file = "out/gg_swiss.rda")



# basic geoms -------------------------------------------------------------

# line / path
df_aq <- airquality %>%
    janitor::clean_names() %>%
    mutate(
        date = paste(day, month, "1973", sep = "-") %>%  lubridate::dmy(),
        month = month %>% factor
    )



ggplot(df_aq) +
    geom_line(aes(x = date, y = temp))


df_aq %>%
    ggplot(aes(x = date, y = temp)) +
    geom_path()


df_aq %>%
    ggplot(aes(x = day, y = temp, group = month)) +
    geom_line()

df_aq %>%
    ggplot(aes(x = day, y = temp, color = month)) +
    geom_line()

df_aq %>%
    ggplot(aes(x = date, y = temp, color = month)) +
    geom_line()



library(gapminder)

gapminder %>%
    select(1:4) %>%
    group_by(continent, year) %>%
    summarise(avg_e0 = lifeExp %>% mean) %>%
    ungroup() %>%
    ggplot(aes(x = year, y = avg_e0, color = continent)) +
    geom_path(size = 1) +
    theme_minimal(base_family = "mono")






load("data/Denmark.Rdata")

df %>%
    filter(year == "2004", sex == "m",!age %in% c("total", "open")) %>%
    mutate(age = age %>% as.numeric()) %>% 
    ggplot() +
    geom_line(
        aes(
            x = age,
            y = mx,
            group = region,
            color = region
        )
    ) +
    scale_y_continuous(trans = "log", breaks = c(.0001, .001, .01)) +
    theme_minimal()





# faceting ----------------------------------------------------------------

# plot wind against temperature
df_aq %>% 
    ggplot(aes(wind, temp))+
    geom_point()

# distinguish months by colors
df_aq %>% 
    ggplot(aes(wind, temp, color = month))+
    geom_point()

# let's see them separately with faceting
df_aq %>% 
    ggplot(aes(wind, temp, color = month))+
    geom_point()+
    facet_wrap(~ factor(month), ncol = 3)


# more advanced -----------------------------------------------------------

# let's re-create the simplest plot
ggplot(
    data = swiss,
    aes(x = Agriculture, y = Fertility)
) +
    geom_point()

# and save it in an object
gg <- last_plot()


# stat operations ---------------------------------------------------------

# stat_smooth
gg + stat_smooth()

# linear model
gg + stat_smooth(method = "lm")

# remove confidence intervals
gg + stat_smooth(method = "lm", se = F, col = "red")


# stat_ellipse
swiss %>%
    ggplot(
        aes(
            x = Agriculture, y = Fertility,
            color = Catholic > 50
        )
    ) +
    geom_point() +
    stat_ellipse() +
    theme_minimal(base_family = "mono")



# more geoms --------------------------------------------------------------

# density / ecdf (airquality)

ggplot(airquality) +
    geom_density(aes(x = Temp, color = factor(Month)), size = 1) +
    scale_color_viridis_d(option = "D", end = .8) +
    theme_minimal() +
    theme(legend.position = c(.1, .8))

ggplot(airquality) +
    stat_ecdf(aes(x = Temp, color = factor(Month)), size = 1) +
    scale_color_viridis_d(option = "B", end = .8) +
    theme_minimal() +
    theme(legend.position = c(.1, .8))


# boxplot
ggplot(airquality) +
    geom_boxplot(aes(x = factor(Month), y = Temp))

# violin
ggplot(airquality) +
    geom_violin(
        aes(
            x = factor(Month),
            y = Temp,
            fill = factor(Month)
        )
    )

# jitter
ggplot(airquality) +
    geom_jitter(
        aes(
            x = factor(Month),
            y = Temp,
            color = factor(Month)
        ),
        width = .2
    )


# label lines hack --------------------------------------------------------

# https://twitter.com/ikashnitsky/status/1045428469801385987

