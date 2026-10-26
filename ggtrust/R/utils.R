#' Default-or-value operator
#'
#' Returns `b` when `a` is `NULL`, empty, or `NA`, otherwise `a`.
#' @keywords internal
`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || is.na(a[1])) b else a