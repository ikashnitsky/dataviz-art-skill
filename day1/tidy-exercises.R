#===============================================================================
# 2020-07-13 -- MPIDR dataviz
# Tidy exercises
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================


# load the package
library(tidyverse)


# Read the data with readxl -----------------------------------------------

library(readxl)

# see the names of the sheets
readxl::excel_sheets('data/data-denmark.xlsx')

deaths <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'deaths')
pop <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'pop')


# Ex 1. deaths dataframe --------------------------------------------------

# - subset only total number of deaths among men in year 2003 (filter)
# Q: which region had the largest number of deaths?



# Ex 2. pop dataframe -----------------------------------------------------

# - subset only the year 2004
# - transform to wide format using the column "sex" (pivot_wider)
# - get rid of the column for both sex
# - calculate the sex ratio (males to females)
# Q: in which region the SR is highest at ages 15, 45, over75 (coded as "open")



# Ex 3. joined dataframe --------------------------------------------------

# - join the two dataframes (left_join OR inner_join)
# - calculate age specific death ratios
# - subset only the ages 15-59 and year 2001
# Q: what is the average ratio of male ASDR to female ASDR in each region? 
# Tip: use summarize



# Ex 4. joined dataframe (df) ---------------------------------------------

# - subset only both sex
# - transform to wide format using the column "year" (pivot_wider)
# - calculate the growth of ASDR between 2005 and 2001
# Q: in which region the average growth/decrease in ASDR was largest?

