# Data provenance

| File | What it is | Source | Status |
|---|---|---|---|
| crime_2023_by_agency.csv | 2023 offenses by reporting agency (cities, universities, sheriff/county and state-police rows, tribal agencies) | Oregon State Police "Offense Type by Agency, 2023" workbook | CSV conversion of the workbook's non-zero rows (about two dozen all-zero "Other" agency rows omitted); agencies are NOT mapped to counties |
| election_2024.csv | 2024 presidential votes by county (Trump, Harris, total) | Wikipedia county results table, retrieved Nov 2026 | Re-collected; verify against certified results before citing |
| county_population_area.csv | County population and total area | Wikipedia list of Oregon counties, retrieved Nov 2026 | Census year and land-vs-total area not confirmed by the source; verify before citing |

## Known gaps (not yet recoverable)
- The original merged 36-county analysis file and the original raw census/income workbooks were not found, so median income is not included and the models in R/02_models.R cannot yet be run end-to-end on real data.
- County-level crime rates require an agency-to-county crosswalk, which the OSP workbook does not provide; none has been guessed.
