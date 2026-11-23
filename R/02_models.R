# Three nested OLS models, with heteroskedasticity-robust (HC1) standard errors.
suppressPackageStartupMessages({library(sandwich); library(lmtest); library(ggplot2)})
df <- readRDS("output/oregon_counties.rds")

run <- function(y) {
  m1 <- lm(reformulate("log_crime", y), df)
  m2 <- lm(reformulate(c("log_crime", "log_density"), y), df)
  m3 <- lm(reformulate(c("log_crime * log_density", "income"), y), df)
  for (m in list(m1, m2, m3)) {
    print(coeftest(m, vcov = vcovHC(m, type = "HC1")))
    cat("R2 =", round(summary(m)$r.squared, 3), "\n\n")
  }
}
cat("== Outcome as in original paper: Trump votes per 100 residents ==\n"); run("trump_per_100pop")
cat("== Robustness: Trump share of votes cast ==\n");                         run("trump_share")

p <- ggplot(df, aes(log_crime, trump_per_100pop, colour = log_density)) +
  geom_point(size = 2.5) + geom_smooth(method = "lm", se = TRUE, colour = "grey30") +
  labs(x = "log(crimes per 100k)", y = "Trump votes per 100 residents",
       colour = "log(pop. density)", title = "Oregon counties, 2024") + theme_minimal()
ggsave("output/crime_vs_vote.png", p, width = 7, height = 5, dpi = 150)
