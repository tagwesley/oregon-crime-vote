# Crime, Population Density and Trump Support in Oregon Counties

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE) ![R](https://img.shields.io/badge/R-lm%20%2B%20sandwich-276DC3)

R pipeline for a POLS 337 (Data Analysis) project at Cal Poly, Winter 2025.

**Question:** How do crime rates and population density relate to Trump support across Oregon's 36 counties in 2024?

## Paper

Read the full write-up with the original figures: [paper/paper.md](paper/paper.md).

## Pipeline

1. `R/01_clean_merge.R`: reads four sources, standardizes county names, aggregates agency-level crime to counties, merges, builds per-capita and logged variables, and runs data-quality checks (36 counties, no duplicates, positive population).
2. `R/02_models.R`: three nested OLS models with HC1 robust standard errors and a ggplot2 figure.
   - Model 1: logged crime rate
   - Model 2: + logged population density
   - Model 3: + crime × density interaction and per-capita income

## Data

The `data/` folder holds the inputs that could be recovered or re-collected. See [data/README.md](data/README.md) for sources and status.

| File | Contents | Status |
| --- | --- | --- |
| `data/crime_2023_by_agency.csv` | 2023 offenses by reporting agency (Oregon State Police workbook) | original source, converted to CSV |
| `data/election_2024.csv` | 2024 presidential votes by county | re-collected from public tables; verify before citing |
| `data/county_population_area.csv` | County population and area | re-collected from public tables; verify before citing |
| median income by county | not recovered | **missing**, so Model 3 cannot be re-run yet |

## Original findings (from the submitted paper)

- Model 1: crime coefficient −2.75 (p = 0.004), R² = 0.22
- Model 2: crime effect shrinks to −0.46 (n.s.); density −3.99 (p = 0.002), R² = 0.65
- Model 3: crime × density interaction −1.12, significant with robust SEs; income n.s.; R² = 0.69

In short, the apparent crime effect is mostly an urban-density effect.

## Provenance and what changed

- The original 2025 script was not recovered. This pipeline was **rebuilt in November 2026 (with AI-assisted coding) from the methods described in the paper**. It has not yet been re-run on the original raw files, so the numbers above are the paper's, not outputs of this code.
- **Measurement fix:** the original outcome was Trump votes per 100 *residents*, not share of votes *cast*. The rebuild keeps the original and adds the conventional share-of-votes-cast as a robustness check.
- Agency-level crime has no county crosswalk in the source workbook, so county crime rates are not yet recomputed.
- Raw column names in `01_clean_merge.R` may need adjusting to match the downloaded files.

## Author

Taggert W. Olson, Cal Poly San Luis Obispo, Political Science
