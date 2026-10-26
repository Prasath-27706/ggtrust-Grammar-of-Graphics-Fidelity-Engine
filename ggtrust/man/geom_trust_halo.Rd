\name{geom_trust_halo}
\alias{geom_trust_halo}
\title{geom_trust_halo}
\usage{
geom_trust_halo(mapping = NULL, data = NULL, max_radius = NULL, n_layers = NULL, falloff = NULL, base_intensity = NULL, na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...)
}
\description{Halo geom for DR scatterplots. Renders concentric Gaussian halos whose opacity encodes per-point spatialization fidelity.}
\arguments{
    \item{mapping}{Set of aesthetic mappings created by aes().}
    \item{data}{The data to be displayed.}
    \item{max_radius}{Maximum halo radius as fraction of panel diagonal.}
    \item{n_layers}{Number of concentric rings per halo.}
    \item{falloff}{Gaussian falloff sigma for opacity decay.}
    \item{base_intensity}{Base opacity at reliability = 1.}
    \item{na.rm}{If FALSE, the default, missing values are removed with a warning.}
    \item{show.legend}{Logical. Should this layer be included in the legends?}
    \item{inherit.aes}{If TRUE, combine mapping with default mapping.}
    \item{...}{Other arguments passed to layer().}
}
