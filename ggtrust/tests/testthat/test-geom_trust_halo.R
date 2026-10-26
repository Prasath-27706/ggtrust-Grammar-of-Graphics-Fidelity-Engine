test_that("geom_trust_halo builds without error", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = seq(0, 1, length.out = 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_halo()
  expect_s3_class(p, "gg")
  b <- ggplot2::ggplot_build(p)
  expect_length(b$plot$layers, 1)
})

test_that("geom_trust_halo renders to grob without error", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = seq(0, 1, length.out = 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_halo()
  png("/tmp/test_halo_build.png", width = 4, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_halo works without reliability aesthetic", {
  d <- data.frame(x = 1:5, y = 1:5)
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    geom_trust_halo()
  expect_s3_class(p, "gg")
  png("/tmp/test_halo_norel.png", width = 4, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_halo respects custom params", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = rep(0.5, 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_halo(max_radius = 0.05, n_layers = 5, base_intensity = 0.5)
  png("/tmp/test_halo_custom.png", width = 4, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_halo parameters are recognized by layer", {
  d <- data.frame(x = 1:5, y = 1:5, reliability = rep(0.5, 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_halo(max_radius = 0.05)
  l <- p$layers[[1]]
  expect_true("max_radius" %in% names(l$geom_params))
  expect_equal(l$geom_params$max_radius, 0.05)
})

test_that("geom_trust_halo draw_key is defined", {
  expect_true(is.function(GeomTrustHalo$draw_key))
})
