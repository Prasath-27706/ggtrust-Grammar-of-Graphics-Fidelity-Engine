test_that("select_encoding returns correct values", {
  expect_equal(select_encoding(1), "halo")
  expect_equal(select_encoding(100), "halo")
  expect_equal(select_encoding(500), "halo")
  expect_equal(select_encoding(501), "landscape")
  expect_equal(select_encoding(10000), "landscape")
})

test_that("select_encoding respects custom halo_max", {
  expect_equal(select_encoding(10, halo_max = 20), "halo")
  expect_equal(select_encoding(21, halo_max = 20), "landscape")
})

test_that("geom_trust_point dispatches to halo", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = rep(0.5, 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_point(encoding = "halo")
  png("/tmp/test_point_halo.png", width = 4, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_point dispatches to landscape", {
  d <- data.frame(x = rnorm(600), y = rnorm(600), reliability = runif(600))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_point(encoding = "landscape")
  png("/tmp/test_point_landscape.png", width = 5, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_point auto dispatches by count", {
  d_small <- data.frame(x = 1:10, y = 1:10, reliability = runif(10))
  p <- ggplot2::ggplot(d_small, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_point()
  b <- ggplot2::ggplot_build(p)
  expect_length(b$plot$layers, 1)
  png("/tmp/test_point_auto_small.png", width = 4, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_point encoding parameter is recognized", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = rep(0.5, 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_point(encoding = "halo")
  l <- p$layers[[1]]
  expect_equal(l$geom_params$encoding, "halo")
})
