testthat::test_that("geom_trust_tether builds without error", {
  set.seed(123)
  orig <- matrix(rnorm(100), ncol = 5)
  emb <- orig[, 1:2]
  df <- data.frame(x = emb[, 1], y = emb[, 2], reliability = runif(20))

  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_tether(original_data = orig, k_tether = 2, fidelity_threshold = 0.8)

  b <- ggplot2::ggplot_build(p)
  testthat::expect_s3_class(b, "ggplot_built")
})

