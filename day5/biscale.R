#===============================================================================
# 2021-06-18 -- twitter
# Visualize Publons country data
# https://publons.com/country
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

library(tidyverse)
library(magrittr)
library(sf)
library(spData)
library(rmapshaper)
library(countrycode)
library(ggdark)
library(hrbrthemes)
library(showtext)
library(cowplot)

# manually exported data (on 2021-01-07) deposited as a gist
data_url <- "https://gist.githubusercontent.com/ikashnitsky/90483ee3c3c230aa874dffb856d6074b/raw/65173975b0edcaa2f2da38e1e3f4e92e17f62158/publons.txt"

foo <- read_lines(data_url) %>% 
    matrix(ncol = 7, byrow = T) %>% 
    as_tibble() %>% 
    set_colnames(c("rank", "country", "researchers", "top_rev", "verified_rev", "verified_rev_12m", "verified_editor_rec")) %>% 
    # numerical colums to numeric format
    mutate_at(3:7, {function(x) x %>% str_remove_all(",") %>% as.numeric}) %>%
    # add ISO codes
    mutate(code = country %>% countryname(destination = "iso2c"))
    

df <- foo %>% 
    mutate(
        rev_per_res = verified_rev / researchers,
        rev_per_res_12m = verified_rev_12m / researchers,
    )

df %>% 
    filter(researchers %>% is_weakly_greater_than(10)) %>% 
    ggplot(aes(rev_per_res, rev_per_res_12m))+
    geom_point()


# get world map outline (you might need to install the package)
world_outline <- spData::world %>% 
    st_as_sf()

# let's use a fancy projection
world_outline_robinson <- world_outline %>% 
    st_transform(crs = "ESRI:54030")

# produce borders layer
country_borders <- world_outline_robinson %>% 
    rmapshaper::ms_innerlines()

# merge the data and borders
df_map <- world_outline_robinson %>% 
    left_join(df, by = c("iso_a2" = "code")) %>% 
    filter(researchers %>% is_weakly_greater_than(10)) 

# map!
df_map %>% 
    ggplot()+
    geom_sf(aes(fill = rev_per_res_12m), color = NA)+
    geom_sf(data = country_borders, size = .1, color = "#ffffff")+
    scale_fill_viridis_b(option = "B", breaks = c(.5, 1, 1.5, 2))+
    dark_theme_minimal(base_family = font_rc)+
    theme(
        axis.text = element_blank(),
        plot.background = element_rect(fill = "#000000", color = NA),
        legend.position = c(.15, .4)
    )+
    labs(
        title = "Verified Publons reviews per researcher, last 12 months [2021-01-07]",
        caption = "Data: https://publons.com/country | Design: @ikashnitsky",
        fill = NULL
    )



# try biscale map ---------------------------------------------------------

library(biscale)

df_bi <- df %>% 
    filter(researchers %>% is_weakly_greater_than(10)) %>% 
    select(iso_a2 = code, researchers, rev_per_res_12m) %>% 
    drop_na() %>% # needed for categorizing in 9 classes
    bi_class(
        x = researchers, y = rev_per_res_12m, 
        style = "quantile", dim = 3
    )

df_bi_map <- world_outline_robinson %>% 
    left_join(df_bi, by = "iso_a2") %>% 
    filter(researchers %>% is_weakly_greater_than(10)) 


map <- ggplot(df_bi_map) +
    geom_sf(
        data = world_outline_robinson %>% 
            filter(!iso_a2 == "AQ"), # remove Antarctica
        fill = "#FFFFFF", color = NA
    )+ # for missing countries
    geom_sf(
        mapping = aes(fill = bi_class), 
        color = "white", size = 0.1, show.legend = FALSE
    ) +
    bi_scale_fill(pal = "GrPink", dim = 3) +
    labs(
        title = "Verified Publons reviews per researcher, last 12 months [2021-01-07]",
        caption = "Data: https://publons.com/country | Design: @ikashnitsky"
    ) +
    theme_minimal(base_family = font_rc)+
    theme(
        axis.text = element_blank(),
        legend.position = c(.15, .4)
    )

legend <- bi_legend(
    pal = "GrPink",
    dim = 3,
    xlab = "# of Researchers ",
    ylab = "Reviews per\nResearcher ",
    size = 8
)+
    theme_minimal(base_family = font_rc)+
    theme(
        plot.background = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()
    )

(out <- ggdraw(map) +
    draw_plot(legend, -.02, .15, 0.35, 0.35))

ggsave("out/map-publons-bi.png", out, width = 7, height = 4)  


# proportion of top reviewers --------------------------------------------

df_map %>% 
    filter(top_rev %>% is_weakly_greater_than(10)) %>% 
    mutate(prop_top = top_rev / researchers *100) %>% 
    ggplot()+
    geom_sf(
        data = world_outline_robinson %>% 
            filter(!iso_a2 == "AQ"), # remove Antarctica
        fill = "#000000", color = NA
    )+ # for missing countries
    geom_sf(aes(fill = prop_top), color = NA)+
    geom_sf(data = country_borders, size = .1, color = "#ffffff")+
    scale_fill_viridis_b(option = "B", breaks = 1:5, begin = .2)+
    dark_theme_minimal(base_family = font_rc)+
    theme(
        axis.text = element_blank(),
        plot.background = element_rect(fill = "#121212", color = NA),
        legend.position = c(.1, .4)
    )+
    labs(
        title = "Proportion of Researchers recognised as Publons Top Reviewers",
        caption = "Data: https://publons.com/country | Design: @ikashnitsky",
        fill = "%"
    )



# researchers per population --------------------------------------------

library(wpp2019)
data(pop)

pop20 <- pop %>% 
    select(name, `2020`) %>% 
    mutate(
        iso_a2 = name %>% countryname(destination = "iso2c"),
        pop20 = `2020` * 1e3
    )

df_map %>% 
    left_join(pop20, "iso_a2") %>% 
    mutate(prop_res = researchers *1e2 / pop20) %>% 
    ggplot()+
    geom_sf(
        data = world_outline_robinson %>% 
            filter(!iso_a2 == "AQ"), # remove Antarctica
        fill = "#000000", color = NA
    )+ # for missing countries
    geom_sf(aes(fill = prop_res), color = NA)+
    geom_sf(data = country_borders, size = .1, color = "#ffffff")+
    scale_fill_viridis_b(option = "B", begin = .1, 
                         breaks = c(.05, .1, .15, .2))+
    dark_theme_minimal(base_family = font_rc)+
    theme(
        axis.text = element_blank(),
        plot.background = element_rect(fill = "#121212", color = NA),
        legend.position = c(.1, .4)
    )+
    labs(
        title = "Verified Publons Researchers as % of total country population",
        caption = "Data: https://publons.com/country; WPP2019 | Design: @ikashnitsky",
        fill = "%"
    )

