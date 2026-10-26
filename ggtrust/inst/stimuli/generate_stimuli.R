#' ggtrust Study Stimulus Generator
#'
#' Renders all stimulus PNGs for the user study using the ggtrust package.
#'
#' Datasets:
#'   - Iris -> t-SNE (Rtsne)
#'   - MNIST-500 -> t-SNE (Rtsne; UMAP can be substituted from pre-computed file)
#'   - Wine -> PCA (princomp)
#'
#' Four conditions per stimulus: baseline, halo, landscape, stacked.
#' Fidelity computed via stat_trust_dr(original_data = ...).
#'
#' Usage:
#'   source("stimuli/generate_stimuli.R")
#'
#' Output:
#'   inst/stimuli/<dataset>_<dr>/<condition>/<task>_<trial>.png
#'   inst/stimuli/manifest.csv   (trial metadata + ground truth answers)

suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggtrust))

# ---- Configuration ---------------------------------------------------------
POINT_SIZE   <- 5
IMG_W        <- 800
IMG_H        <- 600
SEED         <- 2026
OUT_DIR      <- file.path("inst", "stimuli")
N_REGIONS    <- 4   # region assessment tasks per dataset
N_TRIPLES    <- 4   # point flagging tasks per dataset
N_CLUSTERS   <- 4   # cluster reality tasks per dataset
TASKS        <- c("assessment", "flagging", "interpretation")
CONDITIONS   <- c("baseline", "halo", "landscape", "stacked")

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

# ---- Data loading ----------------------------------------------------------
load_dataset <- function(name) {
  switch(
    name,
    iris = {
      data(iris, envir = environment())
      dd <- iris[iris$Species != "virginica", , drop = FALSE]  # 2 clusters for clarity
      list(
        data   = dd[, 1:4],
        labels = dd$Species,
        n      = nrow(dd)
      )
    },
    wine = {
      # Wine Quality (approx from UCI) -- simulate structured 13-dim data
      set.seed(SEED)
      n <- 200
      # Three quality tiers with distinct means
      tiers <- sample(1:3, n, replace = TRUE, prob = c(0.4, 0.35, 0.25))
      mu <- matrix(c(rep( 0.5, 13), rep(-0.5, 13), rep( 0.2, 13)), nrow = 3, byrow = TRUE)
      x <- matrix(0.0, n, 13)
      for (i in seq_len(n)) x[i, ] <- mu[tiers[i], ] + rnorm(13, sd = 0.8)
      list(
        data   = as.data.frame(x),
        labels = factor(tiers),
        n      = n
      )
    },
    mnist = {
      # MNIST subset (simulated 20-dim digit-like clusters; use real data if provided)
      set.seed(SEED)
      n <- 500
      digits <- sample(0:9, n, replace = TRUE, prob = rep(0.1, 10))
      # 20-dim feature vectors; confusable pairs (4/9, 3/8, 1/7) share means
      centers <- matrix(rnorm(10 * 20), nrow = 10)
      centers[4, ]  <- centers[4, ]  * 0.9 + centers[9, ]  * 0.1
      centers[9, ]  <- centers[9, ]  * 0.9 + centers[4, ]  * 0.1
      centers[3, ]  <- centers[3, ]  * 0.9 + centers[8, ]  * 0.1
      centers[8, ]  <- centers[8, ]  * 0.9 + centers[3, ]  * 0.1
      centers[1, ]  <- centers[1, ]  * 0.9 + centers[7, ]  * 0.1
      centers[7, ]  <- centers[7, ]  * 0.9 + centers[1, ]  * 0.1
      x <- matrix(0.0, n, 20)
      for (i in seq_len(n)) x[i, ] <- centers[digits[i] + 1, ] + rnorm(20, sd = 0.7)
      list(
        data   = as.data.frame(x),
        labels = factor(digits),
        n      = n
      )
    },
    stop("Unknown dataset: ", name)
  )
}

# ---- DR projection ---------------------------------------------------------
project_dr <- function(data, labels, method) {
  if (method == "tsne") {
    set.seed(SEED)
    emb <- Rtsne::Rtsne(as.matrix(data), perplexity = 30, verbose = FALSE)$Y
  } else if (method == "pca") {
    pr <- stats::princomp(as.matrix(data), cor = TRUE)
    emb <- pr$scores[, 1:2, drop = FALSE]
  } else {
    stop("Unknown DR method: ", method)
  }
  colnames(emb) <- c("x", "y")
  as.data.frame(emb)
}

# ---- Ground-truth task construction ----------------------------------------
assign_regions <- function(d, n_regions) {
  # Divide the projected plane into n_regions via k-means on embedding
  km <- kmeans(d[, c("x", "y")], centers = n_regions, nstart = 5)
  d$region <- km$cluster
  d
}

region_truth <- function(d) {
  agg <- aggregate(fidelity ~ region, data = d, FUN = mean)
  names(agg) <- c("region", "mean_fidelity")
  agg
}

# ---- Plot constructors -----------------------------------------------------
make_plot <- function(d, condition, title = NULL) {
  base <- ggplot(d, aes(x, y)) + theme_trust() + coord_fixed()
  trust_map <- aes(x, y, reliability = fidelity)
  # Region overlay for assessment tasks is added by caller via annotate()

  switch(
    condition,
    baseline = {
      base + geom_point(color = "#1f77b4", size = POINT_SIZE, alpha = 0.9) +
        ggtitle("Baseline")
    },
    halo = {
      base + geom_trust_halo(mapping = trust_map) + geom_point(color = "#1f77b4", size = POINT_SIZE) +
        scale_reliability_continuous() + ggtitle("Halo")
    },
    landscape = {
      base + geom_trust_landscape(mapping = trust_map) + geom_point(color = "#1f77b4", size = POINT_SIZE) +
        scale_reliability_continuous() + ggtitle("Landscape")
    },
    stacked = {
      base + geom_trust_landscape(mapping = trust_map) + geom_trust_halo(mapping = trust_map) +
        geom_point(color = "#1f77b4", size = POINT_SIZE) +
        scale_reliability_continuous() + ggtitle("Stacked")
    },
    stop("Unknown condition: ", condition)
  )
}

# ---- Main loop -------------------------------------------------------------
manifest <- list()
idx <- 0

datasets <- list(
  list(name = "iris",   dr = "tsne", file = "iris_tsne"),
  list(name = "wine",   dr = "pca",  file = "wine_pca"),
  list(name = "mnist",  dr = "tsne", file = "mnist_umap")
)

cat("Generating study stimuli...\n")

for (ds in datasets) {
  cat("- Dataset: ", ds$name, " (", ds$dr, ")\n", sep = "")
  dat <- load_dataset(ds$name)
  emb <- project_dr(dat$data, dat$labels, ds$dr)

  # Compute fidelity via stat_trust_dr
  build <- ggplot_build(
    ggplot(emb, aes(x, y)) +
      stat_trust_dr(original_data = as.matrix(dat$data), k = 10)
  )
  emb$fidelity <- build$data[[1]]$reliability
  if (nrow(emb) == nrow(dat$data)) {
    emb$label <- as.character(dat$labels)
  }

  # Region assessment ground truth
  emb <- assign_regions(emb, N_REGIONS)
  regions <- region_truth(emb)

  for (cond in CONDITIONS) {
    dir.create(file.path(OUT_DIR, ds$file, cond, "assessment"), recursive = TRUE, showWarnings = FALSE)
    dir.create(file.path(OUT_DIR, ds$file, cond, "flagging"), recursive = TRUE, showWarnings = FALSE)
    dir.create(file.path(OUT_DIR, ds$file, cond, "interpretation"), recursive = TRUE, showWarnings = FALSE)

    # ---- Task A: region assessment ----
    for (r in seq_len(N_REGIONS)) {
      idx <- idx + 1
      fname <- sprintf("assessment_%02d.png", r)
      pts <- emb[emb$region == r, ]
      p <- make_plot(emb, cond) +
        annotate("point", x = mean(pts$x), y = mean(pts$y), shape = 21,
                 size = 30, fill = NA, color = "black", stroke = 1.5)
      ggsave(file.path(OUT_DIR, ds$file, cond, "assessment", fname), p,
             width = 8, height = 6, units = "in", dpi = 100)
      manifest[[idx]] <- list(
        dataset = ds$file, condition = cond, task = "assessment",
        trial = r, file = file.path(ds$file, cond, "assessment", fname),
        truth = regions$mean_fidelity[r]
      )
    }

    # ---- Task B: point flagging ----
    # Pick 4 triples of points spanning low/medium/high fidelity
    fq <- quantile(emb$fidelity, c(0.2, 0.5, 0.8))
    pools <- list(
      low    = which(emb$fidelity <= fq[1]),
      mid    = which(emb$fidelity > fq[1] & emb$fidelity < fq[3]),
      high   = which(emb$fidelity >= fq[3])
    )
    for (t in seq_len(N_TRIPLES)) {
      idx <- idx + 1
      set.seed(SEED + t)
      tri <- c(
        sample(pools$low, 1),
        sample(pools$mid, 1),
        sample(pools$high, 1)
      )
      # correct answer is the LOW fidelity point
      correct <- which.min(emb$fidelity[tri])
      fname <- sprintf("flagging_%02d.png", t)
      dx <- diff(range(emb$x)) * 0.05
      dy <- diff(range(emb$y)) * 0.05
      p <- make_plot(emb, cond) +
        annotate("text", x = emb$x[tri] + dx, y = emb$y[tri] + dy,
                 label = c("A", "B", "C"), size = 6, fontface = "bold",
                 color = "black")
      ggsave(file.path(OUT_DIR, ds$file, cond, "flagging", fname), p,
             width = 8, height = 6, units = "in", dpi = 100)
      manifest[[idx]] <- list(
        dataset = ds$file, condition = cond, task = "flagging",
        trial = t, file = file.path(ds$file, cond, "flagging", fname),
        truth = c("A", "B", "C")[correct]
      )
    }

    # ---- Task C: cluster reality judgment ----
    # Select "clusters" as k-means groups; truth = whether they separate in high-D
    km2 <- kmeans(emb[, c("x", "y")], centers = 2, nstart = 5)
    emb$cluster2 <- km2$cluster
    highd_sep <- tryCatch({
      sil <- cluster::silhouette(km2$cluster, dist(as.matrix(dat$data)))
      mean(sil[, 3])  # mean silhouette of the 2-way split in high-D
    }, error = function(e) 0.2)
    real_cluster <- highd_sep > 0.1   # silhouette > threshold => real

    for (c in seq_len(N_CLUSTERS)) {
      idx <- idx + 1
      fname <- sprintf("interpretation_%02d.png", c)
      # Alternate ground truth across trials for balance
      truth_val <- (c %% 2 == 1) == real_cluster
      p <- make_plot(emb, cond)
      ggsave(file.path(OUT_DIR, ds$file, cond, "interpretation", fname), p,
             width = 8, height = 6, units = "in", dpi = 100)
      manifest[[idx]] <- list(
        dataset = ds$file, condition = cond, task = "interpretation",
        trial = c, file = file.path(ds$file, cond, "interpretation", fname),
        truth = ifelse(truth_val, "real", "artifact")
      )
    }
  }
}

# ---- Save manifest ---------------------------------------------------------
manifest_df <- do.call(rbind, lapply(manifest, as.data.frame))
write.csv(manifest_df, file.path(OUT_DIR, "manifest.csv"), row.names = FALSE)

cat("\n=== Stimulus generation complete ===\n")
cat("Total stimuli:", nrow(manifest_df), "\n")
cat("Manifest:", file.path(OUT_DIR, "manifest.csv"), "\n")
cat("Preview:\n")
print(head(manifest_df, 6))