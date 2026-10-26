test_that("geom_trust_landscape builds without error", {
  d <- data.frame(x = rnorm(200), y = rnorm(200), reliability = runif(200))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_landscape()
  expect_s3_class(p, "gg")
  b <- ggplot2::ggplot_build(p)
  expect_length(b$plot$layers, 1)
})

test_that("geom_trust_landscape renders to grob without error", {
  d <- data.frame(x = rnorm(200), y = rnorm(200), reliability = runif(200))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_landscape()
  png("/tmp/test_landscape_render.png", width = 5, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_landscape uses default reliability=1 when not mapped", {
  d <- data.frame(x = rnorm(200), y = rnorm(200))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    geom_trust_landscape(contours = FALSE)
  png("/tmp/test_landscape_default.png", width = 5, height = 4, units = "in", res = 72)
  expect_no_error(print(p))
  dev.off()
})

test_that("geom_trust_landscape respects smoothing method", {
  d <- data.frame(x = rnorm(200), y = rnorm(200), reliability = runif(200))
  for (method in c("gam", "loess", "idw")) {
    p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
      geom_trust_landscape(smoothing = method)
    png(paste0("/tmp/test_landscape_", method, ".png"), width = 5, height = 4,
        units = "in", res = 72)
    expect_no_error(print(p))
    dev.off()
  }
})

test_that("geom_trust_landscape parameters are recognized by layer", {
  d <- data.frame(x = rnorm(200), y = rnorm(200), reliability = runif(200))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, reliability = reliability)) +
    geom_trust_landscape(grid_size = 50, raster_alpha = 0.3)
  l <- p$layers[[1]]
  expect_equal(l$geom_params$grid_size, 50)
  expect_equal(l$geom_params$raster_alpha, 0.3)
})
