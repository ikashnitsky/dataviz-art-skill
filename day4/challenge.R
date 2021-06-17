#===============================================================================
# 2021-06-17 -- MPIDR dataviz
# Dataviz challenge
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# The final assignment of the course is to produce a creative dataviz -- however you like. You are free to re-use any part of the code that we covered in the course or explore the solutions available out there in the wild (eg #TidyTuesday). The only limitation is the dataset that I provide. 

# You have 2 options to choose from:
# 1. Map of a European country.
# 2. Altmetric top-100 2019 dataset

# Link to submit
# https://docs.google.com/forms/d/e/1FAIpQLScdazyabbE1xKWoSHjlfoq-iHVV4qBAcsazvBiKndIlpraYQQ/viewform


# 1. MAP ------------------------------------------------------------------

# Choose any European country and create a choropleth map of it's regions using any Eurostat indicator

# http://ec.europa.eu/eurostat/web/regions/data/database


# 2. ALTMETRIC ------------------------------------------------------------

# Altmetric is a company that tracks the media attention of the academic output. Each year they publish the list of top-100 noticed papers. 
# https://www.altmetric.com/top100/home/
# You challenge is to find an interesting way to represent (part of) the dataset. 
# Hint: try to find a story in the dataset.  

# Citation of the dataset:
# Engineering, Altmetric (2019): 2019 Altmetric Top 100 - dataset. Altmetric. Dataset. https://doi.org/10.6084/m9.figshare.11371860.v3


library(tidyverse)

data_url <- "https://altmetric.figshare.com/ndownloader/files/20282124"

download.file(data_url, destfile = "data/altmetric-top-100.xlsx")

alt <- readxl::read_excel("data/altmetric-top-100.xlsx") %>% 
  janitor::clean_names() # column names to lowercase


# quick one -- to start with something

library(lubridate)

alt %>% 
  mutate(month = publication_date %>% month) %>% 
  ggplot(aes(altmetric_attention_score, twitter_mentions))+
  geom_point(aes(color = month))+
  scale_color_fermenter(palette = "YlOrRd")+
  scale_x_log10()+
  scale_y_log10()
