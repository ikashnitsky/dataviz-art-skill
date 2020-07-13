# install packages

# First, install pacman to deal easier with other packages
# solution by Sacha Epskamp from: http://stackoverflow.com/a/9341833/4638884
if (!require('pacman', character.only = TRUE)) {
  install.packages('pacman', dep = TRUE)
  if (!require('pacman', character.only = TRUE))
    stop("Package not found")
}

pacman::p_load(
  install = T, # this will install all the packages we don't have
  update = F,  # we ask not to update the packages
  # main data management
  tidyverse,
  janitor,
  magrittr,
  lubridate,
  readxl,
  rio,
  # dataviz
  ggthemes,
  ggdark,
  paletteer,
  hrbrthemes,
  patchwork,
  cowplot,
  ggridges,
  ggforce,
  ggalt,
  geofacet,
  ggtern,
  tricolore,
  gganimate,
  plotly,
  shiny,
  # data
  eurostat,
  tidycensus,
  wpp2015,
  rtweet,
  gapminder,
  # rspatial
  sf,
  rmapshaper,
  leaflet
)

