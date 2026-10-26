#' ggtrust Rendering Benchmarks
#'
#' Measures rendering time for halo and landscape encodings across different
#' point counts using microbenchmark.
#'
#' Output: `benchmarks/rendering_results.csv`

library(ggtrust)
library(ggplot2)
library(microbenchmark)

set.seed(42)

# --- Configuration ----------------------------------------------------------
point_counts <- c(50, 100, 200, 500, 1000, 2000)
n_reps <- 10  # iterations per microbenchmark

# --- Generate test datasets -------------------------------------------------
generate_data <- function(n) {
  data.frame(
    x = rnorm(n),
    y = rnorm(n),
    reliability = runif(n)
  )
}

generate_original <- function(n, p = 10) {
  matrix(rnorm(n * p), ncol = p)
}

# --- Run benchmarks ---------------------------------------------------------
results <- list()

cat("Running ggtrust rendering benchmarks...\n")
cat("Point counts:", paste(point_counts, collapse = ", "), "\n")
cat("Iterations per test:", n_reps, "\n\n")

for (n in point_counts) {
  cat(sprintf("--- n = %d ---\n", n))

  d <- generate_data(n)

  # 1. Halo
  cat("  Halo... ")
  p_halo <- ggplot(d, aes(x, y, reliability = reliability)) +
    geom_trust_halo() + theme_trust() + scale_reliability_continuous()
  bm <- microbenchmark(print(p_halo), times = n_reps, unit = "s")
  med <- as.numeric(median(bm$time)) / 1e9
  cat(sprintf("%.4fs\n", med))
  results <- c(results, list(data.frame(
    encoding = "halo", n = n, stat = "no",
    median_s = med, mean_s = mean(as.numeric(bm$time) / 1e9),
    sd_s = sd(as.numeric(bm$time) / 1e9)
  )))

  # 2. Landscape (skip small n, GAM needs >= 20 points)
  if (n >= 100) {
    cat("  Landscape... ")
    p_land <- ggplot(d, aes(x, y, reliability = reliability)) +
      geom_trust_landscape() + theme_trust() + scale_reliability_continuous()
    bm <- microbenchmark(print(p_land), times = n_reps, unit = "s")
    med <- as.numeric(median(bm$time)) / 1e9
    cat(sprintf("%.4fs\n", med))
    results <- c(results, list(data.frame(
      encoding = "landscape", n = n, stat = "no",
      median_s = med, mean_s = mean(as.numeric(bm$time) / 1e9),
      sd_s = sd(as.numeric(bm$time) / 1e9)
    )))
  }

  # 3. Dispatcher (auto)
  cat("  Dispatcher... ")
  p_auto <- ggplot(d, aes(x, y, reliability = reliability)) +
    geom_trust_point() + theme_trust() + scale_reliability_continuous()
  bm <- microbenchmark(print(p_auto), times = n_reps, unit = "s")
  med <- as.numeric(median(bm$time)) / 1e9
  cat(sprintf("%.4fs\n", med))
  results <- c(results, list(data.frame(
    encoding = "auto", n = n, stat = "no",
    median_s = med, mean_s = mean(as.numeric(bm$time) / 1e9),
    sd_s = sd(as.numeric(bm$time) / 1e9)
  )))

  # 4. stat_trust_dr (computationally heavier)
  if (n >= 50 && n <= 2000) {
    cat("  stat_trust_dr... ")
    orig <- generate_original(n)
    dd <- data.frame(x = d$x, y = d$y)
    p_dr <- ggplot(dd, aes(x, y)) +
      stat_trust_dr(original_data = orig, k = min(10, n - 1)) +
      theme_trust() + scale_reliability_continuous()
    bm <- microbenchmark(print(p_dr), times = max(3L, n_reps %/% 2L), unit = "s")
    med <- as.numeric(median(bm$time)) / 1e9
    cat(sprintf("%.4fs\n", med))
    results <- c(results, list(data.frame(
      encoding = "stat_trust_dr", n = n, stat = "yes",
      median_s = med, mean_s = mean(as.numeric(bm$time) / 1e9),
      sd_s = sd(as.numeric(bm$time) / 1e9)
    )))
  }

  cat("\n")
}

# --- Save results -----------------------------------------------------------
results_df <- do.call(rbind, results)
write.csv(results_df, "benchmarks/rendering_results.csv", row.names = FALSE)

cat("\n=== RESULTS (median render time in seconds) ===\n")
cat(sprintf("%-15s %6s  %8s\n", "Encoding", "n", "Median(s)"))
cat(paste(rep("-", 35), collapse = ""), "\n")
for (i in seq_len(nrow(results_df))) {
  cat(sprintf("%-15s %6d  %8.4f\n",
              results_df$encoding[i], results_df$n[i], results_df$median_s[i]))
}
cat("\nResults saved to benchmarks/rendering_results.csv\n")
