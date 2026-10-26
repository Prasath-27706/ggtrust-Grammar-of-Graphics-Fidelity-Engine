# Package-level hooks

.onLoad <- function(libname, pkgname) {
  invisible(NULL)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "ggtrust 0.1.0 - spatialization fidelity for DR scatterplots.\n",
    "  Use geom_trust_point() for auto-encoding; add scale_reliability_*()",
    "to control the colormap."
  )
}