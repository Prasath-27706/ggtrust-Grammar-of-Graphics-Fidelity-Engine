\name{compute_fidelity}
\alias{compute_fidelity}
\title{compute_fidelity}
\usage{
compute_fidelity(original_data, embedding, k = 10)
}
\description{Compute trustworthiness and continuity for a DR embedding.}
\arguments{
    \item{original_data}{Numeric matrix of original high-dimensional coordinates.}
    \item{embedding}{Numeric matrix of low-dimensional embedding coordinates.}
    \item{k}{Number of nearest neighbors.}
}
