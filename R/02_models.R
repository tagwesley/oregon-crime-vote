df <- readRDS("output/oregon_counties.rds")
rhs <- c("log_crime", "log_crime + log_density", "log_crime * log_density + income")
fit <- function(y) lapply(rhs, function(r) lm(as.formula(paste(y, "~", r)), df, na.action = na.fail))
report <- function(models, outcome) {
  do.call(rbind, lapply(seq_along(models), function(i) {
    m <- models[[i]]
    info <- summary(m)
    score <- model.matrix(m) * residuals(m)
    bread <- info$cov.unscaled
    hc1 <- (nobs(m) / df.residual(m)) * bread %*% crossprod(score) %*% bread
    se <- sqrt(diag(hc1))
    data.frame(outcome = outcome, model = i, term = names(coef(m)), estimate = coef(m),
               se = info$coefficients[,2], p = info$coefficients[,4], hc1_se = se,
               hc1_p = 2 * pt(-abs(coef(m)/se), df.residual(m)), n = nobs(m),
               r2 = info$r.squared, row.names = NULL)
  }))
}
models <- fit("trump_per_100pop")
results <- rbind(report(models, "trump_per_100pop"), report(fit("trump_share"), "trump_share"))
write.csv(results, "output/model_results.csv", row.names = FALSE)
print(subset(results, outcome == "trump_per_100pop"), row.names = FALSE, digits = 5)
stopifnot(all(round(vapply(models, function(m) summary(m)$r.squared, 0), 3) == c(.222,.645,.686)),
          round(coef(models[[1]])["log_crime"], 3) == -2.753,
          round(coef(models[[2]])["log_density"], 3) == -3.985,
          round(coef(models[[3]])["log_crime:log_density"], 3) == -1.120)
