#===============================================================================
# 2024-07-19 -- BSSD dataviz
# Randomly assign countries to participants
# Randomly assign participants to teams
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================


# countries for the day4 assignment ---------------------------------------

here_we_are <- c(
    "Margherita",
    "Maartje",
    "Mar",
    "Marcial",
    "Gioia",
    "Carlos",
    "Athena",
    "Federica",
    "Anna",
    "Mariana",
    "Pawel",
    "Caroline",
    "Olga",
    "Joanna",
    "Maya"
    # "Yeda",
    # "Paola",
    # "Alessia",
    # "Kaylin",
    # "Juan"
)

# select 15 largest EU countries by the number of NUTS-3 regions
largest_eu_countries <- 
    eurostat::eurostat_geodata_60_2016 |> 
    janitor::clean_names() |> 
    filter(levl_code == 3) |> 
    mutate(cntr = nuts_id |> str_sub(1,2)) |> 
    group_by(cntr) |> 
    summarise(n_units = n()) |> 
    arrange(n_units |> desc()) |> 
    pull(cntr) |> 
    extract(1:15)


# randomly assign 
set.seed(7)

tibble(
    names,
    cntr |> sample(15)
) |> 
    view()


# assign participants to teams for the challenge --------------------------

# The online team: 
online_participants <- c(
    "Joanna",
    "Olga",
)


set.seed(719)

# In-class teams:
offline_participants <- 
    tibble(
        participant = here_we_are
    ) |> 
    # remove online participants
    filter(
        ! participant %in% online_participants
    ) |> 
    # assign teams randomly
    mutate(
        team = sample(
            LETTERS[1:3], 
            size = n(), 
            replace = T
        )
    )


offline_participants %>% view()