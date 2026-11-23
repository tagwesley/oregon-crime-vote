# Clean and merge four county-level sources for Oregon's 36 counties.
# Place the raw files in data/raw/ (see README for where each comes from).
suppressPackageStartupMessages({library(readxl); library(dplyr); library(tidyr)})

std_county <- function(x) toupper(trimws(gsub(" County$", "", x, ignore.case = TRUE)))

# 1. Crime: FBI NIBRS 2023 offenses by reporting agency -> total offenses per county
crime <- read_excel("data/raw/crime_2023.xlsx") |>
  rename(county = County, offenses = `Total Offenses`) |>
  filter(!is.na(county)) |>
  mutate(county = std_county(county)) |>
  group_by(county) |>
  summarise(offenses = sum(offenses, na.rm = TRUE), .groups = "drop")

# 2. Election: Oregon Secretary of State 2024 official results by county
votes <- read_excel("data/raw/election_2024.xlsx") |>
  rename(county = County, trump_votes = Trump, total_votes = `Total Votes`) |>
  mutate(county = std_county(county))

# 3. Census 2020: population and population density
census <- read_excel("data/raw/census_2020.xlsx") |>
  select(county = County, POP20, POPDENS20) |>
  mutate(county = std_county(county))

# 4. Income: per capita income by county
income <- read_excel("data/raw/income.xlsx") |>
  select(county = County, income = `Income in Dollars`) |>
  mutate(county = std_county(county))

df <- crime |>
  inner_join(votes,  by = "county") |>
  inner_join(census, by = "county") |>
  inner_join(income, by = "county") |>
  mutate(
    crime_per_100k   = offenses / POP20 * 1e5,
    # Original paper: Trump votes per 100 residents.
    trump_per_100pop = trump_votes / POP20 * 100,
    # Added in the 2026 rebuild: the conventional measure, share of votes cast.
    trump_share      = trump_votes / total_votes * 100,
    log_crime        = log(crime_per_100k + 1),
    log_density      = log(POPDENS20)
  )

# Data-quality checks
stopifnot(nrow(df) == 36, !anyDuplicated(df$county), all(df$POP20 > 0))
saveRDS(df, "output/oregon_counties.rds")
cat("Merged", nrow(df), "counties\n")
