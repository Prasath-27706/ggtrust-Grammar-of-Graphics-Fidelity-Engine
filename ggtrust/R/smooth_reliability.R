#' Smooth a reliability field over the 2D panel
#'
#' Fits a smooth surface `reliability ~ s(x, y)` over the data extent and
#' predicts it on a regular grid. Three methods are supported:
#'
#' * `"gam"`: thin-plate GAM from [mgcv::gam()] (default; robust to noise).
#' * `"loess"`: local polynomial regression from [stats::loess()].
#' * `"idw"`: inverse-distance weighted interpolation over the `k` nearest
#'   points (no probabilistic model, but fast and assumption-free).
#'
#' @param x,y Numeric vectors of panel coordinates.
#' @param reliability Numeric `[0, 1]` fidelity values.
#' @param grid_size Number of grid cells along each axis.
#' @param method One of `"gam"`, `"loess"`, `"idw"`.
#' @param bandwidth Smoothing bandwidth: for `loess` this is the `span`;
#'   for `idw` it is the `p` power of the distance weighting (default 2).
#' @param idw_k Number of nearest neighbors for `idw`.
#' @return List with `z` (`grid_size x grid_size` matrix, rows = increasing y),
#'   `gx`, `gy`, and `method`.
#' @export
#' @keywords internal
smooth_reliability_2d <- function(x, y, reliability, grid_size = 100L,
                                  method = c("gam", "loess", "idw"),
                                  bandwidth = NULL, idw_k = 8L) {
  method <- match.arg(method)
  n <- length(x)
  if (n < 4) {
    cli::cli_abort("Need at least 4 points to smooth a reliability surface.")
  }
  reliability <- .clamp01(reliability)

  gx <- seq(min(x), max(x), length.out = grid_size)
  gy <- seq(min(y), max(y), length.out = grid_size)

  z <-
    switch(method,
      gam   = .smooth_gam(x, y, reliability, gx, gy),
      loess = .smooth_loess(x, y, reliability, gx, gy, bandwidth),
      idw   = .smooth_idw(x, y, reliability, gx, gy, bandwidth, idw_k)
    )

  list(z = z, gx = gx, gy = gy, method = method)
}

.smooth_gam <- function(x, y, reliability, gx, gy) {
  dat <- data.frame(x = x, y = y, reliability = reliability)
  fit <- mgcv::gam(reliability ~ s(x, y, bs = "tp"), data = dat)
  gr <- expand.grid(x = gx, y = gy)
  pred <- as.numeric(stats::predict(fit, newdata = gr))
  matrix(pred, nrow = length(gy), ncol = length(gx), byrow = TRUE)
}

.smooth_loess <- function(x, y, reliability, gx, gy, bandwidth) {
  dat <- data.frame(x = x, y = y, reliability = reliability)
  span <- bandwidth %||% 0.3
  fit <- stats::loess(reliability ~ x + y, data = dat, span = span)
  gr <- expand.grid(x = gx, y = gy)
  pred <- as.numeric(stats::predict(fit, newdata = gr))
  matrix(pred, nrow = length(gy), ncol = length(gx), byrow = TRUE)
}

.smooth_idw <- function(x, y, reliability, gx, gy, bandwidth, idw_k) {
  if (!requireNamespace("FNN", quietly = TRUE)) {
    cli::cli_abort("Method = 'idw' requires the {.pkg FNN} package.")
  }
  p <- bandwidth %||% 2
  pts <- cbind(x, y)
  query <- expand.grid(x = gx, y = gy)
  nn <- FNN::get.knnx(pts, as.matrix(query), k = min(idw_k, nrow(pts)))
  d <- nn$nn.dist
  d[d < 1e-10] <- 1e-10
  w <- 1 / (d ^ p)
  idx <- nn$nn.index
  vals <- matrix(reliability[idx], nrow = nrow(query), ncol = ncol(idx))
  pred <- rowSums(vals * w) / rowSums(w)
  matrix(pred, nrow = length(gy), ncol = length(gx), byrow = TRUE)
}

#' Evaluate a reliability surface at points (internal helper)
#' @noRd
.eval_reliability <- function(surf, x, y) {
  ix <- findInterval(x, surf$gx, all.inside = TRUE)
  iy <- findInterval(y, surf$gy, all.inside = TRUE)
  surf$z[cbind(iy, ix)]
}