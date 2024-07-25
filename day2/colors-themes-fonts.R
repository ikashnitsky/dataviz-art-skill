#===============================================================================
# 2024-07-16 -- BSSD dataviz
# ggplot2 themes, colors and fonts
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)
library(magrittr)
library(ggthemes)

# colors ------------------------------------------------------------------

# Parameter "color" changes the color of lines and points
# Parameter "fill" changes the color of shapes (see the violin example)
# The way you override ggplot"s defaults is to use functions
# scale_color_[...] or scale_fill_[...] (use TAB to see options)
# I really recommend viridis colors as your daily basis
# NOTE: with viridis you need to know if you variable is continuous or categorical
# The video on viridis https://youtu.be/xAoljeRJ3lU

# colorblind friendliness
# https://www.toptal.com/designers/colorfilter?orig_uri=https://infographic.statista.com/normal/chartoftheday_13680_the_legal_status_of_abortion_worldwide_n.jpg&process_type=protan

# Recent posts by Lisa Rost on colorblind friendly dataviz
# https://blog.datawrapper.de/colorblindness-part1/
# https://blog.datawrapper.de/colorblindness-part2/


# paletteer !!!
library(paletteer)
# https://github.com/EmilHvitfeldt/r-color-palettes

# low level manipulations with color palettes
library(prismatic)
# https://github.com/EmilHvitfeldt/prismatic




# random minimal tileplot
crossing(x = LETTERS |> extract(1:4), y = 5:8) |>
    mutate(z = runif(16)) |>
    ggplot(aes(x, y, fill = z)) +
    geom_tile()

gg <- ggplot2::last_plot()

# Gender colors
# https://blog.datawrapper.de/gendercolor/
# https://twitter.com/d_alburez/status/1184120385899581440


# scale _ identity --------------------------------------------------------

# https://twitter.com/ikashnitsky/status/937786580231696384

n <- 100

tibble(x = runif(n),
       y = runif(n),
       size = runif(n, min = 4, max = 20)) |>
    ggplot(aes(x, y, size = size)) +
    geom_point(color = "white", pch = 42) +
    scale_size_identity() +
    coord_cartesian(c(0, 1), c(0, 1)) +
    theme_void() +
    theme(
        panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "black")
    )


# generate bubbles of random color and size
n <- sample(20:50, 3)

tibble(
    x = runif(n),
    y = runif(n),
    size = runif(n, min = 3, max = 20),
    color = rgb(runif(n), runif(n), runif(n))
) |>
    ggplot(aes(x, y, size = size, color = color)) +
    geom_point() +
    scale_color_identity() +
    scale_size_identity() +
    coord_cartesian(c(0, 1), c(0, 1)) +
    theme_void()



# themes ------------------------------------------------------------------

gg + theme_minimal()
gg + theme_bw()
gg + theme_light()
gg + theme_excel()    # ugly, isn"t it?
gg + theme_few()      # one of my favorites
gg + theme_economist()
gg + theme_wsj()
gg + theme_fivethirtyeight() # I love this one
gg + theme_solarized()
gg + theme_dark()
# ... feel free to test them all))

# turn all themes dark
# https://github.com/nsgrantham/ggdark
library(ggdark)

esquisse::esquisser()

# fonts -------------------------------------------------------------------

# library(extrafont)
library(hrbrthemes)
import_roboto_condensed()

gg + theme_minimal(base_family = font_rc)

library(showtext)
sysfonts::font_add_google("Roboto Condensed", "rc")
sysfonts::font_add_google("Atkinson Hyperlegible", "ah")
showtext_auto()

gg + theme_minimal(base_family = "rc")
gg + theme_minimal(base_family = "ah")


# a fancy way to reuse code chunks ----------------------------------------

# A blog post on the power of gist + devtools::source_gist()
# https://ikashnitsky.phd/2023/gist-snippet

# set ggplot2 theme
devtools::source_gist("653e1040a07364ae82b1bb312501a184")
theme_set(theme_ik())

gg


# challenge -- create as ugly themed plot as possible ---------------------

# for inspiration:
# https://twitter.com/CedScherer/status/1236056151210500096

# submit your results via the link in the main repository README:
# https://github.com/ikashnitsky/dataviz-bssd?tab=readme-ov-file#links-to-submit-in-class-assignments
