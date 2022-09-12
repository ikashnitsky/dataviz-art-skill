#===============================================================================
# 2022-09-13 -- LCDS dataviz
# Arranging and saving ggplots
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# load the packages
library(tidyverse)

# let's re-create a simple plot
airquality %>%
  janitor::clean_names() %>%
  mutate(
    date = paste(day, month, "1973", sep = "-") %>%  lubridate::dmy(),
    month = month %>% factor
  ) %>% 
  ggplot(aes(x = date, y = temp, color = month)) +
  geom_line()

# and save it in an object
p <- last_plot()


# patchwork ---------------------------------------------------------------

library(patchwork)

p + p + plot_layout(guides = "collect")


# cowplot -----------------------------------------------------------------

library(cowplot)

ggdraw()


# saving options ----------------------------------------------------------

