\name{geom_trust_landscape}
\alias{geom_trust_landscape}
\title{geom_trust_landscape}
\usage{
geom_trust_landscape(mapping = NULL, data = NULL, grid_size = NULL, smoothing = NULL, bandwidth = NULL, idw_k = NULL, raster_alpha = NULL, contours = NULL, contour_bins = NULL, colourmap = NULL, na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...)
}
\description{Landscape geom for DR scatterplots. Renders a smoothed reliability surface as a semitransparent raster with optional contour lines.}
\arguments{
    \item{mapping}{Set of aesthetic mappings created by aes().}
    \item{data}{The data to be displayed.}
    \item{grid_size}{Number of grid cells per axis.}
    \item{smoothing}{Smoothing method: gam, loess, or idw.}
    \item{bandwidth}{Smoothing bandwidth.}
    \item{idw_k}{Number of nearest neighbors for idw.}
    \item{raster_alpha}{Opacity of the raster fill (0-1).}
    \item{contours}{Draw contour lines on the fidelity surface?}
    \item{contour_bins}{Number of contour levels.}
    \item{colourmap}{Colormap for the fidelity surface.}
    \item{na.rm}{If FALSE, the default, missing values are removed with a warning.}
    \item{show.legend}{Logical. Should this layer be included in the legends?}
    \item{inherit.aes}{If TRUE, combine mapping with default mapping.}
    \item{...}{Other arguments passed to layer().}
}
