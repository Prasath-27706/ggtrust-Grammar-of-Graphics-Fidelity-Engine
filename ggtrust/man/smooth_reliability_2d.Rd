\name{smooth_reliability_2d}
\alias{smooth_reliability_2d}
\title{smooth_reliability_2d}
\usage{
smooth_reliability_2d(x, y, reliability, grid_size = 100L, method = c("gam", "loess", "idw"), bandwidth = NULL, idw_k = 8L)
}
\description{Smooth a reliability field over the 2D panel using GAM, loess, or IDW.}
\arguments{
    \item{x}{Numeric vector of x coordinates.}
    \item{y}{Numeric vector of y coordinates.}
    \item{reliability}{Numeric vector of reliability values in [0, 1].}
    \item{grid_size}{Number of grid cells per axis.}
    \item{method}{Smoothing method: gam, loess, or idw.}
    \item{bandwidth}{Smoothing bandwidth.}
    \item{idw_k}{Number of nearest neighbors for idw.}
}
