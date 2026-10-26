#' Trust theme defaults
#'
#' Central registry of all tunable defaults for the trust geoms, scales and
#' guides. Values are read via `trust_default("halo.max_radius")` etc. and can
#' be overridden globally with [set_trust_default()].
#'
#' @format An environment (used as a mutable registry).
#' @keywords internal
trust_defaults <- local({
  defaults <- list(
    halo.max_radius     = 0.02,
    halo.n_layers       = 10L,
    halo.falloff        = 0.3,
    halo.base_intensity = 0.3,
    halo.expansion      = 0.000001,
    landscape.grid      = 100L,
    landscape.smoothing = "gam",
    landscape.bandwidth = NULL,
    landscape.idw_k     = 8L,
    landscape.raster_alpha = 0.5,
    landscape.contours  = TRUE,
    landscape.contour_bins = 5L,
    landscape.colourmap  = "viridis",
    selection.halo_max  = 500L,
    stat.k              = 10L,
    stat.aggregation    = "min"
  )
  e <- new.env(parent = emptyenv())
  list2env(defaults, envir = e)
  e
})

#' Get a trust default value
#'
#' @param key Character name of the default (e.g. `"halo.max_radius"`).
#' @return The current value for the given key.
#' @export
trust_default <- function(key) {
  trust_defaults[[key]]
}

#' Set a trust default value
#'
#' Overrides a single entry in the global [trust_defaults] registry. Takes
#' effect immediately for subsequently created layers.
#'
#' @param key Character name of the default to change.
#' @param value New value.
#' @return Invisibly, the old value.
#' @export
set_trust_default <- function(key, value) {
  if (is.null(trust_defaults[[key]])) {
    cli::cli_abort("Unknown trust default {.val {key}}.")
  }
  old <- trust_defaults[[key]]
  trust_defaults[[key]] <- value
  invisible(old)
}