#===============================================================================
# 2021-06-15 -- MPIDR dataviz
# ggplot2 basics
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)


# base --------------------------------------------------------------------


# blank map
library(rgdal)
shapefile <- readOGR("data/.", "shape-france")
plot(shapefile)


# automatic plots for linear model
obj <- lm(data = swiss, Fertility ~ Education)
plot(obj)

# similar plot in ggplot2 framework using ggfortify
# https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_lm.html
library(ggfortify)
obj %>% autoplot(label.size = 3)
obj %>% autoplot(which = 1:6, ncol = 3, label.size = 3)

# autoplot example
mb_test <- microbenchmark::microbenchmark(
    a = sqrt(7),
    b = 7^.5
)

mb_test %>% autoplot()





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

# difference between geom_line and geom_path
set.seed(14)
tibble(
    id = 1:10,
    x = runif(10),
    y = runif(10)
)



library(gapminder)

gapminder %>%
    select(1:4) %>%
    group_by(continent, year) %>%
    summarise(avg_e0 = lifeExp %>% mean) %>%
    ungroup() %>%
    ggplot(aes(x = year, y = avg_e0, color = continent)) +
    geom_path(size = 1) +
    theme_minimal(base_family = "mono")



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

df_aq %>% 
    ggplot()+
    geom_density(aes(x = temp, color = month), size = 1) +
    scale_color_viridis_d(option = "D", end = .8) +
    theme_minimal() +
    theme(legend.position = c(.1, .8))

df_aq %>% 
    ggplot()+
    stat_ecdf(aes(x = temp, color = month), size = 1) +
    scale_color_viridis_d(option = "B", end = .8) +
    theme_minimal() +
    theme(legend.position = c(.1, .8))


# boxplot
df_aq %>% 
    ggplot()+
    geom_boxplot(aes(x = month, y = temp))

# violin
df_aq %>% 
    ggplot()+
    geom_violin(
        aes(
            x = month,
            y = temp,
            fill = month
        )
    )

# jitter
df_aq %>% 
    ggplot()+
    geom_jitter(
        aes(
            x = month,
            y = temp,
            color = month
        ),
        width = .2
    )

df_aq %>% 
    ggplot()+
    geom_boxplot(aes(x = month, y = temp, fill = month),alpha=.5) +
    geom_jitter(
        aes(
            x = month,
            y = temp,
            color = month
        ),
        width = .2
    ) + 
    coord_flip()
# combine boxplot and jitter


# ROTATE THE DAMN PLOT
# https://twitter.com/ikashnitsky/status/1379398990266048512
# https://twitter.com/RotatePlot


# label lines hack --------------------------------------------------------

# https://twitter.com/ikashnitsky/status/1045428469801385987

