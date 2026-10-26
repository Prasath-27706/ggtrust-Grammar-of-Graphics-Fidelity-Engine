#' Spatialization fidelity metrics
#'
#' Trustworthiness \eqn{T(k, i)} and continuity \eqn{C(k, i)} measure how well
#' the `k` nearest neighborhoods in the original (high-dimensional) space are
#' reflected in the embedding. Both are bounded on \eqn{[0, 1]} with higher
#' values meaning the point's low-dimensional position more honestly mirrors
#' its original neighborhood.
#'
#' Implementations follow the definitions of Venna & Kaski (2006):
#'
#' \deqn{T(k, i) = 1 - \frac{2}{k(2N-3k-1)}\sum_{j \in \mathcal{N}^k_i}
#' \max(0, (r(i, j) - k))}{
#' T(k,i) = 1 - 2/(k(2N-3k-1)) * sum over displaced original neighbors of (rank - k)}
#'
#' where only original-space neighbors that are *not* among the embedding's `k`
#' nearest contribute (their embedding rank `r(i, j) > k`). Continuity
#' \eqn{C(k, i)} symmetrically penalizes embedding neighbors that are not
#' original neighbors.
#'
#' @param original_data Numeric matrix or data.frame of the original
#'   (feature) space, rows = points.
#' @param embedding Numeric matrix or data.frame of the projected positions
#'   (2 columns expected for scatterplot use, though any dimension works).
#' @param k Neighborhood size.
#' @return List with numeric vectors `trustworthiness` and `continuity`, each of
#'   length `nrow(original_data)`.
#' @export
#' @examples
#' set.seed(42)
#' x <- matrix(rnorm(200), ncol = 2)
#' e <- x[, 1:2] + rnorm(200, sd = 0.1)
#' compute_fidelity(x, e, k = 5)
compute_fidelity <- function(original_data, embedding, k = 10) {
  orig <- as.matrix(original_data)
  emb <- as.matrix(embedding)
  n <- nrow(orig)
  if (n != nrow(emb)) {
    cli::cli_abort("`original_data` and `embedding` must have the same number of rows.")
  }
  if (!is.numeric(k) || length(k) != 1 || k < 1 || k >= n) {
    cli::cli_abort("`k` must be a single integer with 1 <= k < nrow(original_data).")
  }
  k <- as.integer(k)

  T <- numeric(n)
  C <- numeric(n)
  denom <- k * (2 * n - 3 * k - 1)

  for (i in seq_len(n)) {
    do <- .row_dist(orig, i)
    de <- .row_dist(emb, i)
    ord_o <- order(do)
    ord_e <- order(de)

    # rank lookup vectors
    inv_o <- integer(n); inv_o[ord_o] <- seq_len(n)
    inv_e <- integer(n); inv_e[ord_e] <- seq_len(n)

    set_o <- ord_o[seq_len(k)]
    set_e <- ord_e[seq_len(k)]

    jT <- setdiff(set_o, set_e)
    T[i] <- 1 - (2 / denom) * sum(inv_e[jT] - k)

    jC <- setdiff(set_e, set_o)
    C[i] <- 1 - (2 / denom) * sum(inv_o[jC] - k)
  }

  list(trustworthiness = .clamp01(T), continuity = .clamp01(C))
}

#' Find k nearest neighbors
#'
#' Column-ordered index and distance matrices for the `k` nearest neighbors of
#' each row of `x` (self excluded). Uses [FNN::get.knn()] when available and
#' falls back to a brute-force distance matrix otherwise.
#'
#' @param x Numeric matrix.
#' @param k Number of neighbors.
#' @return List with `index` (`n x k` integer matrix) and `dist` (`n x k`).
#' @export
find_knn <- function(x, k = 10) {
  x <- as.matrix(x)
  n <- nrow(x)
  k <- min(as.integer(k), n - 1)
  if (k < 1) {
    cli::cli_abort("`k` must be at least 1 (and less than nrow(x)).")
  }

  if (requireNamespace("FNN", quietly = TRUE)) {
    nn <- FNN::get.knn(x, k = k + 1)          # extra column to absorb self
    idx <- nn$nn.index
    dst <- nn$nn.dist
    out_i <- matrix(NA_integer_, n, k)
    out_d <- matrix(NA_real_, n, k)
    for (i in seq_len(n)) {
      keep <- idx[i, ] != i & is.finite(dst[i, ])
      keep <- which(keep)[seq_len(k)]
      out_i[i, ] <- idx[i, keep]
      out_d[i, ] <- dst[i, keep]
    }
    if (anyNA(out_i)) {
      # self was not present (or ties); fill from brute force for the gaps
      return(find_knn_brute(x, k))
    }
    return(list(index = out_i, dist = out_d))
  }

  find_knn_brute(x, k)
}

#' Brute-force k nearest neighbors (fallback / reference implementation)
#' @param x Numeric matrix.
#' @param k Number of neighbors.
#' @return List with `index` and `dist`.
#' @export
#' @keywords internal
find_knn_brute <- function(x, k = 10) {
  x <- as.matrix(x)
  n <- nrow(x)
  k <- as.integer(k)
  out_i <- matrix(NA_integer_, n, k)
  out_d <- matrix(NA_real_, n, k)
  for (i in seq_len(n)) {
    d <- .row_dist(x, i)
    o <- order(d)
    out_i[i, ] <- o[seq_len(k)]
    out_d[i, ] <- d[o[seq_len(k)]]
  }
  list(index = out_i, dist = out_d)
}

# -- internals --------------------------------------------------------------

#' Squared distances from row i to every row of x (self set to +Inf)
#' @noRd
.row_dist <- function(x, i) {
  d <- sqrt(rowSums((sweep(x, 2, x[i, ], "-")) ^ 2))
  d[i] <- Inf
  d
}

#' Clamp to [0, 1]
#' @noRd
.clamp01 <- function(x) pmin(pmax(x, 0), 1)