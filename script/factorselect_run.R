library(factorselect)

d <- read.csv("data/processed/data_log_deseasonalized.csv")
X <- as.matrix(d[setdiff(names(d), "ref.date")])
Xd <- diff(X)

methods <- c("ahn_horenstein", "bai_ng", "abc",
             "lam_yao", "onatski_2009", "onatski_2010")

for (dm in c("both", "individual", "time", "none")) {
  res <- select_factors(Xd, method = methods, kmax = 8,
                        demean = dm, standardize = TRUE)
  cat(sprintf("%-12s | %s\n", dm,
      paste(sprintf("%-15s=%d", methods, res$k), collapse = "  ")))
}
