# Original 2025 county coding and source variables, exported without transformations.
dir.create("output", showWarnings = FALSE)
df <- read.csv("data/county_inputs_2025.csv")
ag <- read.csv("data/agency_assignments_2025.csv")
mapped <- subset(ag, !is.na(county) & nzchar(county))
stopifnot(nrow(df) == 36, !anyDuplicated(df$county), !anyNA(df), all(df$population > 0),
          all(df$density > 0), all(mapped$county %in% df$county), !anyNA(mapped$offenses))
df$agency_rows <- tabulate(match(mapped$county, df$county), nbins = nrow(df))
counts <- tapply(mapped$offenses, factor(mapped$county, levels = df$county), sum)
df$offenses <- as.numeric(counts)
df$offenses[df$agency_rows == 0] <- 0 # Historical aggregation for Wheeler.
df$crime_per_100k <- df$offenses / df$population * 100000
df$trump_per_100pop <- df$trump_votes / df$population * 100
df$log_crime <- log(df$crime_per_100k)
df$log_crime[df$offenses == 0] <- 0.001 # Original replacement AFTER applying the log.
df$log_density <- log(df$density)
votes <- read.csv("data/election_2024.csv")
i <- match(df$county, votes$county)
stopifnot(!anyNA(i), !anyDuplicated(votes$county), all(votes$trump_votes[i] == df$trump_votes),
          all(votes$total_votes[i] >= df$trump_votes), all(votes$total_votes[i] > 0))
df$trump_share <- 100 * df$trump_votes / votes$total_votes[i]
saveRDS(df, "output/oregon_counties.rds")
write.csv(df, "output/county_analysis.csv", row.names = FALSE)
