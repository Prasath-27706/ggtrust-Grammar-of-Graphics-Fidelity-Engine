#' Manual reliability stat
#'
#' Pass-through stat that validates an externally computed `reliability`
#' aesthetic. Useful when fidelity was computed outside ggtrust (e.g. from a
#' different library) and merely needs to be presented through the trust geoms.
#'
#' @inheritParams ggplot2::stat_identity
#' @param geom Which trust geom to draw; `"trust_point"` by default.
#' @return A `Layer` object.
#' @export
#' @examples
#' d <- data.frame(x = 1:6, rel = c(.9, .7, .5, .3, .2, .05))
#' p <- ggplot2::ggplot(d, ggplot2::aes(x, x, reliability = rel)) +
#'   stat_trust_manual()
stat_trust_manual <- function(mapping = NULL, data = NULL,
                              geom = "trust_point",
                              na.rm = FALSE,
                              show.legend = NA,
                              inherit.aes = TRUE,
                              ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatTrustManual,
    geom = geom,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' @rdname stat_trust_manual
#' @format NULL
#' @usage NULL
#' @export
StatTrustManual <- ggplot2::ggproto(
  "StatTrustManual", ggplot2::Stat,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  compute_group = function(data, scales, ...) {
    if (is.null(data$reliability)) {
      cli::cli_abort(
        "stat_trust_manual() requires a {.field reliability} aesthetic."
      )
    }
    if (anyNA(data$reliability)) {
      cli::cli_warn("{sum(is.na(data$reliability))} missing reliability value(s) removed.")
      data <- data[!is.na(data$reliability), , drop = FALSE]
    }
    data$reliability <- .clamp01(data$reliability)
    data
  }
)