#' Select the fidelity encoding by point count
#'
#' Per-point halos overplot above the halos' max radius threshold; above that,
#' the aggregated landscape is the better mark. The default threshold (500) is
#' tunable via `set_trust_default("selection.halo_max", ...)`.
#'
#' @param n Number of points.
#' @param halo_max Points at or below this count map to `"halo"`.
#' @return `"halo"` or `"landscape"`.
#' @export
#' @examples
#' select_encoding(100)   # "halo"
#' select_encoding(5000)  # "landscape"
select_encoding <- function(n, halo_max = trust_default("selection.halo_max")) {
  if (n <= as.integer(halo_max)) "halo" else "landscape"
}

#' @rdname select_encoding
#' @export
encoding_name <- function(encoding) {
  encoding <- match.arg(encoding, c("auto", "halo", "landscape"))
  encoding
}