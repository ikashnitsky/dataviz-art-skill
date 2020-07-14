#===============================================================================
# 2020-07-14 -- MPIDR dataviz
# Dataviz challenge -- Altmetric top-100 2019
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================

# Altmetric is a company that tracks the media attention of the academic output. Each year they publish the list of top-100 noticed papers. 
# https://www.altmetric.com/top100/home/
# You challenge is to find an interesting way to represent (part of) the dataset. 
# Hint: try to find a story in the dataset.  

# Citation of the dataset:
# Engineering, Altmetric (2019): 2019 Altmetric Top 100 - dataset. Altmetric. Dataset. https://doi.org/10.6084/m9.figshare.11371860.v3

# SUBMIT your result via Google form before 2020-07-15 23:59 CET (end day 3)
# Please, name your plot with your surname -- eg "KASHNITSKY.png"
# Note: you need a Google account to upload files in the form
# https://bit.ly/dv-mpidr-alt


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
  

