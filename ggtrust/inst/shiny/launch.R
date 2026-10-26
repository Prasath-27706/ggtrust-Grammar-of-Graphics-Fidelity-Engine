#!/usr/bin/env Rscript
# ── ggtrust Study Launcher ───────────────────────────────────────────────────
# Run this script to start the study app.
#
# Usage:
#   cd ggtrust/inst/shiny && Rscript launch.R
#   # or open in RStudio and click Run App
#
# Requirements:
#   - R packages: shiny, bslib, ggplot2, Rtsne, DT, scales, rlang
#   - ggtrust package installed (R CMD INSTALL ..)
# ──────────────────────────────────────────────────────────────────────────────

cat("═══════════════════════════════════════════════════\n")
cat("  ggtrust — Spatialization Fidelity Study\n")
cat("═══════════════════════════════════════════════════\n\n")

needed <- c("shiny", "bslib", "ggplot2", "Rtsne", "DT", "scales", "rlang")
missing <- needed[!sapply(needed, requireNamespace, quietly = TRUE)]
if (length(missing) > 0) {
  cat("Installing missing packages:", paste(missing, collapse = ", "), "\n")
  install.packages(missing, repos = "https://cloud.r-project.org")
}

if (!requireNamespace("ggtrust", quietly = TRUE)) {
  pkg_dir <- normalizePath(file.path(getwd(), ".."), mustWork = TRUE)
  cat("Installing ggtrust from", pkg_dir, "\n")
  install.packages(pkg_dir, repos = NULL, type = "source")
}

# Set working directory to package root so manifest/data paths resolve correctly
setwd(file.path(getwd(), "../.."))
cat("Working directory:", getwd(), "\n")
cat("Starting app...\n\n")
shiny::runApp(file.path(getwd(), "inst", "shiny", "app.R"), port = 3838, launch.browser = TRUE)
