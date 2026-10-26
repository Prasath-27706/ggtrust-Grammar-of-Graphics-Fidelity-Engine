test_that("compute_fidelity returns correct structure", {
  set.seed(42)
  orig <- matrix(rnorm(200), ncol = 2)
  emb <- orig + rnorm(200, sd = 0.1)
  fc <- compute_fidelity(orig, emb, k = 5)
  expect_type(fc, "list")
  expect_named(fc, c("trustworthiness", "continuity"))
  expect_length(fc$trustworthiness, 100)
  expect_length(fc$continuity, 100)
})

test_that("compute_fidelity values are in [0, 1]", {
  set.seed(42)
  orig <- matrix(rnorm(200), ncol = 2)
  emb <- orig + rnorm(200, sd = 0.1)
  fc <- compute_fidelity(orig, emb, k = 5)
  expect_true(all(fc$trustworthiness >= 0 & fc$trustworthiness <= 1))
  expect_true(all(fc$continuity >= 0 & fc$continuity <= 1))
})

test_that("compute_fidelity validates inputs", {
  expect_error(compute_fidelity(matrix(1:4, 2), matrix(1:6, 3), k = 2),
               "same number of rows")
  expect_error(compute_fidelity(matrix(1:4, 2), matrix(1:4, 2), k = 5),
               "k.*must be")
})

test_that("find_knn_brute returns correct structure", {
  x <- matrix(1:20, ncol = 2)
  knn <- find_knn_brute(x, k = 3)
  expect_type(knn, "list")
  expect_named(knn, c("index", "dist"))
  expect_equal(nrow(knn$index), 10)
  expect_equal(ncol(knn$index), 3)
  expect_equal(dim(knn$dist), dim(knn$index))
})

test_that("find_knn matches find_knn_brute for small data", {
  set.seed(1)
  x <- matrix(rnorm(100), ncol = 2)
  knn_fn <- find_knn(x, k = 5)
  knn_br <- find_knn_brute(x, k = 5)
  expect_equal(knn_fn$index, knn_br$index)
  expect_equal(knn_fn$dist, knn_br$dist, tolerance = 1e-10)
})

test_that("select_encoding dispatches by point count", {
  expect_equal(select_encoding(10), "halo")
  expect_equal(select_encoding(500), "halo")
  expect_equal(select_encoding(501), "landscape")
  expect_equal(select_encoding(5000), "landscape")
})
