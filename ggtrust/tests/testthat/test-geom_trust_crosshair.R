testthat::test_that("geom_trust_crosshair builds without error", {
  df <- data.frame(x = 1:5, y = 1:5, reliability = c(1, 0.8, 0.5, 0.3, 0))
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_crosshair(max_length = 0.04)

  b <- ggplot2::ggplot_build(p)
  testthat::expect_s3_class(b, "ggplot_built")
})

