# Crime, population density and Trump support in Oregon counties

Taggert W. Olson · POLS 337 · Cal Poly San Luis Obispo · Winter 2025

Across Oregon’s 36 counties, logged crime had a negative association with Trump votes per 100 residents. That association weakened after adding population density. The recovered 2025 county assignments and source variables reproduce all three models in the submitted paper.

## Run the analysis

From the repository root, run `Rscript --vanilla run_all.R` with base R. The pipeline aggregates agency records, joins county variables, fits three nested OLS models, and writes ordinary and HC1 standard errors, model summaries, diagnostic plots and an interaction plot to `output/`.

| Model | Reproduced estimate | R² |
| --- | --- | --- |
| Crime alone | Logged crime −2.753 (ordinary p = 0.00370) | 0.222 |
| Crime and density | Logged crime −0.461 (p = 0.519), logged density −3.985 (p = 4.41 × 10⁻⁷) | 0.645 |
| Crime × density and income | Interaction −1.120 (ordinary p = 0.0548, HC1 p = 0.00448) | 0.686 |

The primary outcome uses the 2020 resident population as its denominator. The second set of models uses the total votes cast series from the earlier repository. The original script’s coverage convention assigns zero offenses to Wheeler County, which had no assigned reporting rows. That choice affects its logged rate.

[Paper and original figures](paper/paper.md) · [Data sources](data/README.md) · [Full regression results](output/model_results.csv)
