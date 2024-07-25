#===============================================================================
# 2024-07-17 -- BSSD dataviz
# Population pyramid -- animate
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# animation ---------------------------------------------------------------

# the power of moving charts
# https://twitter.com/jburnmurdoch/status/1107552367795412992?lang=en

# https://www.ft.com/video/83703ffe-cd5c-4591-9b4f-a3c087aa6d19

# the social effect of a revolutionary idea
# https://socialblade.com/twitter/user/jburnmurdoch

# revealing the story
# twitter.com/mikeleeco/status/876792944396730368


library(tidyverse)
library(gganimate)


# line / path
df_aq <- airquality |>
    janitor::clean_names() |>
    mutate(
        date = paste(day, month, "1973", sep = "-") |>  lubridate::dmy(),
        month = month |> factor()
    )

p <- ggplot(df_aq, aes(x = date, y = temp)) +
    geom_line()

ani <- p +
    geom_point() +
    transition_reveal(date) +
    ease_aes("cubic-in-out")


animate(
    ani,
    nframes = nrow(df_aq) * 2,
    width = 500,
    height = 400,
    res = 96,
    start_pause = 3,
    end_pause = 10
)

anim_save("out/test-anim.gif")
