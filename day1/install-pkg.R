# install packages

# First, install {pak} to deal easier with other packages
# solution by Sacha Epskamp from: https://stackoverflow.com/a/9341833/4638884
if (!require('pak', character.only = TRUE)) {
    install.packages('pak', dep = TRUE)
    if (!require('pak', character.only = TRUE))
        stop("Package not found")
}

c(
    # main data management
    "tidyverse",
    "janitor",
    "magrittr",
    "readxl",
    "rio",
    "xray",
    "gsheet",
    # dataviz
    "ggthemes",
    "ggdark",
    "paletteer",
    "hrbrthemes",
    "patchwork",
    "cowplot",
    "ggridges",
    "ggforce",
    "ggfortify",
    "ggdark",
    "ggalt",
    "geofacet",
    "ggtern",
    "tricolore",
    "biscale",
    "plotly",
    "shiny",
    "esquisse",
    # data
    "eurostat",
    "tidycensus",
    "wpp2015",
    "wpp2019",
    "gapminder",
    # fonts
    "sysfonts",
    "extrafont",
    "showtext",
    # animation
    "gganimate",
    "transformr",
    "gifski",
    # rspatial
    "sf",
    "geodata",
    "rmapshaper",
    "leaflet",
    "tidygeocoder"
) |> 
    pak::pak()


# last preparatory step
# create the "out" directory to export outputs
fs::dir_create("out")


# additional packages from github -----------------------------------------

c(
    # from github
    "PPgp/wpp2022",
    "ikashnitsky/sjrdata",
    "walkerke/mapgl"
) |> 
    pak::pak()
