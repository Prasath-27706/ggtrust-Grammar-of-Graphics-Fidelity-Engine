# ── Helpers for ggtrust Interactive Data Visualization Explorer ──────────────

library(ggplot2)

#' Load and prepare sample datasets with high-D data and 2D embedding
get_preset_dataset <- function(name, seed = 2026) {
  set.seed(seed)

  if (name == "scrna_pbmc") {
    # ── High-Stakes Real-World Domain: Single-Cell Immune Genomics (scRNA-seq) ──
    # 500 human immune cells profiled across 20 key lineage marker genes
    # Cell lineages: CD4+ T-Cells (120), CD8+ Cytotoxic T-Cells (100), B-Cells (100), Monocytes (100), NK Cells (80)
    n_cells <- 500
    n_genes <- 20
    cell_types <- c(rep("CD4+ T-Cells", 120),
                    rep("CD8+ T-Cells", 100),
                    rep("B-Cells", 100),
                    rep("Monocytes", 100),
                    rep("NK Cells", 80))

    gene_names <- c("CD3D", "CD4", "CD8A", "CD8B", "IL7R", "GZMA", "CD19", "MS4A1", "CD14", "FCGR3A",
                    "CCR7", "S100A4", "NCAM1", "NKG7", "HLA-DRA", "CD79A", "GNLY", "PRF1", "CST3", "LYZ")

    means <- matrix(c(
      5.2, 1.4, 0.4, 0.2, 4.9, 1.0, 0.2, 0.1, 0.2, 0.3, 2.2, 1.1, 0.4, 0.2, 0.1, 0.2, 0.2, 0.1, 0.4, 0.3, # CD4+
      4.9, 5.3, 0.3, 0.1, 0.6, 5.1, 0.1, 0.1, 0.1, 0.2, 1.8, 0.7, 0.3, 0.2, 0.1, 0.1, 0.1, 0.1, 0.3, 0.2, # CD8+
      0.2, 0.1, 5.6, 5.0, 0.3, 0.2, 0.1, 0.1, 0.1, 0.2, 0.2, 0.1, 0.1, 0.1, 4.8, 4.4, 0.1, 0.1, 0.2, 0.2, # B-Cells
      0.1, 0.2, 0.2, 0.1, 0.2, 0.1, 5.9, 5.4, 5.0, 4.7, 0.1, 0.1, 0.2, 0.3, 0.1, 0.2, 0.1, 0.2, 0.3, 0.1, # Monocytes
      1.6, 4.8, 0.2, 0.1, 0.2, 4.1, 0.2, 0.1, 0.2, 0.1, 1.1, 0.4, 4.9, 4.3, 0.1, 0.1, 0.2, 0.1, 0.3, 0.2  # NK Cells
    ), nrow = 5, byrow = TRUE)

    counts <- c(120, 100, 100, 100, 80)
    X <- matrix(0, nrow = n_cells, ncol = n_genes)
    start <- 1
    for (i in 1:5) {
      cnt <- counts[i]
      noise <- matrix(rnorm(cnt * n_genes, mean = 0, sd = 1.0), nrow = cnt)
      X[start:(start + cnt - 1), ] <- matrix(rep(means[i, ], cnt), nrow = cnt, byrow = TRUE) + noise
      start <- start + cnt
    }
    X[X < 0] <- 0
    colnames(X) <- gene_names

    # Initial t-SNE projection
    if (requireNamespace("Rtsne", quietly = TRUE)) {
      emb <- Rtsne::Rtsne(X, perplexity = 25, check_duplicates = FALSE, verbose = FALSE)$Y
    } else {
      emb <- stats::princomp(X, cor = TRUE)$scores[, 1:2]
    }
    colnames(emb) <- c("x", "y")

    # Introduce realistic biological t-SNE projection artifacts:
    # 1. 22 CD8+ T-cells displaced near Monocytes in 2D (False Intrusion / Impostors)
    cd8_displaced <- 121:142
    emb[cd8_displaced, ] <- emb[cd8_displaced, ] + matrix(c(24, -18), nrow = length(cd8_displaced), ncol = 2, byrow = TRUE)

    # 2. 24 CD4+ memory T-cells torn into a distant isolated island (Torn Extrusion / Exiles)
    cd4_torn <- 97:120
    emb[cd4_torn, ] <- emb[cd4_torn, ] + matrix(c(-32, 28), nrow = length(cd4_torn), ncol = 2, byrow = TRUE)

    df <- as.data.frame(emb)
    df$label <- factor(cell_types, levels = c("CD4+ T-Cells", "CD8+ T-Cells", "B-Cells", "Monocytes", "NK Cells"))
    df$Cell_ID <- paste0("CELL_", sprintf("%03d", seq_len(n_cells)))

    return(list(
      name = "Single-Cell RNA-seq (Human PBMC: 500 Cells, 20 Marker Genes)",
      orig = as.data.frame(X),
      emb = df,
      type = "genomics"
    ))

  } else if (name == "iris") {
    data(iris, envir = environment())
    orig <- iris[, 1:4]
    if (requireNamespace("Rtsne", quietly = TRUE)) {
      emb <- Rtsne::Rtsne(as.matrix(orig), perplexity = 30, check_duplicates = FALSE, verbose = FALSE)$Y
    } else {
      emb <- stats::princomp(orig, cor = TRUE)$scores[, 1:2]
    }
    colnames(emb) <- c("x", "y")
    df <- as.data.frame(emb)
    df$label <- iris$Species
    df$Cell_ID <- paste0("IRIS_", sprintf("%03d", seq_len(nrow(df))))
    return(list(name = "Iris Benchmark (t-SNE Projection)", orig = orig, emb = df, type = "benchmark"))

  } else if (name == "wine") {
    n <- 200
    tiers <- sample(1:3, n, replace = TRUE, prob = c(0.4, 0.35, 0.25))
    mu <- matrix(c(rep(0.5, 13), rep(-0.5, 13), rep(0.2, 13)), nrow = 3, byrow = TRUE)
    x <- matrix(0, n, 13)
    for (i in seq_len(n)) x[i, ] <- mu[tiers[i], ] + rnorm(13, sd = 0.8)
    pr <- stats::princomp(x, cor = TRUE)
    emb <- pr$scores[, 1:2]
    colnames(emb) <- c("x", "y")
    df <- data.frame(emb, label = factor(paste("Tier", tiers)))
    df$Cell_ID <- paste0("WINE_", sprintf("%03d", seq_len(nrow(df))))
    return(list(name = "Wine Quality (PCA Projection)", orig = as.data.frame(x), emb = df, type = "benchmark"))

  } else if (name == "mnist") {
    n <- 400
    digits <- sample(0:9, n, replace = TRUE)
    centers <- matrix(rnorm(10 * 15), nrow = 10)
    centers[4, ] <- centers[4, ] * 0.8 + centers[9, ] * 0.2
    centers[9, ] <- centers[9, ] * 0.8 + centers[4, ] * 0.2
    centers[3, ] <- centers[3, ] * 0.8 + centers[8, ] * 0.2
    centers[8, ] <- centers[8, ] * 0.8 + centers[3, ] * 0.2
    x <- matrix(0, n, 15)
    for (i in seq_len(n)) x[i, ] <- centers[digits[i] + 1, ] + rnorm(15, sd = 0.7)

    if (requireNamespace("Rtsne", quietly = TRUE)) {
      emb <- Rtsne::Rtsne(x, perplexity = 25, check_duplicates = FALSE, verbose = FALSE)$Y
    } else {
      emb <- stats::princomp(x, cor = TRUE)$scores[, 1:2]
    }
    colnames(emb) <- c("x", "y")
    df <- data.frame(emb, label = factor(digits))
    df$Cell_ID <- paste0("DIGIT_", sprintf("%03d", seq_len(nrow(df))))
    return(list(name = "MNIST-400 Digits (t-SNE Distortion Demo)", orig = as.data.frame(x), emb = df, type = "benchmark"))

  } else if (name == "synthetic") {
    n <- 250
    g1 <- matrix(rnorm(n * 8, mean = 0), ncol = 8)
    g2 <- matrix(rnorm(n * 8, mean = 3), ncol = 8)
    x <- rbind(g1, g2)
    pr <- stats::princomp(x, cor = TRUE)$scores[, 1:2]
    colnames(pr) <- c("x", "y")
    df <- data.frame(pr, label = factor(rep(c("Cluster A", "Cluster B"), each = n)))
    bad_idx <- sample(1:(2 * n), size = floor(0.15 * 2 * n))
    df$x[bad_idx] <- df$x[bad_idx] + rnorm(length(bad_idx), mean = 4, sd = 1.5)
    df$Cell_ID <- paste0("SYN_", sprintf("%03d", seq_len(nrow(df))))
    return(list(name = "Synthetic Clusters with Projection Distortions", orig = as.data.frame(x), emb = df, type = "benchmark"))
  }
}

#' Compute per-point trustworthiness, continuity, and combined spatialization fidelity
compute_dataset_fidelity <- function(dataset_obj, k = 10, aggregation = "min", threshold_pct = 0.35) {
  orig <- as.matrix(dataset_obj$orig)
  emb <- as.matrix(dataset_obj$emb[, c("x", "y")])

  fc <- compute_fidelity(orig, emb, k = k)

  T <- fc$trustworthiness
  C <- fc$continuity

  fidelity <- switch(aggregation,
    min  = pmin(T, C),
    prod = T * C,
    avg  = (T + C) / 2
  )

  df <- dataset_obj$emb
  df$trustworthiness <- T
  df$continuity <- C
  df$reliability <- pmin(pmax(fidelity, 0), 1)

  # ── Distortion Typology Classification ────────────────────────────────────
  # Uses distribution percentiles or absolute thresholds (whichever is more informative)
  tau_t <- quantile(T, threshold_pct)
  tau_c <- quantile(C, threshold_pct)

  typology <- character(nrow(df))
  is_high_T <- df$trustworthiness >= tau_t
  is_high_C <- df$continuity >= tau_c

  typology[is_high_T & is_high_C]   <- "Faithful Anchor"
  typology[!is_high_T & is_high_C]  <- "False Impostor (Intrusion)"
  typology[is_high_T & !is_high_C]  <- "Torn Exile (Extrusion)"
  typology[!is_high_T & !is_high_C] <- "Critical Artifact (Void)"

  df$typology <- factor(typology, levels = c(
    "Faithful Anchor",
    "False Impostor (Intrusion)",
    "Torn Exile (Extrusion)",
    "Critical Artifact (Void)"
  ))

  dataset_obj$emb_annotated <- df
  dataset_obj$k <- k
  dataset_obj$aggregation <- aggregation
  dataset_obj$tau_t <- as.numeric(tau_t)
  dataset_obj$tau_c <- as.numeric(tau_c)
  dataset_obj
}

#' 1. Render 2D Spatialization Scatterplot
render_ggtrust_plot <- function(dataset_obj,
                                encoding = "halo",
                                halo_max_radius = 0.02,
                                halo_n_layers = 10,
                                halo_falloff = 0.3,
                                halo_base_intensity = 0.3,
                                landscape_smoothing = "gam",
                                landscape_raster_alpha = 0.5,
                                landscape_contour_bins = 5,
                                tether_k = 3,
                                tether_threshold = 0.75,
                                tether_max_alpha = 0.45,
                                crosshair_max_length = 0.03,
                                crosshair_width = 0.6,
                                point_size = 2.5,
                                point_alpha = 0.9,
                                color_by = "label") {

  df <- dataset_obj$emb_annotated
  p <- ggplot(df, aes(x = x, y = y, reliability = reliability))

  if (color_by == "label" && "label" %in% names(df)) {
    point_mapping <- aes(color = label)
  } else if (color_by == "typology") {
    point_mapping <- aes(color = typology)
  } else {
    point_mapping <- aes(color = reliability)
  }

  if (encoding == "baseline") {
    p <- p + geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      labs(title = "Baseline Scatterplot (Unannotated DR Output)",
           subtitle = "Positions carry no visual indicator of spatialization quality or projection distortion")

  } else if (encoding == "halo") {
    p <- p +
      geom_trust_halo(
        max_radius = halo_max_radius,
        n_layers = halo_n_layers,
        falloff = halo_falloff,
        base_intensity = halo_base_intensity
      ) +
      geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      scale_reliability_continuous() +
      labs(title = "Technique 1: Spatialization Fidelity Scatterplot (Gaussian Halos)",
           subtitle = "Concentric rings flag low-fidelity points (extent = attention, opacity = trust)")

  } else if (encoding == "landscape") {
    p <- p +
      geom_trust_landscape(
        smoothing = landscape_smoothing,
        raster_alpha = landscape_raster_alpha,
        contour_bins = landscape_contour_bins
      ) +
      geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      scale_reliability_continuous() +
      labs(title = "Technique 1B: Continuous Fidelity Surface (Context Landscape)",
           subtitle = "Smoothed background surface reveals macro-level regional quality terrain")

  } else if (encoding == "tether") {
    p <- p +
      geom_trust_tether(
        original_data = dataset_obj$orig,
        k_tether = tether_k,
        fidelity_threshold = tether_threshold,
        max_alpha = tether_max_alpha
      ) +
      geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      scale_reliability_continuous() +
      labs(title = "Technique 1C: Topological Neighbor Tethers (Relational Network)",
           subtitle = "Elastic vector lines expose topological tears connecting displaced points to true high-D neighbors")

  } else if (encoding == "crosshair") {
    p <- p +
      geom_trust_crosshair(
        max_length = crosshair_max_length,
        line_width = crosshair_width
      ) +
      geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      scale_reliability_continuous() +
      labs(title = "Technique 1D: Geometric Uncertainty Crosshairs (Error Glyphs)",
           subtitle = "Directional error crosshairs scale arm lengths inversely with per-point fidelity")

  } else if (encoding == "alpha") {
    p <- ggplot(df, aes(x = x, y = y)) +
      geom_point(aes(color = if (color_by == "label" && "label" %in% names(df)) label else reliability,
                     alpha = reliability),
                 size = point_size) +
      scale_alpha_continuous(range = c(0.12, 1.0), name = "Fidelity α") +
      labs(title = "Technique 1E: Point-Intrinsic Alpha Saliency (Opacity Modulation)",
           subtitle = "Unreliable points fade into background transparency; high-fidelity points remain vivid")

  } else if (encoding == "stacked") {
    p <- p +
      geom_trust_landscape(
        smoothing = landscape_smoothing,
        raster_alpha = landscape_raster_alpha * 0.65,
        contour_bins = landscape_contour_bins
      ) +
      geom_trust_halo(
        max_radius = halo_max_radius,
        n_layers = halo_n_layers,
        falloff = halo_falloff,
        base_intensity = halo_base_intensity
      ) +
      geom_point(point_mapping, size = point_size, alpha = point_alpha) +
      scale_reliability_continuous() +
      labs(title = "Technique 1F: Stacked Hybrid Mode (Halos + Landscape Surface)",
           subtitle = "Dual-layer visualization combining regional macro terrain with per-point halo flags")
  }

  p <- p + theme_trust()

  if (color_by == "reliability" && encoding != "alpha") {
    p <- p + scale_color_viridis_c(option = "viridis", name = "Fidelity Score")
  } else if (color_by == "typology") {
    p <- p + scale_color_manual(
      name = "Distortion Typology",
      values = c(
        "Faithful Anchor"            = "#10b981",
        "False Impostor (Intrusion)" = "#ef4444",
        "Torn Exile (Extrusion)"     = "#f59e0b",
        "Critical Artifact (Void)"   = "#8b5cf6"
      )
    )
  }

  p
}

#' 2. Interactive Neighborhood Inspector Lens (Actionable Tethers & Impostor Field)
render_neighborhood_inspector_plot <- function(dataset_obj, selected_id = 1) {
  orig <- as.matrix(dataset_obj$orig)
  df <- dataset_obj$emb_annotated
  n <- nrow(df)
  k <- dataset_obj$k

  if (is.null(selected_id) || selected_id < 1 || selected_id > n) {
    selected_id <- 1
  }

  target_pt <- df[selected_id, ]

  # Distance in High-D
  diff_orig <- sweep(orig, 2, orig[selected_id, ], "-")
  d_orig <- sqrt(rowSums(diff_orig^2))
  d_orig[selected_id] <- Inf
  high_d_nn_idx <- order(d_orig)[seq_len(k)]

  # Distance in 2D Embedding
  diff_emb <- sweep(as.matrix(df[, c("x", "y")]), 2, as.numeric(target_pt[c("x", "y")]), "-")
  d_emb <- sqrt(rowSums(diff_emb^2))
  d_emb[selected_id] <- Inf
  emb_nn_idx <- order(d_emb)[seq_len(k)]

  # Categorize relationships
  impostor_idx <- setdiff(emb_nn_idx, high_d_nn_idx)
  faithful_nn_idx <- intersect(emb_nn_idx, high_d_nn_idx)
  torn_away_idx <- setdiff(high_d_nn_idx, emb_nn_idx)

  # Elastic tethers from target cell to True High-D Neighbors
  tether_lines <- data.frame(
    x = rep(target_pt$x, length(high_d_nn_idx)),
    y = rep(target_pt$y, length(high_d_nn_idx)),
    xend = df$x[high_d_nn_idx],
    yend = df$y[high_d_nn_idx],
    is_retained = high_d_nn_idx %in% faithful_nn_idx
  )

  p <- ggplot(df, aes(x = x, y = y)) +
    # Background points
    geom_point(aes(color = label), alpha = 0.35, size = 2.2) +

    # Elastic tethers to true high-D neighbors
    geom_segment(
      data = tether_lines,
      aes(x = x, y = y, xend = xend, yend = yend, linetype = is_retained),
      color = "#10b981", linewidth = 1.1, alpha = 0.85
    ) +

    # Highlight true high-D neighbors
    geom_point(
      data = df[high_d_nn_idx, ],
      aes(x = x, y = y),
      shape = 21, size = 4.5, stroke = 1.5, fill = "#10b981", color = "black", alpha = 0.90
    ) +

    # Highlight false 2D impostors with warning rings
    geom_point(
      data = if (length(impostor_idx) > 0) df[impostor_idx, ] else df[1, ][0, ],
      aes(x = x, y = y),
      shape = 21, size = 6.5, stroke = 2.2, fill = NA, color = "#ef4444"
    ) +

    # Selected target point (reticle mark)
    geom_point(
      data = target_pt,
      aes(x = x, y = y),
      shape = 21, size = 8.0, stroke = 2.8, fill = "#fbbf24", color = "black"
    ) +
    geom_point(
      data = target_pt,
      aes(x = x, y = y),
      shape = 3, size = 5.5, stroke = 2.0, color = "black"
    ) +

    scale_linetype_manual(
      name = "Neighbor Status",
      values = c("TRUE" = "solid", "FALSE" = "dashed"),
      labels = c("TRUE" = "Preserved 2D Neighbor", "FALSE" = "Torn Away Neighbor")
    ) +
    theme_trust() +
    labs(
      title = paste0("Topological Inspector: Cell #", selected_id, " (", target_pt$label, ")"),
      subtitle = paste0(
        "Fidelity S_i = ", round(target_pt$reliability, 3),
        " | Typology: ", target_pt$typology,
        " | True Neighbors: ", length(high_d_nn_idx), " (Green)",
        " | False Impostors: ", length(impostor_idx), " (Red Rings)"
      ),
      x = "2D Projection X", y = "2D Projection Y"
    )

  p
}

#' 3. Distortion Typology Phase Plane (Trustworthiness vs. Continuity 4-Quadrant Matrix)
render_distortion_typology_plot <- function(dataset_obj) {
  df <- dataset_obj$emb_annotated
  tau_t <- dataset_obj$tau_t
  tau_c <- dataset_obj$tau_c

  min_t <- max(0, min(df$trustworthiness) - 0.03)
  min_c <- max(0, min(df$continuity) - 0.03)

  p <- ggplot(df, aes(x = trustworthiness, y = continuity)) +
    # Quadrant background panels
    annotate("rect", xmin = tau_t, xmax = 1.01, ymin = tau_c, ymax = 1.01, fill = "#d1fae5", alpha = 0.5) +
    annotate("rect", xmin = min_t, xmax = tau_t, ymin = tau_c, ymax = 1.01, fill = "#fee2e2", alpha = 0.5) +
    annotate("rect", xmin = tau_t, xmax = 1.01, ymin = min_c, ymax = tau_c, fill = "#fef3c7", alpha = 0.5) +
    annotate("rect", xmin = min_t, xmax = tau_t, ymin = min_c, ymax = tau_c, fill = "#f3e8ff", alpha = 0.5) +

    # Quadrant threshold lines
    geom_vline(xintercept = tau_t, linetype = "dashed", color = "#475569", linewidth = 0.8) +
    geom_hline(yintercept = tau_c, linetype = "dashed", color = "#475569", linewidth = 0.8) +

    # Quadrant labels
    annotate("text", x = (tau_t + 1.0) / 2, y = 1.005, label = "FAITHFUL ANCHORS\n(High Trust & Continuity)",
             fontface = "bold", size = 3.5, color = "#065f46", hjust = 0.5, vjust = 1) +
    annotate("text", x = (min_t + tau_t) / 2, y = 1.005, label = "FALSE IMPOSTORS\n(Low Trust: Intrusion)",
             fontface = "bold", size = 3.5, color = "#991b1b", hjust = 0.5, vjust = 1) +
    annotate("text", x = (tau_t + 1.0) / 2, y = min_c + 0.015, label = "TORN EXILES\n(Low Continuity: Extrusion)",
             fontface = "bold", size = 3.5, color = "#92400e", hjust = 0.5, vjust = 0) +
    annotate("text", x = (min_t + tau_t) / 2, y = min_c + 0.015, label = "CRITICAL ARTIFACTS\n(Void / Manifold Collapse)",
             fontface = "bold", size = 3.5, color = "#581c87", hjust = 0.5, vjust = 0) +

    # Scatter points colored by class/lineage
    geom_point(aes(color = label), size = 2.6, alpha = 0.75) +

    scale_x_continuous(limits = c(min_t, 1.01), breaks = scales::pretty_breaks(n = 6)) +
    scale_y_continuous(limits = c(min_c, 1.01), breaks = scales::pretty_breaks(n = 6)) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 13),
      panel.grid.minor = element_blank()
    ) +
    labs(
      title = "Technique 3: Distortion Typology Phase Plane (T vs C Matrix)",
      subtitle = "Decomposes reliability into orthogonal error modes: Intrusions (False Neighbors) vs Extrusions (Torn Clusters)",
      x = paste0("Trustworthiness T(k, i) [Threshold = ", round(tau_t, 3), "] — Penalizes False Neighbors"),
      y = paste0("Continuity C(k, i) [Threshold = ", round(tau_c, 3), "] — Penalizes Torn Clusters"),
      color = "Ground Truth Class"
    )

  p
}

#' 4. Multi-Scale Scale-Space Horizon / Spectrum Curve (k-Spectrum Stability)
render_scale_spectrum_plot <- function(dataset_obj) {
  orig <- as.matrix(dataset_obj$orig)
  emb <- as.matrix(dataset_obj$emb[, c("x", "y")])
  df_emb <- dataset_obj$emb
  labels <- unique(df_emb$label)

  k_values <- c(3, 5, 10, 15, 20, 30, 45)
  curve_records <- list()

  for (kv in k_values) {
    fc <- compute_fidelity(orig, emb, k = kv)
    fi <- pmin(fc$trustworthiness, fc$continuity)

    for (lbl in labels) {
      mask <- df_emb$label == lbl
      curve_records[[length(curve_records) + 1]] <- data.frame(
        k = kv,
        Label = lbl,
        MeanFidelity = mean(fi[mask]),
        MinFidelity = min(fi[mask]),
        MaxFidelity = max(fi[mask])
      )
    }
  }

  curve_df <- do.call(rbind, curve_records)

  p <- ggplot(curve_df, aes(x = k, y = MeanFidelity, color = Label, group = Label)) +
    geom_line(linewidth = 1.3) +
    geom_point(size = 3.0) +
    scale_x_continuous(breaks = k_values) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 13),
      legend.position = "right"
    ) +
    labs(
      title = "Technique 4: Multi-Scale Scale-Space Horizon (k-Spectrum)",
      subtitle = "Tracks manifold preservation across micro (k ≤ 5) to macro (k ≥ 30) neighborhood scales",
      x = "Neighborhood Size parameter (k)",
      y = "Mean Spatialization Fidelity S(k)",
      color = "Cell Lineage"
    )

  p
}

#' 5. Parallel Coordinates Plot (PCP) for High-Dimensional Features
render_pcp_plot <- function(dataset_obj) {
  orig <- as.data.frame(dataset_obj$orig)
  df_emb <- dataset_obj$emb_annotated

  if (ncol(orig) > 8) {
    vars <- apply(orig, 2, var)
    top_cols <- names(sort(vars, decreasing = TRUE)[1:8])
    orig <- orig[, top_cols, drop = FALSE]
  }

  scaled_orig <- as.data.frame(lapply(orig, function(v) {
    rng <- range(v, na.rm = TRUE)
    if (diff(rng) == 0) return(rep(0.5, length(v)))
    (v - rng[1]) / diff(rng)
  }))

  scaled_orig$ID <- seq_len(nrow(scaled_orig))
  scaled_orig$reliability <- df_emb$reliability
  scaled_orig$label <- df_emb$label

  feature_names <- setdiff(names(scaled_orig), c("ID", "reliability", "label"))
  long_list <- list()
  for (feat in feature_names) {
    long_list[[feat]] <- data.frame(
      ID = scaled_orig$ID,
      Dimension = feat,
      Value = scaled_orig[[feat]],
      reliability = scaled_orig$reliability,
      label = scaled_orig$label,
      stringsAsFactors = FALSE
    )
  }
  long_df <- do.call(rbind, long_list)
  long_df$Dimension <- factor(long_df$Dimension, levels = feature_names)

  ggplot(long_df, aes(x = Dimension, y = Value, group = ID, color = reliability)) +
    geom_line(alpha = 0.45, linewidth = 0.70) +
    geom_point(alpha = 0.6, size = 1.3) +
    scale_color_viridis_c(option = "viridis", name = "Fidelity S_i") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 25, hjust = 1, face = "bold", size = 10),
      panel.grid.major.x = element_line(color = "grey60", linetype = "dashed"),
      panel.grid.minor = element_blank()
    ) +
    labs(title = "Technique 5: Parallel Coordinates Plot (PCP) with Fidelity-Viridis Tracing",
         subtitle = "High-D feature profiles colored by 2D projection fidelity (purple = distorted, yellow = faithful)",
         x = "High-Dimensional Marker / Feature Axes", y = "Normalized Attribute Value [0, 1]")
}

#' 6. Co-Ranking Distortion Matrix Heatmap (Lee & Verleysen, 2009)
render_coranking_matrix_plot <- function(dataset_obj) {
  orig <- as.matrix(dataset_obj$orig)
  emb <- as.matrix(dataset_obj$emb_annotated[, c("x", "y")])
  n <- nrow(orig)

  if (n > 200) {
    set.seed(42)
    idx <- sample(seq_len(n), 200)
    orig <- orig[idx, , drop = FALSE]
    emb <- emb[idx, , drop = FALSE]
    n <- 200
  }

  D_orig <- as.matrix(dist(orig))
  D_emb <- as.matrix(dist(emb))
  diag(D_orig) <- Inf
  diag(D_emb) <- Inf

  R_orig <- apply(D_orig, 1, rank)
  R_emb <- apply(D_emb, 1, rank)

  bins <- 20
  bin_orig <- cut(as.vector(R_orig), breaks = seq(0, n, length.out = bins + 1), labels = FALSE)
  bin_emb <- cut(as.vector(R_emb), breaks = seq(0, n, length.out = bins + 1), labels = FALSE)

  tab <- table(factor(bin_orig, levels = 1:bins), factor(bin_emb, levels = 1:bins))
  mat_df <- as.data.frame(tab)
  colnames(mat_df) <- c("Rank_Orig", "Rank_Emb", "Count")
  mat_df$Rank_Orig <- as.numeric(mat_df$Rank_Orig)
  mat_df$Rank_Emb <- as.numeric(mat_df$Rank_Emb)
  mat_df$LogCount <- log1p(mat_df$Count)

  ggplot(mat_df, aes(x = Rank_Emb, y = Rank_Orig, fill = LogCount)) +
    geom_tile(color = "white", linewidth = 0.2) +
    geom_abline(slope = 1, intercept = 0, color = "#ef4444", linetype = "dashed", linewidth = 0.8) +
    scale_fill_viridis_c(option = "magma", name = "Density") +
    theme_minimal() +
    labs(title = "Technique 6: Co-Ranking Distortion Matrix Heatmap",
         subtitle = "Diagonal = perfect rank preservation; Off-diagonal upper/lower = intrusions vs tears",
         x = "Embedding Rank (2D Projection)", y = "Original Space Rank (High-D)")
}

#' 7. Shepard Distance-Distance Distortion Diagram
render_shepard_plot <- function(dataset_obj) {
  orig <- as.matrix(dataset_obj$orig)
  emb <- as.matrix(dataset_obj$emb_annotated[, c("x", "y")])
  n <- nrow(orig)

  set.seed(42)
  n_pairs <- min(1500, n * (n - 1) / 2)
  i_idx <- sample(seq_len(n), n_pairs, replace = TRUE)
  j_idx <- sample(seq_len(n), n_pairs, replace = TRUE)
  diff_mask <- i_idx != j_idx
  i_idx <- i_idx[diff_mask]
  j_idx <- j_idx[diff_mask]

  d_high <- sqrt(rowSums((orig[i_idx, , drop = FALSE] - orig[j_idx, , drop = FALSE])^2))
  d_low <- sqrt(rowSums((emb[i_idx, , drop = FALSE] - emb[j_idx, , drop = FALSE])^2))

  d_high_norm <- (d_high - min(d_high)) / (diff(range(d_high)) + 1e-6)
  d_low_norm <- (d_low - min(d_low)) / (diff(range(d_low)) + 1e-6)

  df_pairs <- data.frame(HighD = d_high_norm, LowD = d_low_norm)

  ggplot(df_pairs, aes(x = HighD, y = LowD)) +
    geom_point(alpha = 0.35, color = "#3b82f6", size = 1.2) +
    geom_smooth(method = "loess", color = "#ef4444", se = TRUE, linewidth = 1.0) +
    geom_abline(slope = 1, intercept = 0, color = "grey40", linetype = "dashed") +
    theme_minimal() +
    labs(title = "Technique 7: Shepard Distance Distortion Diagram",
         subtitle = "Pairwise high-D vs low-D distance scatter: Curvature reveals non-linear metric compression",
         x = "Normalized Original High-D Pairwise Distance", y = "Normalized 2D Projection Distance")
}
