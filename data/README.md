# Oregon input data

| File | Role |
| --- | --- |
| `agency_assignments_2025.csv` | Author’s 2025 agency-to-county coding and reported offense totals from the Oregon 2023 offense-by-agency workbook. The unassigned section label is excluded. |
| `county_inputs_2025.csv` | Original 36 county records. Includes 2020 population and density, 2024 Trump vote counts, and per-capita personal income from the 2023 column of `lapi1124.xlsx`. |
| `election_2024.csv` | The earlier repository’s re-collected county election totals. The primary model uses original Trump counts. The additional vote-share model uses this series for total votes cast. Its denominator has not been independently checked against certified returns. |
| `crime_2023_by_agency.csv`, `county_population_area.csv` | Earlier reference extracts. The replication uses the archived assignments and census variables above. |

The county assignments follow the author’s original decisions, including first matches for agencies spanning county lines. Wheeler had no assigned reports. To reproduce the paper, the analysis gives it a zero offense count and replaces its infinite log value with 0.001 after taking the logarithm.
