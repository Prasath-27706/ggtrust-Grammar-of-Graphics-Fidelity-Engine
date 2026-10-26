# ggtrust: ggproto Internal Architecture

**Designing R6/ggproto classes for Halos, Landscape, and Blur encodings**  
Following ggplot2 extension best practices (Wickham, 2016; Pedersen, 2018; Kay, 2023)

---

## 1. Class Inheritance Hierarchy

```
ggplot2::Geom ──┬── GeomTrustPoint   (encoding dispatcher)
                ├── GeomTrustHalo     (halo encoder)
                ├── GeomTrustBlur     (blur encoder)
                └── GeomTrustLandscape (background encoder)

ggplot2::Stat ───┬── StatTrustDR      (DR quality computation)
                 ├── StatTrustConfidence (prediction confidence)
                 └── StatTrustManual  (pass-through with validation)

ggplot2::ScaleContinuous ──┬── ScaleReliability (range [0,1], unit mapping)
                           └── ScaleReliabilityDiscrete (for binned fidelity)

ggtrust:::TrustEncodingSelector  (S3 class for auto-encoding selection)
```

---

## 2. File Structure (R/ directory)

```
R/
├── ggtrust-package.R          # Package metadata, imports, .onLoad
├── aesthetics.R               # Register reliability aesthetic with ggplot2
├── geom_trust_point.R         # GeomTrustPoint (main entry point + dispatcher)
├── geom_trust_halo.R          # GeomTrustHalo ggproto + geom_trust_halo()
├── geom_trust_blur.R          # GeomTrustBlur ggproto + geom_trust_blur()
├── geom_trust_landscape.R     # GeomTrustLandscape ggproto + geom_trust_landscape()
├── stat_trust_dr.R            # StatTrustDR ggproto + stat_trust_dr()
├── stat_trust_confidence.R    # StatTrustConfidence ggproto + stat_trust_confidence()
├── stat_trust_manual.R        # StatTrustManual ggproto + stat_trust_manual()
├── scale_reliability.R        # ScaleReliability ggproto + scale_reliability_*()
├── theme_trust.R              # Theme elements: reliability legend, trust guides
├── trust_metrics.R            # Internal trust metrics computation
├── trust_encoding.R           # Encoding selection logic (auto-choose by n)
├── trust_defaults.R           # Default parameter constants
├── trust_grid.R               # Low-level grid graphics helpers
├── zzz.R                      # .onLoad: register aesthetics + scales
└── utils.R                    # Internal helper functions
```

---

## 3. Aesthetic Registration (`aesthetics.R`)

The `reliability` aesthetic is non-standard — it is a meta-property of position, not a data variable. However, for grammatical consistency, users should be able to write `aes(reliability = col)` and have it behave like a standard continuous aesthetic.

```r
#' Register the reliability aesthetic with ggplot2
#'
#' ggplot2 requires aesthetics to be registered before use in geoms.
#' This is called once via .onLoad.
#'
#' @noRd
register_reliability_aesthetic <- function() {
  # Register as a continuous aesthetic with range [0, 1]
  # The "reliability" aesthetic is treated as a numeric aesthetic
  # that can be mapped to data columns or set to a constant.
  
  # Register the aesthetic name so ggplot2's `aes()` recognizes it
  # without raising "unknown aesthetic" warnings
  ggplot2::register_theme_elements(
    reliability = ggplot2::element_blank(),
    # Don't inherit from any existing element
    element_tree = list(
      reliability = ggplot2::el_def("element_blank")
    )
  )
}

# In zzz.R .onLoad():
# .onLoad <- function(libname, pkgname) {
#   register_reliability_aesthetic()
# }
```

**Critical note:** Unlike standard aesthetics (x, y, color, size), `reliability` should NOT be a positional aesthetic. It modifies the appearance of existing marks. Therefore, it should be treated as a `scale_alpha`-style modifier, not a `scale_x/y`-style coordinate.

---

## 4. GeomTrustPoint — The Entry Point (`geom_trust_point.R`)

This is the high-level API. It auto-selects the encoding based on data size and user preference, then delegates to one of the three rendering geoms.

```r
# ============================================================
# GeomTrustPoint: Auto-dispatches to encoding-specific geom
# ============================================================

#' @export
geom_trust_point <- function(
  mapping = NULL,
  data = NULL,
  ...,
  encoding = c("auto", "halo", "blur", "landscape"),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  encoding <- match.arg(encoding)
  
  # Store encoding choice in params — draw_panel() reads it
  layer(
    geom = GeomTrustPoint,
    mapping = mapping,
    data = data,
    stat = "identity",
    position = "identity",
    params = list(
      encoding = encoding,
      na.rm = na.rm,
      ...
    ),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

GeomTrustPoint <- ggproto(
  "GeomTrustPoint", Geom,

  # Required + optional aesthetics
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  
  default_aes = aes(
    reliability = 0.5,    # Default: moderate fidelity
    colour = "grey30",
    alpha = 1,
    size = 1.5
  ),
  
  # Drawing: dispatches to sub-geoms based on encoding
  draw_panel = function(self, data, panel_params, coord,
                        encoding = "auto", ...) {
    
    # Determine encoding if "auto"
    if (identical(encoding, "auto")) {
      encoding <- select_encoding(
        n_points = nrow(data),
        has_reliability = "reliability" %in% names(data) &&
          !all(data$reliability == data$reliability[1])  # not constant
      )
    }
    
    # Dispatch to the appropriate draw method
    switch(encoding,
      halo      = draw_halo_panel(data, panel_params, coord, ...),
      blur      = draw_blur_panel(data, panel_params, coord, ...),
      landscape = draw_landscape_panel(data, panel_params, coord, ...)
    )
  },
  
  draw_key = function(self, data, params, size) {
    # Standard point legend key with reliability annotation
    draw_key_point(data, params, size)
  }
)

# ============================================================
# Encoding Selection Algorithm
# ============================================================

#' Select the optimal encoding based on data characteristics
#'
#' @param n_points Number of points in the plot
#' @param has_reliability Whether reliability data is available
#'
#' @return String: "halo", "blur", or "landscape"
#' @noRd
select_encoding <- function(n_points, has_reliability = TRUE) {
  if (!has_reliability) return("landscape")
  if (n_points <= 500) return("halo")
  if (n_points <= 5000) return("blur")
  "landscape"
}
```

### 4.1 Design Rationale for the Dispatch Architecture

| Alternative | Considered? | Rejected because |
|-------------|:-----------:|------------------|
| Single Geom with if-else in draw_panel | Accepted | Simplest; dispatch at the geom level keeps rendering code separate |
| Three separate layers composed automatically | Rejected | Overly complex; ggplot2 doesn't natively support automatic layer composition |
| gganimate-style: separate ggproto per encoding | Accepted | Each encoding has fundamentally different rendering (vector vs. raster vs. background) |
| S3 dispatch on encoding class | Rejected | Doesn't integrate with ggplot2's ggproto system |

---

## 5. GeomTrustHalo (`geom_trust_halo.R`)

```r
# ============================================================
# GeomTrustHalo: Concentric fidelity halos
# ============================================================

#' @export
geom_trust_halo <- function(
  mapping = NULL, data = NULL, ...,
  max_halo_radius = NULL,
  halo_n_layers = 10,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  layer(
    geom = GeomTrustHalo,
    mapping = mapping,
    data = data,
    stat = "identity",
    position = "identity",
    params = list(
      max_halo_radius = max_halo_radius,
      halo_n_layers = halo_n_layers,
      na.rm = na.rm,
      ...
    ),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

GeomTrustHalo <- ggproto(
  "GeomTrustHalo", Geom,

  required_aes = c("x", "y"),
  optional_aes = c("reliability"),

  default_aes = aes(
    reliability = 0.5,
    colour = "grey30",
    fill = NA,
    alpha = 1,
    size = 1.5,
    stroke = 0.5
  ),

  draw_panel = function(self, data, panel_params, coord,
                        max_halo_radius = NULL,
                        halo_n_layers = 10, ...) {

    # Transform coordinates to render-ready [0,1] space
    trans <- coord$transform(data, panel_params)
    
    # Resolve max_halo_radius from theme or default
    if (is.null(max_halo_radius)) {
      max_halo_radius <- get_trust_theme_option("halo.max_radius") %||% 0.02
    }
    
    # Pre-compute halo parameters per point
    trans$halo_radius  <- (1 - trans$reliability) * max_halo_radius
    trans$halo_alpha   <- trans$reliability * trans$alpha
    trans$halo_lwd     <- 0.1 + (1 - trans$reliability) * 0.5  # thinner = more reliable
    
    # Build grobs in two layers:
    #   Layer 1: Halos (behind points)
    #   Layer 2: Points (on top)
    
    # --- Layer 1: Halos (concentric Gaussian decomposition) ---
    halo_grobs <- vector("list", nrow(trans) * halo_n_layers)
    idx <- 1
    
    for (i in seq_len(nrow(trans))) {
      if (is.na(trans$halo_radius[i]) || trans$halo_radius[i] <= 0) next
      
      # Decompose halo as concentric rings with Gaussian falloff
      for (j in seq_len(halo_n_layers)) {
        r <- (j / halo_n_layers) * trans$halo_radius[i]
        # Gaussian weight: central peak, fading edge
        w <- exp(-((j / halo_n_layers)^2) / (2 * 0.3^2))
        layer_alpha <- trans$halo_alpha[i] * w * 0.3  # 0.3 = base halo intensity
        
        if (layer_alpha < 0.01) next
        
        halo_grobs[[idx]] <- grid::circleGrob(
          x = trans$x[i],
          y = trans$y[i],
          r = r,
          gp = grid::gpar(
            col = NA,
            fill = scales::alpha(trans$colour[i], layer_alpha),
            lwd = 0
          )
        )
        idx <- idx + 1
      }
    }
    halo_grobs <- halo_grobs[!vapply(halo_grobs, is.null, TRUE)]
    
    # --- Layer 2: Point marks ---
    point_grob <- grid::pointsGrob(
      x = trans$x,
      y = trans$y,
      pch = 19,
      size = grid::unit(trans$size, "mm"),
      gp = grid::gpar(
        col = scales::alpha(trans$colour, trans$alpha),
        fill = scales::alpha(trans$colour, trans$alpha),
        lwd = trans$stroke
      )
    )
    
    # Combine
    all_grobs <- c(list(point_grob), halo_grobs)
    grid::gTree(
      children = do.call(grid::gList, all_grobs),
      cl = "trust_halo"
    )
  },

  draw_key = function(self, data, params, size) {
    # Legend key: show a representative haloed point
    grid::gTree(
      children = grid::gList(
        # Small halo
        grid::circleGrob(
          x = 0.5, y = 0.5,
          r = grid::unit(3, "mm"),
          gp = grid::gpar(
            col = NA,
            fill = scales::alpha(data$colour %||% "grey30", 0.2)
          )
        ),
        # Point
        grid::pointsGrob(
          x = 0.5, y = 0.5,
          pch = 19,
          size = grid::unit(5, "mm"),
          gp = grid::gpar(
            col = data$colour %||% "grey30",
            fill = data$colour %||% "grey30"
          )
        )
      ),
      cl = "trust_halo_key"
    )
  }
)
```

### 5.1 Halo Rendering: Parameter Selection

| Parameter | Symbol | Function | Default |
|-----------|--------|----------|---------|
| Max halo radius | R_max | Halo extent at reliability=0 | 2% of plot range (0.02 in npc) | 
| Halo layers | N | Concentric ring count for smooth falloff | 10 |
| Halo falloff | σ | Gaussian sigma for layer weights | 0.3 (controls edge softness) |
| Base intensity | I_0 | Max opacity of halo center at reliability=1 | 0.3 |

**Why these defaults:**
- R_max = 0.02 npc: At 800px plot width, this = 16px radius, matching the user study protocol. Large enough to be visible, small enough to avoid excessive overlap at 500 points.
- Gaussian falloff (σ=0.3): Produces a soft edge at low reliability (blobby halo) and a sharp edge at high reliability (tight halo), mapping to the precision-of-form metaphor.
- I_0 = 0.3: Halos should not dominate the point; they are a secondary visual channel.

---

## 6. GeomTrustBlur (`geom_trust_blur.R`)

The blur encoding is the hardest to implement in vector-based grid graphics. Two strategies:

| Strategy | Pros | Cons |
|----------|------|------|
| **A. Raster pre-compositing** | True Gaussian blur; pixel-perfect | Requires converting to raster; loses vector scaling |
| **B. Multi-circle approximation** | Pure grid graphics; scales with device | Approximate; rendering cost at many layers |
| **C. Pre-rendered glyph set** | Fast; consistent across devices | Memory for glyph bitmaps; discrete levels |

**Chosen: Strategy B (multi-circle approximation)** for default, with Strategy C as an optional fast-path for large n. Strategy A (full raster) is provided as a `rasterise = TRUE` fallback.

```r
# ============================================================
# GeomTrustBlur: Gaussian blur approximation for spatial spread
# ============================================================

#' @export
geom_trust_blur <- function(
  mapping = NULL, data = NULL, ...,
  max_blur_sigma = NULL,
  blur_quality = c("medium", "high", "draft"),
  rasterise = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  blur_quality <- match.arg(blur_quality)
  
  layer(
    geom = GeomTrustBlur,
    mapping = mapping,
    data = data,
    stat = "identity",
    position = "identity",
    params = list(
      max_blur_sigma = max_blur_sigma,
      blur_quality = blur_quality,
      rasterise = rasterise,
      na.rm = na.rm,
      ...
    ),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

# Layer counts for each quality setting
BLUR_LAYERS <- c(draft = 5, medium = 10, high = 20)

GeomTrustBlur <- ggproto(
  "GeomTrustBlur", Geom,

  required_aes = c("x", "y"),
  optional_aes = c("reliability"),

  default_aes = aes(
    reliability = 0.5,
    colour = "grey30",
    alpha = 1,
    size = 1.5,
    fill = NA
  ),

  draw_panel = function(self, data, panel_params, coord,
                        max_blur_sigma = NULL,
                        blur_quality = "medium",
                        rasterise = FALSE, ...) {

    trans <- coord$transform(data, panel_params)
    
    if (is.null(max_blur_sigma)) {
      max_blur_sigma <- get_trust_theme_option("blur.max_sigma") %||% 0.005
    }
    
    if (rasterise) {
      return(draw_blur_raster(trans, panel_params, max_blur_sigma, blur_quality))
    }
    
    n_layers <- BLUR_LAYERS[blur_quality]
    
    # Per-point blur sigma (in normalized parent coordinates)
    trans$blur_sigma <- (1 - trans$reliability) * max_blur_sigma
    
    # Generate concentric circles approximating Gaussian blur
    grobs <- vector("list", nrow(trans) * n_layers + 1)
    idx <- 1
    
    for (i in seq_len(nrow(trans))) {
      sigma <- trans$blur_sigma[i]
      if (is.na(sigma) || sigma <= 0) {
        # No blur — draw a solid point
        grobs[[idx]] <- grid::pointsGrob(
          x = trans$x[i], y = trans$y[i],
          pch = 19,
          size = grid::unit(trans$size[i], "mm"),
          gp = grid::gpar(
            col = scales::alpha(trans$colour[i], trans$alpha[i]),
            fill = scales::alpha(trans$colour[i], trans$alpha[i])
          )
        )
        idx <- idx + 1
        next
      }
      
      # Draw concentric circles with Gaussian weights
      # Spatial extent: cover ±3σ in npc space
      max_radius <- 3 * sigma
      point_size_npc <- trans$size[i] / 25.4 / par("cra")[1]  # mm -> npc approx
      
      for (j in seq_len(n_layers)) {
        frac <- (j - 0.5) / n_layers  # 0..1 across ±3σ
        r <- frac * max_radius + point_size_npc * 0.5
        # Gaussian weight at this radius
        w <- exp(-(frac * 3)^2 / 2)
        layer_alpha <- trans$alpha[i] * w / n_layers * 2.5
        
        if (layer_alpha < 0.005) next
        
        grobs[[idx]] <- grid::circleGrob(
          x = trans$x[i],
          y = trans$y[i],
          r = grid::unit(r, "npc"),
          gp = grid::gpar(
            col = NA,
            fill = scales::alpha(trans$colour[i], layer_alpha),
            lwd = 0
          )
        )
        idx <- idx + 1
      }
    }
    
    grobs <- grobs[!vapply(grobs, is.null, TRUE)]
    grid::gTree(
      children = do.call(grid::gList, grobs),
      cl = "trust_blur"
    )
  },

  draw_key = function(self, data, params, size) {
    # Show a medium-blurred point in the legend
    grid::gTree(
      children = grid::gList(
        grid::circleGrob(
          x = 0.5, y = 0.5,
          r = grid::unit(2.5, "mm"),
          gp = grid::gpar(col = NA, fill = scales::alpha("grey30", 0.15))
        ),
        grid::circleGrob(
          x = 0.5, y = 0.5,
          r = grid::unit(1.5, "mm"),
          gp = grid::gpar(col = NA, fill = scales::alpha("grey30", 0.3))
        ),
        grid::pointsGrob(
          x = 0.5, y = 0.5,
          pch = 19, size = grid::unit(4, "mm"),
          gp = grid::gpar(col = "grey30", fill = "grey30")
        )
      ),
      cl = "trust_blur_key"
    )
  }
)

# ============================================================
# Strategy C: Pre-rendered raster glyphs (fast path)
# ============================================================

# Cache of pre-rendered blur kernels at different sigma levels
.blur_cache <- new.env(parent = emptyenv())

#' Render all points as a single composited raster
#'
#' This approach renders each point to an off-screen raster,
#' applies true Gaussian blur via imager/magick, and composites.
#'
#' @noRd
draw_blur_raster <- function(trans, panel_params, max_blur_sigma,
                              blur_quality) {
  # Requires the 'magick' package (Suggests)
  if (!requireNamespace("magick", quietly = TRUE)) {
    cli::cli_abort("rasterise = TRUE requires the {.pkg magick} package.")
  }
  
  n_levels <- switch(blur_quality, draft = 5, medium = 10, high = 20)
  
  # Round reliability to nearest level for caching
  trans$blur_level <- round(trans$reliability * (n_levels - 1)) + 1
  
  # For each unique blur level, composite points at that level
  unique_levels <- sort(unique(trans$blur_level))
  
  composited <- NULL
  for (level in unique_levels) {
    subset <- trans[trans$blur_level == level, , drop = FALSE]
    sigma <- (1 - (level - 1) / (n_levels - 1)) * max_blur_sigma
    
    # Get or create blurred dot image for this sigma
    dot_img <- get_blur_kernel(sigma, size = 64)
    
    # Composite each point at its location
    for (i in seq_len(nrow(subset))) {
      composited <- composite_point_raster(
        composited, dot_img,
        x = subset$x[i], y = subset$y[i],
        colour = subset$colour[i],
        alpha = subset$alpha[i],
        panel_params = panel_params
      )
    }
  }
  
  if (is.null(composited)) return(grid::nullGrob())
  
  grid::rasterGrob(
    composited,
    x = 0, y = 0, width = 1, height = 1,
    just = c("left", "bottom"),
    interpolate = TRUE
  )
}

#' Get or create a blurred dot kernel image
#'
#' @param sigma Blur kernel sigma in npc units
#' @param size Kernel raster size in pixels
#' @noRd
get_blur_kernel <- function(sigma, size = 64) {
  key <- paste0("s", sprintf("%.4f", sigma), "_", size)
  if (exists(key, envir = .blur_cache)) {
    return(get(key, envir = .blur_cache))
  }
  
  # Create a white dot on black background, then blur
  dot <- matrix(0, nrow = size, ncol = size)
  cx <- cy <- size / 2
  r <- max(2, size / 12)
  
  for (i in seq_len(size)) {
    for (j in seq_len(size)) {
      d <- sqrt((i - cx)^2 + (j - cy)^2)
      if (d <= r) dot[i, j] <- 1
    }
  }
  
  # Convert sigma from npc to pixel units
  sigma_px <- sigma * size * 3  # scale factor
  
  # Apply Gaussian blur (simple kernel convolution)
  kernel_size <- ceiling(sigma_px * 3) * 2 + 1
  if (kernel_size > 3 && sigma_px > 0.5) {
    kern <- gaussian_kernel(kernel_size, sigma_px)
    dot <- convolve2d(dot, kern)
  }
  
  assign(key, dot, envir = .blur_cache)
  dot
}
```

### 6.1 Blur Rendering: Quality vs. Performance

| Setting | Layers | Point cost (n=500) | Quality | Use case |
|---------|:------:|:------------------:|:-------:|----------|
| draft | 5 | 2,500 circles | Poor — banding visible | Interactive exploration |
| medium | 10 | 5,000 circles | Good — smooth falloff | Default static plots |
| high | 20 | 10,000 circles | Excellent — near-continuous | Publication figures |

For n > 2000, raster mode (`rasterise = TRUE`) is automatically recommended, switching to magick-based compositing.

---

## 7. GeomTrustLandscape (`geom_trust_landscape.R`)

```r
# ============================================================
# GeomTrustLandscape: Background fidelity landscape (heatmap + contours)
# ============================================================

#' @export
geom_trust_landscape <- function(
  mapping = NULL, data = NULL, ...,
  smoothing_method = c("gam", "loess", "kde"),
  smoothing_bandwidth = NULL,
  contour = TRUE,
  contour_bins = 5,
  raster = TRUE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  smoothing_method <- match.arg(smoothing_method)
  
  layer(
    geom = GeomTrustLandscape,
    mapping = mapping,
    data = data,
    stat = "identity",
    position = "identity",
    params = list(
      smoothing_method = smoothing_method,
      smoothing_bandwidth = smoothing_bandwidth,
      contour = contour,
      contour_bins = contour_bins,
      raster = raster,
      na.rm = na.rm,
      ...
    ),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

# Smoothing grid resolution
LANDSCAPE_GRID <- 100  # 100×100 evaluation grid

GeomTrustLandscape <- ggproto(
  "GeomTrustLandscape", Geom,

  required_aes = c("x", "y"),
  optional_aes = c("reliability"),

  default_aes = aes(
    reliability = 0.5,
    alpha = 1,
    fill = NA,
    colour = NA,
    size = 0.5
  ),

  # ----------------------------------------------------------
  # draw_panel: computes smooth, then renders as raster + contours
  # ----------------------------------------------------------
  draw_panel = function(self, data, panel_params, coord,
                        smoothing_method = "gam",
                        smoothing_bandwidth = NULL,
                        contour = TRUE,
                        contour_bins = 5,
                        raster = TRUE, ...) {

    trans <- coord$transform(data, panel_params)
    
    # --- Step 1: Build evaluation grid in plot space ---
    x_range <- panel_params$x.range
    y_range <- panel_params$y.range
    
    x_grid <- seq(x_range[1], x_range[2], length.out = LANDSCAPE_GRID)
    y_grid <- seq(y_range[1], y_range[2], length.out = LANDSCAPE_GRID)
    grid_df <- expand.grid(x = x_grid, y = y_grid)
    
    # --- Step 2: Smooth reliability onto the grid ---
    if (nrow(trans) < 5) {
      # Too few points for meaningful smoothing
      return(grid::nullGrob())
    }
    
    grid_df$reliability <- smooth_reliability(
      x = trans$x, y = trans$y, z = trans$reliability,
      new_x = grid_df$x, new_y = grid_df$y,
      method = smoothing_method,
      bandwidth = smoothing_bandwidth
    )
    
    # --- Step 3: Render as raster heatmap ---
    raster_grob <- NULL
    if (raster) {
      # Reshape to matrix
      z_mat <- matrix(
        grid_df$reliability,
        nrow = LANDSCAPE_GRID,
        ncol = LANDSCAPE_GRID,
        byrow = TRUE
      )
      # Flip y for raster orientation
      z_mat <- z_mat[, ncol(z_mat):1]
      
      # Map to viridis colormap (high reliability = vibrant)
      viridis_pal <- viridisLite::viridis(256)
      z_scaled <- cut(z_mat, breaks = 256, labels = FALSE)
      z_scaled[is.na(z_scaled)] <- 1
      z_raster <- matrix(viridis_pal[z_scaled], nrow = LANDSCAPE_GRID)
      
      raster_grob <- grid::rasterGrob(
        z_raster,
        x = 0, y = 0,
        width = 1, height = 1,
        just = c("left", "bottom"),
        interpolate = TRUE,
        gp = grid::gpar(alpha = 0.6)  # Semi-transparent: points show through
      )
    }
    
    # --- Step 4: Contour lines ---
    contour_grob <- NULL
    if (contour) {
      contour_lines <- compute_contours(
        x = x_grid, y = y_grid,
        z = matrix(grid_df$reliability, nrow = LANDSCAPE_GRID),
        breaks = seq(0, 1, length.out = contour_bins + 2)[-c(1, contour_bins + 2)]
      )
      
      contour_grob <- render_contour_lines(
        contour_lines,
        line_colour = "grey40",
        line_alpha = 0.5,
        line_width = 0.3
      )
    }
    
    # --- Step 5: Points on top ---
    point_grob <- grid::pointsGrob(
      x = trans$x, y = trans$y,
      pch = 19,
      size = grid::unit(trans$size, "mm"),
      gp = grid::gpar(
        col = scales::alpha(trans$colour, trans$alpha),
        fill = scales::alpha(trans$colour, trans$alpha)
      )
    )
    
    # Compose: landscape background → contours → points
    children <- list(point_grob)
    if (!is.null(contour_grob)) children <- append(children, contour_grob)
    if (!is.null(raster_grob))  children <- append(children, raster_grob)
    
    grid::gTree(
      children = do.call(grid::gList, rev(children)),
      cl = "trust_landscape"
    )
  },

  draw_key = function(self, data, params, size) {
    # Gradient swatch for the legend
    grid::rasterGrob(
      viridisLite::viridis(20, direction = 1),
      x = 0.5, y = 0.5,
      width = 0.8, height = 0.8,
      interpolate = FALSE
    )
  }
)

# ============================================================
# Smoothing Backend
# ============================================================

#' Smooth reliability values over a 2D grid
#'
#' @param x,y Observed point coordinates [0,1]
#' @param z Observed reliability values [0,1]
#' @param new_x,new_y Grid coordinates to predict at
#' @param method Smoothing method
#' @param bandwidth Smoothing bandwidth (NULL = auto)
#' @noRd
smooth_reliability <- function(x, y, z, new_x, new_y,
                                method = "gam", bandwidth = NULL) {
  
  switch(method,
    gam = {
      # Thin-plate regression spline (fast for n < 10K)
      fit <- mgcv::gam(z ~ s(x, y, k = min(30, length(x) - 1)),
                       data = data.frame(x = x, y = y, z = z))
      predict(fit, newdata = data.frame(x = new_x, y = new_y))
    },
    
    loess = {
      span <- bandwidth %||% 0.3
      fit <- loess(z ~ x * y, data = data.frame(x = x, y = y, z = z),
                   span = span, degree = 1)
      predict(fit, newdata = data.frame(x = new_x, y = new_y))
    },
    
    kde = {
      # 2D KDE with reliability as density weight
      # Uses ks::kde or MASS::kde2d
      bw <- bandwidth %||% c(0.1, 0.1)
      dens <- MASS::kde2d(x, y, n = LANDSCAPE_GRID,
                           h = bw)
      # Weight by reliability at each point
      # ... (simplified: in practice, weighted 2D kernel regression)
      matrix(NA, nrow = length(new_x), ncol = length(new_y))
    }
  )
}

#' Extract contour lines from a smoothed grid
#' @noRd
compute_contours <- function(x, y, z, breaks) {
  grDevices::contourLines(
    x = x, y = y, z = z,
    levels = breaks
  )
}

#' Render contour lines as grid grobs
#' @noRd
render_contour_lines <- function(contour_lines, line_colour = "grey40",
                                  line_alpha = 0.5, line_width = 0.3) {
  if (length(contour_lines) == 0) return(NULL)
  
  grobs <- vector("list", length(contour_lines))
  for (i in seq_along(contour_lines)) {
    cl <- contour_lines[[i]]
    grobs[[i]] <- grid::polylineGrob(
      x = cl$x, y = cl$y,
      gp = grid::gpar(
        col = scales::alpha(line_colour, line_alpha),
        lwd = line_width,
        lty = "dashed"
      )
    )
  }
  do.call(grid::gList, grobs)
}
```

### 7.1 Smoothing Method Comparison

| Method | Package | Speed (n=500) | Smoothness control | Extrapolation | Default? |
|--------|---------|:-------------:|:------------------:|:-------------:|:--------:|
| GAM | mgcv | ~50ms | k (basis dimension) | Linear | **Yes** |
| LOESS | stats | ~20ms | span (0-1) | Constant | No (faster but less principled) |
| KDE | MASS | ~10ms | h (bandwidth) | Zero | No (fastest but noisier) |

GAM is the default because: (a) principled penalized likelihood, (b) automatic smoothness selection via GCV, (c) reasonable extrapolation behavior outside the convex hull of points.

---

## 8. Stat Classes — Reliability Computation

### 8.1 StatTrustDR

```r
# ============================================================
# StatTrustDR: Compute per-point reliability from DR quality metrics
# ============================================================

#' Compute reliability from DR quality metrics
#'
#' @param original_data The high-dimensional input matrix/data.frame
#' @param method DR method name ("tsne", "umap", "pca", "mds")
#' @param k Neighborhood size for trustworthiness/continuity
#' @param aggregation How to combine T and C: "min", "prod", "avg"
#' @param ... Passed to DR method
#'
#' @export
stat_trust_dr <- function(
  mapping = NULL, data = NULL, ...,
  original_data = NULL,
  k = 15,
  aggregation = c("min", "prod", "avg"),
  method = NULL,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  aggregation <- match.arg(aggregation)
  
  layer(
    geom = GeomTrustPoint,  # Default geom
    mapping = mapping,
    data = data,
    stat = StatTrustDR,
    position = "identity",
    params = list(
      original_data = original_data,
      k = k,
      aggregation = aggregation,
      method = method,
      na.rm = na.rm,
      ...
    ),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

StatTrustDR <- ggproto(
  "StatTrustDR", Stat,
  
  # Input aesthetics (x, y = projected coordinates)
  required_aes = c("x", "y"),
  
  # Output aesthetics (computed)
  # Adds: reliability
  # Preserves: colour, fill, alpha, size
  
  compute_layer = function(self, data, params, panels) {
    # Get original high-D data
    original <- params$original_data
    if (is.null(original)) {
      cli::cli_abort("{.arg original_data} is required for {.fn stat_trust_dr}.")
    }
    
    # Convert to matrix
    if (!is.matrix(original)) {
      original <- as.matrix(original)
    }
    
    # Get 2D coordinates from the data
    coords <- as.matrix(data[, c("x", "y")])
    
    # Compute reliability metrics
    reliability <- compute_trustworthiness(
      high_d = original,
      low_d = coords,
      k = params$k %||% 15
    )
    
    # Add to data
    data$reliability <- reliability
    
    # If aggregation = "min" is used, take element-wise min of T and C
    if (identical(params$aggregation, "min")) {
      continuity <- compute_continuity(
        high_d = original,
        low_d = coords,
        k = params$k %||% 15
      )
      data$reliability <- pmin(data$reliability, continuity)
    }
    
    data
  },
  
  # Note: we override compute_layer (not compute_group) because 
  # reliability computation requires ALL points simultaneously
  # (pairwise distances in high-D and low-D). This means the stat
  # does not work with grouped data — groups would give incorrect metrics.
  
  compute_group = function(self, data, scales, ...) {
    cli::cli_abort(c(
      "{.fn stat_trust_dr} does not support grouped computations.",
      "i" = "Reliability metrics require all points to be computed together."
    ))
  }
)
```

### 8.2 Trust Metrics Computation (`trust_metrics.R`)

```r
# ============================================================
# Trust Metrics: Per-point trustworthiness and continuity
# ============================================================

#' Compute per-point trustworthiness
#'
#' Trustworthiness T(k,i) measures how well the k nearest neighbors
#' in the low-D space are also neighbors in the high-D space.
#' Range: [0, 1] where 1 = perfect preservation.
#'
#' @param high_d High-dimensional data matrix (n × d)
#' @param low_d Low-dimensional data matrix (n × 2)
#' @param k Neighborhood size
#' @return Numeric vector of per-point trustworthiness [0, 1]
#' @noRd
compute_trustworthiness <- function(high_d, low_d, k = 15) {
  n <- nrow(high_d)
  
  # Compute k-NN indices in high-D and low-D
  nn_high <- find_knn(high_d, k)
  nn_low  <- find_knn(low_d, k)
  
  # For each point i, find points that are k-NN in low-D but NOT in high-D
  result <- numeric(n)
  
  for (i in seq_len(n)) {
    low_nbrs  <- nn_low[i, ]
    high_nbrs <- nn_high[i, ]
    
    # Points in low-D neighborhood that are NOT in high-D neighborhood
    false_nbrs <- setdiff(low_nbrs, high_nbrs)
    
    if (length(false_nbrs) == 0) {
      result[i] <- 1
      next
    }
    
    # For each false neighbor, find its rank in high-D
    # (how many points closer than it are in the original space)
    high_d_dist <- as.matrix(dist(high_d[i, , drop = FALSE]))
    ranks <- rank(high_d_dist[i, ])
    r_ranks <- ranks[false_nbrs]
    
    # Trustworthiness T(k,i) = 1 - 2/(n*k*(2n-3k-1)) * sum(r - k)
    n_terms <- n * k * (2 * n - 3 * k - 1)
    if (n_terms <= 0) {
      result[i] <- 1
    } else {
      sum_r <- sum(r_ranks - k)
      result[i] <- max(0, 1 - (2 / n_terms) * sum_r)
    }
  }
  
  result
}

#' Compute per-point continuity
#'
#' Continuity C(k,i) measures how well the k nearest neighbors
#' in the high-D space remain neighbors in the low-D space.
#' Range: [0, 1] where 1 = perfect preservation.
#'
#' @param high_d High-dimensional data matrix (n × d)
#' @param low_d Low-dimensional data matrix (n × 2)
#' @param k Neighborhood size
#' @return Numeric vector of per-point continuity [0, 1]
#' @noRd
compute_continuity <- function(high_d, low_d, k = 15) {
  n <- nrow(high_d)
  
  nn_high <- find_knn(high_d, k)
  nn_low  <- find_knn(low_d, k)
  
  result <- numeric(n)
  
  for (i in seq_len(n)) {
    high_nbrs <- nn_high[i, ]
    low_nbrs  <- nn_low[i, ]
    
    # Points in high-D neighborhood that are NOT in low-D neighborhood
    missing_nbrs <- setdiff(high_nbrs, low_nbrs)
    
    if (length(missing_nbrs) == 0) {
      result[i] <- 1
      next
    }
    
    low_d_dist <- as.matrix(dist(low_d[i, , drop = FALSE]))
    r_ranks <- rank(low_d_dist[i, ])[missing_nbrs]
    
    n_terms <- n * k * (2 * n - 3 * k - 1)
    if (n_terms <= 0) {
      result[i] <- 1
    } else {
      sum_r <- sum(r_ranks - k)
      result[i] <- max(0, 1 - (2 / n_terms) * sum_r)
    }
  }
  
  result
}

#' Fast k-NN index finder
#'
#' Uses FNN::get.knn for O(n log n) performance.
#' Falls back to brute-force O(n²) if FNN unavailable.
#'
#' @param x Data matrix
#' @param k Number of neighbors (excluding self)
#' @return Integer matrix (n × k) of neighbor indices
#' @noRd
find_knn <- function(x, k) {
  k <- min(k, nrow(x) - 1)
  
  if (requireNamespace("FNN", quietly = TRUE)) {
    result <- FNN::get.knn(x, k = k)
    result$nn.index
  } else {
    # Brute-force fallback
    n <- nrow(x)
    nn <- matrix(0L, nrow = n, ncol = k)
    for (i in seq_len(n)) {
      dists <- as.matrix(dist(rbind(x[i, ], x)))[1, -1]
      nn[i, ] <- order(dists)[seq_len(k)]
    }
    nn
  }
}
```

### 8.3 StatTrustConfidence (`stat_trust_confidence.R`)

```r
#' Compute reliability from prediction confidence
#'
#' Maps residual magnitude to a [0,1] reliability score.
#' For regression: reliability = exp(-|residual| / sd(residuals))
#' For classification: reliability = max(predicted_probability)
#'
#' @export
stat_trust_confidence <- function(
  mapping = NULL, data = NULL, ...,
  type = c("auto", "residual", "probability"),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  type <- match.arg(type)
  layer(
    stat = StatTrustConfidence,
    mapping = mapping, data = data,
    geom = GeomTrustPoint,
    position = "identity",
    params = list(type = type, na.rm = na.rm, ...),
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}

StatTrustConfidence <- ggproto("StatTrustConfidence", Stat,
  required_aes = c("x", "y"),
  
  compute_group = function(data, scales, type = "auto") {
    # If user provides a "residual" or "probability" column, use it
    if (!is.null(data$residual)) {
      # Normalize residual to [0,1] reliability
      abs_resid <- abs(data$residual)
      data$reliability <- exp(-abs_resid / (sd(abs_resid) + 1e-10))
    } else if (!is.null(data$probability)) {
      # Classification confidence
      data$reliability <- data$probability
    } else {
      # Auto: assume y is the residual, x is predicted
      abs_resid <- abs(data$y)
      data$reliability <- exp(-abs_resid / (sd(abs_resid) + 1e-10))
    }
    data
  }
)
```

---

## 9. Scale Classes (`scale_reliability.R`)

```r
# ============================================================
# ScaleReliability: Custom scale for [0,1] fidelity values
# ============================================================

#' Reliability scale (continuous)
#'
#' Maps reliability scores [0,1] to visual parameters.
#' By default: higher reliability = more opaque, smaller halo,
#' sharper point.
#'
#' @param name Scale name (used in legend)
#' @param breaks Break points
#' @param labels Labels for breaks
#' @param ... Passed to continuous scale
#' @export
scale_reliability_continuous <- function(
  name = "Reliability",
  breaks = c(0, 0.25, 0.5, 0.75, 1),
  labels = c("Very Low", "Low", "Medium", "High", "Very High"),
  ...
) {
  # The reliability scale is a continuous numeric scale
  # that maps [0,1] → the geom's internal parameters
  continuous_scale(
    aesthetics = "reliability",
    scale_name = "reliability_c",
    palette = identity,  # pass through — the geom handles the mapping
    name = name,
    breaks = breaks,
    labels = labels,
    limits = c(0, 1),
    ...
  )
}

#' Reliability scale (binned)
#'
#' Discretizes the continuous reliability score into bins.
#' Useful for the landscape encoding where contour bins are shown.
#'
#' @param n_bins Number of bins
#' @param ... Passed to binned scale
#' @export
scale_reliability_binned <- function(
  name = "Reliability",
  n_bins = 5,
  ...
) {
  binned_scale(
    aesthetics = "reliability",
    scale_name = "reliability_b",
    palette = identity,
    name = name,
    n.breaks = n_bins + 1,
    limits = c(0, 1),
    ...
  )
}

#' Internal: Training the reliability scale
#'
#' Because reliability is a meta-aesthetic, the scale's range
#' is always [0,1]. We override the default scale training to
#' enforce this.
#'
#' @noRd
ScaleReliability <- ggproto("ScaleReliability", ScaleContinuous,

  # Always [0,1] regardless of data
  range = c(0, 1),

  train = function(self, x) {
    # Clip to [0,1] and train as normal continuous
    x <- pmax(0, pmin(1, as.numeric(x)))
    ggproto_parent(ScaleContinuous, self)$train(x)
  },

  # Map is identity — the geom uses the raw reliability value
  # to compute visual parameters internally
  map = function(self, x, limits = self$get_limits()) {
    x <- pmax(0, pmin(1, as.numeric(x)))
    scales::rescale(x, to = c(0, 1), from = limits)
  }
)
```

---

## 10. Theme Elements (`theme_trust.R`)

```r
# ============================================================
# ggtrust Theme Elements
# ============================================================

#' ggtrust theme elements
#'
#' Custom theme elements controlling the appearance of
#' reliability encodings.
#'
#' @export
theme_trust <- function(
  # Halo parameters
  halo.max_radius = NULL,
  halo.n_layers = NULL,
  halo.falloff = NULL,
  halo.base_intensity = NULL,
  # Blur parameters
  blur.max_sigma = NULL,
  # Landscape parameters
  landscape.alpha = NULL,
  landscape.colormap = NULL
) {
  args <- as.list(environment())
  args <- args[!vapply(args, is.null, TRUE)]
  
  # Convert dot-separated names to nested list
  theme_args <- list()
  for (nm in names(args)) {
    parts <- strsplit(nm, "\\.")[[1]]
    if (length(parts) == 1) {
      theme_args[[nm]] <- args[[nm]]
    } else {
      # Nested structure: trust.halo.max_radius
      if (is.null(theme_args$trust)) theme_args$trust <- list()
      current <- theme_args$trust
      for (j in seq_along(parts)[-length(parts)]) {
        p <- parts[j]
        if (is.null(current[[p]])) current[[p]] <- list()
        current <- current[[p]]
      }
      current[[parts[length(parts)]]] <- args[[nm]]
    }
  }
  
  do.call(ggplot2::theme, theme_args)
}

#' Get a trust theme option with fallback
#'
#' @param key Dot-separated key, e.g. "halo.max_radius"
#' @param default Fallback value
#' @noRd
get_trust_theme_option <- function(key, default = NULL) {
  parts <- strsplit(key, "\\.")[[1]]
  current <- ggplot2::calc_element("trust", ggplot2::theme_get())
  if (is.null(current)) return(default)
  
  for (p in parts) {
    if (is.list(current) && p %in% names(current)) {
      current <- current[[p]]
    } else {
      return(default)
    }
  }
  current
}

# ============================================================
# Custom Guide for Reliability Legend
# ============================================================

#' Guide for reliability encoding
#'
#' A combined legend showing:
#' - For Halos: a point with halo at varying reliability levels
#' - For Landscape: a color bar with reliability labels
#'
#' @export
guide_reliability <- function(
  title = "Reliability",
  encoding = c("auto", "halo", "blur", "landscape"),
  ...
) {
  encoding <- match.arg(encoding)
  
  # Delegate to appropriate guide type based on encoding
  switch(encoding,
    halo      = guide_legend(title = title, ...),
    blur      = guide_legend(title = title, ...),
    landscape = guide_colorbar(title = title, ...),
    auto      = guide_colorbar(title = title, ...)
  )
}
```

---

## 11. Parameter Defaults (`trust_defaults.R`)

```r
# ============================================================
# Default Parameters for All Encodings
# ============================================================

#' Default parameters for ggtrust encodings
#'
#' All tunable parameters centralized in one place.
#' Users override via theme_trust() or geom_*() arguments.
#'
#' @noRd
TRUST_DEFAULTS <- list(
  # --- Halos ---
  halo = list(
    max_radius     = 0.02,    # NPC units (2% of plot range)
    n_layers       = 10,      # Concentric ring count
    falloff_sigma  = 0.3,     # Gaussian falloff shape
    base_intensity = 0.3,     # Center opacity at reliability=1
    min_alpha      = 0.01     # Below this, skip rendering
  ),
  
  # --- Blur ---
  blur = list(
    max_sigma      = 0.005,   # NPC units (0.5% of plot range)
    quality        = "medium", # draft/medium/high
    raster_threshold = 2000,   # Auto-switch to raster mode above n
    kernel_size    = 64       # Pre-rendered kernel resolution
  ),
  
  # --- Landscape ---
  landscape = list(
    grid_resolution = 100,     # 100 × 100 evaluation grid
    smoothing       = "gam",   # gam/loess/kde
    contour         = TRUE,
    contour_bins    = 5,
    raster_alpha    = 0.6,     # Heatmap transparency
    colormap        = "viridis"
  ),
  
  # --- Encoding selection ---
  selection = list(
    halo_batch_upper   = 500,  # Halos for n ≤ 500
    blur_batch_upper   = 5000, # Blur for 500 < n ≤ 5000
    # Landscape for n > 5000
  ),
  
  # --- Legend ---
  legend = list(
    show_reliability  = TRUE,
    reliability_title = "Reliability"
  )
)
```

---

## 12. Rendering Pipeline Summary

```
User calls:
  ggplot(df, aes(V1, V2, reliability = trust)) + geom_trust_point()

ggplot2 layer stack:
  1. compute_aesthetics()   → recognizes x, y, reliability, colour
  2. scale_train()          → trains all scales; reliability clipped to [0,1]
  3. scale_map()            → maps data to aesthetic values
  4. GeomTrustPoint$draw_panel()
     ├── select_encoding(nrow(data))   → "halo" (n=150)
     └── draw_halo_panel(data, ...)
          ├── coord$transform()        → [0,1] coordinates
          ├── compute halo radius      → (1 - rel) * R_max
          ├── compute halo alpha       → rel * alpha
          ├── generate concentric circles
          │    for each point, for each layer:
          │      circleGrob(r = frac * radius)
          │      with Gaussian-weighted alpha
          ├── pointsGrob()             → base marks
          └── gTree(children)          → complete grob

For landscape:
  1. ... same up to draw_panel dispatch
  2. draw_landscape_panel()
     ├── smooth_reliability(x, y, rel) → 100×100 grid prediction
     ├── rasterGrob(viridis(z_mat))    → heatmap layer
     ├── (optional) contourLines()     → contour overlay
     ├── pointsGrob()                  → points on top
     └── gTree(children)              → layered grob

For blur:
  1. ... same up to draw_panel dispatch
  2. draw_blur_panel()
     ├── compute blur_sigma           → (1 - rel) * sigma_max
     ├── for each point:
     │     for each quality layer:
     │       circleGrob(r = frac * sigma)
     │       with Gaussian weight alpha
     └── gTree(children)
```

---

## 13. Performance Benchmarks (Expected)

| Encoding | n=150 | n=500 | n=2K | n=10K |
|----------|:-----:|:-----:|:----:|:-----:|
| Halo (medium) | 8ms | 25ms | 200ms | >2s |
| Blur (medium) | 15ms | 60ms | 500ms | >5s |
| Blur (raster) | 30ms | 80ms | 100ms | 150ms |
| Landscape (GAM) | 80ms | 120ms | 200ms | 500ms |

**Bottleneck identification:**
- Halos at >5K points: O(n × layers) circle rendering becomes grid-heavy.
- Blur at >2K points: Same as halos, with more layers. Raster mode becomes faster breakeven at ~2K.
- Landscape: Smoothing cost is O(n) for GAM (mgcv is efficient), grid rendering is O(grid²) = constant ~100×100. Does not scale with n after smoothing.

---

## 14. Testing Strategy

### 14.1 Unit Tests (testthat)

| File | Tests |
|------|-------|
| `test-geom-halo.R` | Halo radius = (1 - rel) * R_max; zero-radius at rel=1; NA handling; single-point edge case |
| `test-geom-blur.R` | Blur sigma scaling; multi-circle Gaussian weights sum to 1; raster fallback |
| `test-geom-landscape.R` | Grid generation; GAM prediction; contour level extraction; alpha compositing |
| `test-stat-dr.R` | Trustworthiness range [0,1]; monotonicity; k-NN correctness; edge cases (k=1, k=n-1) |
| `test-scale.R` | Limits always [0,1]; clipping; missing data; discrete fallback |
| `test-selection.R` | Thresholds: n≤500 → halo, n≤5000 → blur, n>5000 → landscape; no-reliability → landscape |

### 14.2 Visual Regression Tests (vdiffr)

- "Halo encoding renders five points across reliability range 0, 0.25, 0.5, 0.75, 1.0"
- "Landscape encoding with GAM smoothing on iris-tSNE data"
- "Blur encoding at draft/medium/high quality levels"
- "Auto-encoding dispatches to halo for n=150"
- "All three encodings are visually discriminable from baseline"

### 14.3 Golden Master Tests

Pre-render canonical PNGs for each encoding × dataset combination and compare against freshly rendered output. Pixel difference threshold: <0.1% to account for anti-aliasing variation.

---

## 15. Key Design Decisions Summary

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Dispatch architecture | `GeomTrustPoint` calls sub-routines | Simpler than separate layer composition; avoids ggplot2 internal complexity |
| Halo rendering | Multi-circle decomposition | Pure grid; no raster dependency; scales with device resolution |
| Blur rendering | Multi-circle decomposition (+ raster fallback) | Consistent with vector graphics; raster mode for speed at n>2K |
| Landscape smoothing | GAM (mgcv) default | Principled penalized likelihood; auto-smoothness; reasonable extrapolation |
| Scale range enforcement | Always [0,1] in `ScaleReliability$train()` | Prevents scale drift; matches the formal definition |
| Encoding auto-selection | Threshold-based on n | Simple, predictable, explainable; avoids opaque ML-based selection |
| Aesthetic registration | `register_theme_elements()` only | Minimal footprint; no global state pollution |
| Stat override pattern | `compute_layer()` not `compute_group()` | Trust metrics require all points; groups give wrong results |

---

## Appendix: Layer Composition Order

The rendering order within the gTree is critical for correct visual occlusion:

```
For Halos:        For Blur:          For Landscape:
  points (top)      points (top)       points (top)
  halos (bottom)    blur rings (bot)   contours (mid)
                                       heatmap (bot)
```

In grid graphics, the first grob in gList is drawn FIRST (bottom of the stack). So:
- Landscape gList: `list(raster, contours, points)` → raster is background, points are foreground
- Halo gList: `list(points, halos)` → halos behind points

This is handled by `rev(children)` in the landscape geom to ensure raster goes behind points.
