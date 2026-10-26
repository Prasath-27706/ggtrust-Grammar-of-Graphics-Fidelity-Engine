test_that("scale_reliability_continuous creates a ggproto scale", {
  s <- scale_reliability_continuous()
  expect_s3_class(s, "Scale")
})

test_that("scale_reliability_binned creates a ggproto scale", {
  s <- scale_reliability_binned()
  expect_s3_class(s, "Scale")
})

test_that("theme_trust returns a theme", {
  th <- theme_trust()
  expect_s3_class(th, "theme")
})

test_that("trust_defaults are accessible", {
  expect_true(is.numeric(trust_default("halo.max_radius")))
  expect_true(is.integer(trust_default("halo.n_layers")))
  expect_true(is.character(trust_default("landscape.smoothing")))
})

test_that("set_trust_default overrides value", {
  old <- set_trust_default("halo.max_radius", 0.05)
  expect_equal(trust_default("halo.max_radius"), 0.05)
  set_trust_default("halo.max_radius", old)
  expect_equal(trust_default("halo.max_radius"), 0.02)
})

test_that("set_trust_default errors on unknown key", {
  expect_error(set_trust_default("unknown_key", 1), "Unknown trust default")
})

test_that("guide_reliability is a guide", {
  g <- guide_reliability()
  expect_s3_class(g, "Guide")
})
