test_that("stat_trust_dr computes reliability", {
  set.seed(42)
  x <- matrix(rnorm(200), ncol = 2)
  emb <- x + rnorm(200, sd = 0.1)
  dd <- data.frame(x = emb[, 1], y = emb[, 2])
  p <- ggplot2::ggplot(dd, ggplot2::aes(x, y)) +
    stat_trust_dr(original_data = x, k = 5)
  b <- ggplot2::ggplot_build(p)
  expect_true("reliability" %in% names(b$data[[1]]))
  expect_true(all(b$data[[1]]$reliability >= 0 & b$data[[1]]$reliability <= 1))
})

test_that("stat_trust_dr reliability is non-constant", {
  set.seed(42)
  x <- matrix(rnorm(200), ncol = 2)
  emb <- x + rnorm(200, sd = 0.1)
  dd <- data.frame(x = emb[, 1], y = emb[, 2])
  p <- ggplot2::ggplot(dd, ggplot2::aes(x, y)) +
    stat_trust_dr(original_data = x, k = 5)
  b <- ggplot2::ggplot_build(p)
  rel <- b$data[[1]]$reliability
  expect_gt(diff(range(rel)), 0)
})

test_that("stat_trust_dr aggregation options work", {
  set.seed(42)
  x <- matrix(rnorm(100), ncol = 2)
  emb <- x + rnorm(100, sd = 0.1)
  dd <- data.frame(x = emb[, 1], y = emb[, 2])
  for (agg in c("min", "prod", "avg")) {
    p <- ggplot2::ggplot(dd, ggplot2::aes(x, y)) +
      stat_trust_dr(original_data = x, k = 3, aggregation = agg)
    b <- ggplot2::ggplot_build(p)
    expect_true(all(b$data[[1]]$reliability >= 0 & b$data[[1]]$reliability <= 1))
  }
})

test_that("stat_trust_dr renders without error", {
  set.seed(42)
  x <- matrix(rnorm(200), ncol = 2)
  emb <- x + rnorm(200, sd = 0.1)
  dd <- data.frame(x = emb[, 1], y = emb[, 2])
  p <- ggplot2::ggplot(dd, ggplot2::aes(x, y)) +
    stat_trust_dr(original_data = x, k = 5)
  png("/tmp/test_stat_dr.png", width = 5, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("stat_trust_manual validates reliability", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = c(0.1, 0.5, 0.9, 0.3, 0.7))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    stat_trust_manual()
  expect_s3_class(p, "gg")
  png("/tmp/test_stat_manual.png", width = 5, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("stat_trust_manual errors without reliability", {
  d <- data.frame(x = 1:5, y = 1:5)
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    stat_trust_manual()
  expect_error(ggplot2::ggplot_build(p), "reliability")
})
