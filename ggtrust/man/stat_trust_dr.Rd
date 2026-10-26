\name{stat_trust_dr}
\alias{stat_trust_dr}
\title{stat_trust_dr}
\usage{
stat_trust_dr(mapping = NULL, data = NULL, geom = "trust_point", original_data, k = 10, aggregation = c("min", "prod", "avg"), na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...)
}
\description{Stat that computes trustworthiness/continuity fidelity from original high-dimensional data and its low-dimensional embedding.}
\arguments{
    \item{mapping}{Set of aesthetic mappings created by aes().}
    \item{data}{The data to be displayed.}
    \item{geom}{The geometric object to use to display the data.}
    \item{original_data}{Numeric matrix of original high-dimensional coordinates.}
    \item{k}{Number of nearest neighbors for T/C computation.}
    \item{aggregation}{How to combine T and C: min, prod, or avg.}
    \item{na.rm}{If FALSE, the default, missing values are removed with a warning.}
    \item{show.legend}{Logical. Should this layer be included in the legends?}
    \item{inherit.aes}{If TRUE, combine mapping with default mapping.}
    \item{...}{Other arguments passed to layer().}
}
