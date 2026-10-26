# ggtrust v1 — Complete Software Architecture

**Spatialization Fidelity Visualization Framework for ggplot2**  
*Author: Senior ggplot2 developer*  
*Release: v1.0 (Halo Mode + Landscape Mode only)*

---

## 1. Design Philosophy

Five principles govern every decision in this architecture:

1. **Native ggplot2 extension.** Use ggproto, not custom grid calls at the user level. Every component (geom, stat, scale, theme, guide) follows the extension contract so that facets, coords, and theme inheritance work automatically.

2. **One geom per encoding.** `geom_trust_halo()` and `geom_trust_landscape()` are independent layer-building functions. `geom_trust_point()` is a convenience wrapper that dispatches. No geom tries to be two things at once.

3. **Stat layer separates computation from rendering.** Reliability computation (DR quality metrics) lives in `StatTrustDR` — not in the geom. Users can swap stats independently of geoms, following ggplot2 convention.

4. **Reliability is an aesthetic, not a parameter.** Users map it via `aes(reliability = col)`. It is continuous [0,1], with its own scale, legend, and training rules. This ensures faceting, inheritance, and guide generation work automatically.

5. **Minimal dependencies.** `grid` (graphics), `mgcv` (smoothing), `scales` (scale internals) — these are the hard Imports. Everything else is Suggests.

---

## 2. Package Structure

```
ggtrust/
├── DESCRIPTION
├── NAMESPACE
├── NEWS.md
├── R/
│   ├── ggtrust-package.R         # Package doc, imports, .onLoad hook
│   ├─── geom/
│   │   ├── geom_trust_point.R     # Unified entry-point geom
│   │   ├── geom_trust_halo.R      # Halo-encoding geom
│   │   └── geom_trust_landscape.R # Landscape-encoding geom
│   ├─── stat/
│   │   ├── stat_trust.R           # Geom-agnostic stat for geom_trust_point
│   │   ├── stat_trust_dr.R        # DR quality metrics stat
│   │   ├── stat_trust_confidence.R# Prediction confidence stat
│   │   └── stat_trust_manual.R    # Pass-through with validation
│   ├─── scale/
│   │   ├── scale_reliability.R    # ScaleReliability ggproto + constructors
│   │   └── guide_reliability.R    # Custom guide for reliability legend
│   ├─── compute/
│   │   ├── trust_metrics.R        # T(k,i), C(k,i), stress computation
│   │   ├── smooth_reliability.R   # 2D smoothing (GAM/loess) for landscape
│   │   └── encoding_select.R      # Auto-encoding selection algorithm
│   ├─── render/
│   │   ├── render_halo.R          # Low-level halo drawing helpers
│   │   ├── render_landscape.R     # Low-level landscape drawing helpers
│   │   └── legend_glyphs.R        # Custom legend key glyphs
│   ├─── theme/
│   │   ├── theme_trust.R          # Theme element definitions
│   │   └── theme_defaults.R       # Default parameter values
│   └─── utils/
│       ├── utils.R               # General helpers
│       └── zzz.R                 # .onLoad hook
├── tests/
│   ├── testthat/
│   │   ├── test-geom-halo.R
│   │   ├── test-geom-landscape.R
│   │   ├── test-stat-dr.R
│   │   ├── test-scale-reliability.R
│   │   ├── test-trust-metrics.R
│   │   ├── test-encoding-select.R
│   │   └── test-integration.R
│   ├── vdiffr/
│   │   ├── fig-halo-basic.svg
│   │   ├── fig-landscape-basic.svg
│   │   └── fig-auto-select.svg
│   └── testthat.R
├── inst/
│   └── shiny/                    # Shiny explorer app (v1.1)
├── vignettes/
│   ├── intro.Rmd                 # Getting started
│   └── dr-reliability.Rmd        # DR projection quality use case
└── man/                          # Generated documentation
```

**File responsibility rule:** One file = one exported function + its ggproto class. Exceptions: small helpers co-located with the geom they serve.

---

## 3. API Surface (User-Facing)

### 3.1 Geoms

```r
# ——— Halo mode ———
geom_trust_halo(
  mapping = NULL, data = NULL,
  max_radius = NULL,            # NULL → theme default (0.02 npc)
  halo_layers = 10L,            # concentric ring count
  na.rm = FALSE,                # strip NA reliability?
  show.legend = NA,
  inherit.aes = TRUE,
  ...                           # passed to layer()
)

# ——— Landscape mode ———
geom_trust_landscape(
  mapping = NULL, data = NULL,
  smoothing = "gam",            # "gam", "loess"
  smoothing_bandwidth = NULL,   # NULL = auto
  contour = TRUE,               # draw contour lines?
  contour_bins = 5,
  raster_alpha = 0.5,           # heatmap opacity
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
)

# ——— Auto-dispatch mode ———
geom_trust_point(
  mapping = NULL, data = NULL,
  encoding = c("auto", "halo", "landscape"),
  ...                           # passes extra params to selected encoding
)
```

### 3.2 Stats

```r
# ——— DR quality metrics ———
stat_trust_dr(
  mapping = NULL, data = NULL,
  original_data = NULL,         # high-dim matrix
  k = 15,                       # neighborhood size
  aggregation = "min",          # "min" | "prod" | "avg" for T+C combination
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  geom = "trust_point",         # default consumer geom
  ...
)

# ——— Prediction confidence ———
stat_trust_confidence(
  mapping = NULL, data = NULL,
  type = c("auto", "residual", "probability"),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  geom = "trust_point",
  ...
)

# ——— Manual (user-provided reliability) ———
stat_trust_manual(
  mapping = NULL, data = NULL,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...                           # passes through to geom
)
```

### 3.3 Scales

```r
scale_reliability_continuous(
  name = "Reliability",
  breaks = c(0, 0.25, 0.5, 0.75, 1),
  labels = c("Very Low", "Low", "Medium", "High", "Very High"),
  limits = c(0, 1),             # always [0,1]
  ...
)

scale_reliability_binned(
  name = "Reliability",
  n_bins = 5,
  ...
)
```

### 3.4 Theme

```r
theme_trust(
  halo.max_radius = NULL,
  halo.layers = NULL,
  landscape.colormap = NULL,
  landscape.raster_alpha = NULL,
  ...
)
```

### 3.5 Idiomatic Usage Examples

```r
library(ggtrust)

# ——— Minimal: auto-detect encoding ———
ggplot(iris_2d, aes(V1, V2, reliability = trust)) +
  geom_trust_point()
# → halo for n=150

# ——— Explicit halo ———
ggplot(iris_2d, aes(V1, V2, colour = Species, reliability = trust)) +
  geom_trust_halo(max_radius = 0.03)

# ——— Landscape ———
ggplot(iris_2d, aes(V1, V2, reliability = trust)) +
  geom_trust_landscape(smoothing = "loess", contour_bins = 7)

# ——— Stacked: landscape background + halo points ———
ggplot(iris_2d, aes(V1, V2, colour = Species, reliability = trust)) +
  geom_trust_landscape(raster_alpha = 0.4) +
  geom_trust_halo(max_radius = 0.015)

# ——— Stat-based (DR mode) ———
ggplot(iris_2d, aes(V1, V2)) +
  stat_trust_dr(original_data = iris[, 1:4], k = 10) +
  geom_trust_halo()

# ——— Faceted comparison ———
ggplot(mnist_2d, aes(V1, V2, reliability = trust)) +
  geom_trust_landscape() +
  facet_wrap(~digit_class)
```

---

## 4. ggproto Class Hierarchy

```
Geom (ggplot2::Geom)
 ├── GeomTrustHalo        # Halos + points
 ├── GeomTrustLandscape   # Heatmap + contours + points
 └── GeomTrustPoint       # Thin wrapper → delegates to #1 or #2

Stat (ggplot2::Stat)
 ├── StatTrust            # Internal: consumed by GeomTrustPoint
 ├── StatTrustDR          # DR quality → reliability
 ├── StatTrustConfidence  # Prediction confidence → reliability
 └── StatTrustManual      # Validation pass-through

ScaleContinuous (ggplot2::ScaleContinuous)
 └── ScaleReliability     # Overrides train() + map() to enforce [0,1]

Guide (ggplot2::Guide)
 └── GuideReliability     # Combined glyph + colorbar legend
```

### 4.1 GeomTrustHalo

```r
GeomTrustHalo <- ggproto("GeomTrustHalo", Geom,

  # ——— Aesthetic contract ———
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = aes(
    reliability = 0.5,    # moderate fidelity when none supplied
    colour     = "grey30",
    fill       = NA,
    alpha      = 1,
    size       = 1.5,
    stroke     = 0.5
  ),

  # ——— Rendering ———
  draw_panel = function(self, data, panel_params, coord,
                        max_radius = NULL,
                        halo_layers = 10L, ...) {
    # 1. Transform to [0,1] NPC coordinate space
    trans <- coord$transform(data, panel_params)

    # 2. Resolve parameters (theme → default)
    max_radius <- max_radius %||%
      ggtrust_opt("halo.max_radius") %||%
      TRUST_DEFAULTS$halo$max_radius

    # 3. Build halo + point grobs
    grob <- render_halo_layer(
      x         = trans$x,
      y         = trans$y,
      colour    = trans$colour,
      alpha     = trans$alpha,
      size      = trans$size,
      stroke    = trans$stroke,
      reliability = trans$reliability,
      max_radius  = max_radius,
      n_layers    = halo_layers,
      falloff     = ggtrust_opt("halo.falloff") %||% 0.3
    )

    # 4. Wrap in gTree for draw_key() isolation
    ggname("geom_trust_halo", grob)
  },

  # ——— Legend key ———
  draw_key = function(self, data, params, size) {
    draw_key_trust_halo(data, params, size)
  }
)
```

### 4.2 GeomTrustLandscape

```r
GeomTrustLandscape <- ggproto("GeomTrustLandscape", Geom,

  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = aes(
    reliability = 0.5,
    colour     = "grey30",
    fill       = NA,
    alpha      = 1,
    size       = 1.5
  ),

  draw_panel = function(self, data, panel_params, coord,
                        smoothing = "gam",
                        smoothing_bandwidth = NULL,
                        contour = TRUE,
                        contour_bins = 5,
                        raster_alpha = 0.5, ...) {

    trans <- coord$transform(data, panel_params)

    # 1. Define evaluation grid
    x_range <- panel_params$x.range
    y_range <- panel_params$y.range
    grid_res <- ggtrust_opt("landscape.grid") %||% 100L
    x_grid <- seq(x_range[1], x_range[2], length.out = grid_res)
    y_grid <- seq(y_range[1], y_range[2], length.out = grid_res)

    # 2. Smooth reliability onto grid
    grid_mat <- smooth_reliability_2d(
      x      = trans$x,
      y      = trans$y,
      z      = trans$reliability,
      x_grid = x_grid,
      y_grid = y_grid,
      method = smoothing,
      bandwidth = smoothing_bandwidth
    )

    # 3. Assemble grob stack (bottom to top)
    grobs <- list()

    # Layer 1: heatmap raster
    if (!is.null(grid_mat)) {
      grobs[[1]] <- render_landscape_raster(
        z = grid_mat,
        alpha = raster_alpha,
        x_range = x_range,
        y_range = y_range
      )
    }

    # Layer 2: contour lines
    if (contour && !is.null(grid_mat)) {
      grobs[[2]] <- render_landscape_contours(
        z = grid_mat,
        x = x_grid,
        y = y_grid,
        n_bins = contour_bins
      )
    }

    # Layer 3: points (alpha = reliability)
    grobs[[3]] <- render_landscape_points(
      x = trans$x, y = trans$y,
      colour = trans$colour,
      alpha = trans$alpha * trans$reliability,
      size = trans$size
    )

    ggname("geom_trust_landscape",
      grid::gTree(children = do.call(grid::gList, grobs)))
  },

  draw_key = function(self, data, params, size) {
    draw_key_trust_landscape(data, params, size)
  }
)
```

### 4.3 GeomTrustPoint (Dispatcher)

```r
GeomTrustPoint <- ggproto("GeomTrustPoint", Geom,

  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = GeomTrustHalo$default_aes,  # inherit halo defaults

  draw_panel = function(self, data, panel_params, coord,
                        encoding = "auto", ...) {

    if (identical(encoding, "auto")) {
      encoding <- select_encoding(
        n = nrow(data),
        has_reliability = "reliability" %in% names(data)
      )
    }

    switch(encoding,
      halo      = GeomTrustHalo$draw_panel(self, data, panel_params, coord, ...),
      landscape = GeomTrustLandscape$draw_panel(self, data, panel_params, coord, ...)
    )
  },

  draw_key = function(self, data, params, size) {
    draw_key_trust_halo(data, params, size)  # halo glyph as default legend key
  }
)
```

### 4.4 StatTrust (Internal, consumed by GeomTrustPoint)

```r
StatTrust <- ggproto("StatTrust", Stat,

  required_aes = c("x", "y"),

  compute_layer = function(self, data, params, panels) {
    # If reliability already present, pass through
    if (is.null(data$reliability)) {
      data$reliability <- 0.5  # neutral default
    }
    data
  },

  compute_group = function(...) {
    cli::cli_abort("StatTrust does not support grouped computation.")
  }
)
```

### 4.5 StatTrustDR

```r
StatTrustDR <- ggproto("StatTrustDR", Stat,

  required_aes = c("x", "y"),

  compute_layer = function(self, data, params, panels) {

    original <- as.matrix(params$original_data)
    coords   <- as.matrix(data[, c("x", "y")])
    k        <- min(params$k %||% 15, nrow(data) - 1)

    # Per-point trustworthiness + continuity
    trust <- compute_trustworthiness(original, coords, k)
    cont  <- compute_continuity(original, coords, k)

    data$reliability <- switch(params$aggregation %||% "min",
      min  = pmin(trust, cont),
      prod = trust * cont,
      avg  = (trust + cont) / 2
    )

    data
  },

  compute_group = function(...) {
    cli::cli_abort("StatTrustDR requires all points. Use compute_layer.")
  },

  # Tell ggplot2 not to group by anything
  default_aes = aes(reliability = stat(reliability))
)
```

### 4.6 ScaleReliability

```r
ScaleReliability <- ggproto("ScaleReliability", ScaleContinuous,

  # Always [0,1] — overrides whatever the data supplies
  range = c(0, 1),

  train = function(self, x) {
    x <- pmax(0, pmin(1, as.numeric(x)))
    ggproto_parent(ScaleContinuous, self)$train(x)
  },

  map = function(self, x, limits = self$get_limits()) {
    x <- pmax(0, pmin(1, as.numeric(x)))
    scales::rescale(x, to = c(0, 1), from = limits)
  },

  # Default breaks: 0, 0.25, 0.5, 0.75, 1
  get_breaks = function(self, ...) {
    c(0, 0.25, 0.5, 0.75, 1)
  }
)

scale_reliability_continuous <- function(
  name = "Reliability",
  breaks = waiver(),
  ...
) {
  sc <- continuous_scale(
    aesthetics  = "reliability",
    scale_name  = "reliability_c",
    palette     = scales::identity_pal(),
    name        = name,
    breaks      = breaks,
    limits      = c(0, 1),
    guide       = "reliability",
    super       = ScaleReliability,
    ...
  )
  sc
}
```

---

## 5. Rendering Pipeline (Detailed)

### 5.1 Halo Pipeline

```
geom_trust_halo()
  → layer() → data pipeline (ggplot2 internals)
  → GeomTrustHalo$draw_panel(data, panel_params, coord, params)

Inside draw_panel:
  1. coord$transform(data, panel_params)
     → x, y converted from data space to [0,1] NPC

  2. Compute per-point halo parameters:
     halo_radius ← (1 - reliability) × max_radius
     halo_alpha  ← reliability × point_alpha

  3. Call render_halo_layer(x, y, colour, alpha, size,
                              reliability, max_radius, n_layers)

     Inside render_halo_layer:
       For each point i (vectorized):
         For each layer j = 1..n_layers:
           frac ← j / n_layers
           r    ← frac × halo_radius[i]
           w    ← exp(-(frac²) / (2 × 0.3²))     # Gaussian weight
           a    ← halo_alpha[i] × w × 0.3        # base intensity

           circleGrob(
             x = x[i], y = y[i], r = r,
             gp = gpar(col = NA, fill = colour[i] @ alpha = a)
           )

       For each point i:
         pointsGrob(
           x = x[i], y = y[i],
           pch = 19, size = size[i],
           gp = gpar(col = colour[i] @ alpha = alpha[i])
         )

  4. gTree(children = gList(point_grob, halo_grobs...))
```

**Rendering order:** Points drawn FIRST (on bottom), halos on top. Wait — that's wrong. Halos should be BEHIND points. Let me fix this:

```
gList(halo_grobs..., point_grob)   # halos first → rendered first → behind points
```

In grid graphics, the first grob in gList is drawn first (bottom of z-order). So:
```r
all_grobs <- c(halo_grobs, list(point_grob))
```

### 5.2 Landscape Pipeline

```
geom_trust_landscape()
  → layer() → data pipeline
  → GeomTrustLandscape$draw_panel(data, panel_params, coord, params)

Inside draw_panel:
  1. coord$transform(data, panel_params)
     → x, y in [0,1] NPC

  2. Build 100×100 evaluation grid from panel_params$x.range, .y.range

  3. smooth_reliability_2d(x, y, reliability, x_grid, y_grid, method="gam"):
     fit ← mgcv::gam(reliability ~ s(x, y, k = 30),
                     data = data.frame(x, y, reliability))
     grid_pred ← predict(fit, newdata = expand.grid(x = x_grid, y = y_grid))
     matrix(grid_pred, nrow = 100, ncol = 100)

  4. Render heatmap:
     z_scaled ← cut(grid_mat, 256, labels = FALSE)
     fill with viridisLite::viridis(256)[z_scaled]
     rasterGrob(fill, x=0, y=0, width=1, height=1,
                gp = gpar(alpha = raster_alpha))

  5. Render contours (if contour = TRUE):
     grDevices::contourLines(x_grid, y_grid, grid_mat, nlevels = contour_bins)
     polylineGrob for each contour level

  6. Render points:
     pointsGrob(x, y, pch = 19, size = size,
                gp = gpar(col = colour @ alpha = reliability × alpha))

  7. gTree(children = gList(raster, contours, points))
```

### 5.3 Coordinate System Handling

Both geoms call `coord$transform()` before rendering. This ensures:

- **Cartesian coordinates** (default): Works as expected — [0,1] mapping.
- **Fixed coordinates** (`coord_fixed`): Respects aspect ratio.
- **Faceting** (`facet_wrap`, `facet_grid`): Each panel gets its own `panel_params` with independent x/y ranges.
- **Flip coordinates** (`coord_flip`): x and y swapped correctly.
- **Polar coordinates** (`coord_polar`): Points positioned on polar grid; halos rendered as circles in the polar space. (Limitation: halo circles become distorted in polar coords — documented in v1.)

Landscape GAM is computed in **transformed coordinate space**. This is correct because the smooth should reflect visual distance, not data distance, ensuring the landscape adapts to the coordinate system.

---

## 6. Stat Computation Layer

### 6.1 DR Quality: Per-Point Trustworthiness

```
Algorithm:

Input:  X ∈ ℝ^{n×d}  (high-dimensional data)
        Y ∈ ℝ^{n×2}  (2D projection coordinates)
        k ∈ ℕ        (neighborhood size)

For each point i ∈ {1..n}:

  Step 1: Find the k-nearest neighbors of i in Y (2D):
          N_Y(i) = knn(Y, i, k)

  Step 2: Find the k-nearest neighbors of i in X (high-D):
          N_X(i) = knn(X, i, k)

  Step 3: Identify false neighbors (in Y's neighborhood but not X's):
          false_nbrs = N_Y(i) \ N_X(i)

  Step 4: For each false neighbor j, find its rank r_ij in the
          high-D distance ordering of i (r = 1 for nearest in X).

  Step 5: Trustworthiness:
          T(k,i) = 1 − (2 / (n·k·(2n−3k−1))) · Σ_{j∈false_nbrs} (r_ij − k)

  Step 6: Continuity (reversed perspective):
          missing_nbrs = N_X(i) \ N_Y(i)
          C(k,i) = 1 − (2 / (n·k·(2n−3k−1))) · Σ_{j∈missing_nbrs} (r̂_ij − k)
          where r̂_ij is the rank of j in Y's distance ordering of i.

Return:  s_i = aggregate(T(k,i), C(k,i))
         • "min"  (default) → min(T, C)    [worst-case preservation]
         • "prod"            → T × C        [joint preservation]
         • "avg"             → (T + C) / 2  [balanced]

Performance optimization:
  - k-NN via FNN::get.knn()  — O(n log n + nk)
  - Avoid O(n²) distance matrix computation
  - Fallback to brute-force if FNN not installed
```

### 6.2 Smoothing (Landscape)

```r
smooth_reliability_2d <- function(x, y, z,
                                   x_grid, y_grid,
                                   method = c("gam", "loess"),
                                   bandwidth = NULL) {

  method <- match.arg(method)

  if (length(unique(z)) == 1) {
    # Constant reliability — return uniform grid
    return(matrix(z[1], nrow = length(x_grid), ncol = length(y_grid)))
  }

  grid_df <- expand.grid(x = x_grid, y = y_grid)
  fit_df  <- data.frame(x = x, y = y, z = z)

  result <- switch(method,
    gam = {
      fit <- mgcv::gam(z ~ s(x, y, k = min(30, length(x) - 4)),
                       data = fit_df,
                       method = "REML")
      predict(fit, newdata = grid_df)
    },
    loess = {
      span <- bandwidth %||% 0.3
      fit <- loess(z ~ x * y, data = fit_df,
                   span = span, degree = 1,
                   control = loess.control(surface = "direct"))
      predict(fit, newdata = grid_df)
    }
  )

  # Clamp to [0,1] — the GAM can predict outside the valid range
  result <- pmax(0, pmin(1, result))

  # Reshape to matrix (row = x, col = y)
  matrix(result, nrow = length(x_grid), ncol = length(y_grid))
}
```

---

## 7. Rendering Primitives (render/ directory)

### 7.1 `render_halo.R`

```r
#' Render the halo + point composite grob
#'
#' @param x,y NPC coordinates (length n)
#' @param colour Vector of point colours
#' @param alpha Vector of point alphas
#' @param size Vector of point sizes (mm)
#' @param reliability Vector of reliability scores [0,1]
#' @param max_radius Maximum halo radius in NPC
#' @param n_layers Number of concentric rings
#' @param falloff Gaussian sigma for ring weights
#' @noRd
render_halo_layer <- function(x, y, colour, alpha, size, stroke,
                               reliability, max_radius, n_layers,
                               falloff = 0.3) {

  n <- length(x)
  base_intensity <- ggtrust_opt("halo.base_intensity") %||% 0.3

  # Vectorized parameter computation
  halo_r <- (1 - reliability) * max_radius
  halo_a <- reliability * alpha * base_intensity
  lwd    <- 0.1 + (1 - reliability) * 0.5

  # ——— Halo circles (behind points) ———
  n_grobs <- sum(halo_r > 0) * n_layers
  if (n_grobs == 0) {
    halo_children <- list()
  } else {
    halo_list <- vector("list", n_grobs)
    idx <- 1L

    for (i in seq_len(n)) {
      if (halo_r[i] <= 0) next
      r_i <- halo_r[i]
      a_i <- halo_a[i]
      col_i <- colour[i]

      for (j in seq_len(n_layers)) {
        frac <- j / n_layers
        w <- exp(-(frac^2) / (2 * falloff^2))
        layer_alpha <- a_i * w

        if (layer_alpha < 0.005) next

        halo_list[[idx]] <- grid::circleGrob(
          x = x[i], y = y[i],
          r = frac * r_i,
          gp = grid::gpar(
            col = NA,
            fill = scales::alpha(col_i, layer_alpha),
            lwd = 0
          )
        )
        idx <- idx + 1L
      }
    }
    halo_children <- halo_list[seq_len(idx - 1L)]
  }

  # ——— Points (on top of halos) ———
  point_grob <- grid::pointsGrob(
    x = x, y = y,
    pch = 19,
    size = grid::unit(size, "mm"),
    gp = grid::gpar(
      col  = scales::alpha(colour, alpha),
      fill = scales::alpha(colour, alpha),
      lwd  = stroke
    )
  )

  grid::gTree(
    children = do.call(grid::gList, c(halo_children, list(point_grob))),
    cl = "halo_layer"
  )
}
```

### 7.2 `render_landscape.R`

```r
#' Render landscape heatmap raster
#' @noRd
render_landscape_raster <- function(z, alpha, x_range, y_range) {
  # z is a matrix (100×100) with reliability values [0,1]

  # Guard: constant or all-NA
  if (all(is.na(z)) || length(unique(na.omit(c(z)))) <= 1) {
    return(grid::nullGrob())
  }

  # Map to viridis
  pal <- viridisLite::viridis(256, direction = 1)
  z_scaled <- cut(z, breaks = seq(0, 1, length.out = 257),
                   include.lowest = TRUE, labels = FALSE)
  z_scaled[is.na(z_scaled)] <- 1L
  rgb_mat <- matrix(pal[z_scaled], nrow = nrow(z))

  # Flip y for raster orientation (grid renders from bottom-left)
  rgb_mat <- rgb_mat[, ncol(rgb_mat):1]

  grid::rasterGrob(
    rgb_mat,
    x = 0, y = 0, width = 1, height = 1,
    just = c("left", "bottom"),
    interpolate = TRUE,
    gp = grid::gpar(alpha = alpha)
  )
}

#' Render landscape contour lines
#' @noRd
render_landscape_contours <- function(z, x, y, n_bins = 5) {
  breaks <- seq(0, 1, length.out = n_bins + 2)
  breaks <- breaks[-c(1, length(breaks))]  # exclude endpoints

  cl <- grDevices::contourLines(
    x = x, y = y, z = z,
    levels = breaks,
    nlevels = n_bins
  )

  if (length(cl) == 0) return(grid::nullGrob())

  grobs <- vector("list", length(cl))
  for (i in seq_along(cl)) {
    grobs[[i]] <- grid::polylineGrob(
      x = cl[[i]]$x,
      y = cl[[i]]$y,
      gp = grid::gpar(
        col  = scales::alpha("grey30", 0.4),
        lwd  = 0.3,
        lty  = "dashed"
      ),
      default.units = "npc"
    )
  }

  do.call(grid::gList, grobs)
}

#' Render points over landscape
#' @noRd
render_landscape_points <- function(x, y, colour, alpha, size) {
  grid::pointsGrob(
    x = x, y = y,
    pch = 19,
    size = grid::unit(size, "mm"),
    gp = grid::gpar(
      col  = scales::alpha(colour, alpha),
      fill = scales::alpha(colour, alpha)
    )
  )
}
```

### 7.3 `legend_glyphs.R`

```r
#' Legend key glyph for halo encoding
#' @noRd
draw_key_trust_halo <- function(data, params, size) {
  # Show one representative point with a medium halo
  r <- 3  # mm
  grid::gTree(
    children = grid::gList(
      grid::circleGrob(
        x = 0.5, y = 0.5,
        r = grid::unit(r, "mm"),
        gp = grid::gpar(
          col = NA,
          fill = scales::alpha(data$colour %||% "grey30", 0.15)
        )
      ),
      grid::circleGrob(
        x = 0.5, y = 0.5,
        r = grid::unit(r * 0.5, "mm"),
        gp = grid::gpar(
          col = NA,
          fill = scales::alpha(data$colour %||% "grey30", 0.3)
        )
      ),
      grid::pointsGrob(
        x = 0.5, y = 0.5,
        pch = 19,
        size = grid::unit(4, "mm"),
        gp = grid::gpar(
          col = data$colour %||% "grey30",
          fill = data$colour %||% "grey30"
        )
      )
    ),
    cl = "halo_key"
  )
}

#' Legend key glyph for landscape encoding
#' @noRd
draw_key_trust_landscape <- function(data, params, size) {
  # Show a gradient swatch
  grid::rasterGrob(
    viridisLite::viridis(30),
    x = 0.5, y = 0.5,
    width = 0.8, height = 0.8,
    interpolate = FALSE
  )
}
```

---

## 8. Encoding Selection Algorithm

```r
#' Select encoding based on data size
#'
#' Rules:
#'   n ≤ 500      → "halo"         (clean circles, no overlap)
#'   500 < n ≤ 5000 → "landscape"  (points too dense for halos)
#'   n > 5000     → "landscape-only" (points skip, landscape only)
#'   no reliability → "landscape"   (only region info available)
#'
#' @noRd
select_encoding <- function(n, has_reliability = TRUE) {
  if (!has_reliability) return("landscape")
  if (n <= get_opt("selection.halo_max") %||% 500L) return("halo")
  "landscape"
}

#' Whether points should be rendered alongside landscape
#' @noRd
landscape_include_points <- function(n) {
  n <= (get_opt("selection.landscape_point_max") %||% 5000L)
}
```

---

## 9. Testing Strategy

### 9.1 Unit Tests (testthat, ~80 tests)

| Test file | Tests | What it verifies |
|-----------|-------|------------------|
| `test-geom-halo.R` | 12 | Halo radius ∝ 1−r; zero-radius at r=1; NA reliability → no halo; single-point edge case; colour inheritance; facet rendering; coord_flip compatibility |
| `test-geom-landscape.R` | 10 | Grid dimensions = 100²; GAM prediction within [0,1]; constant reliability → uniform landscape; contour level count; point alpha = reliability; empty data → nullGrob |
| `test-stat-dr.R` | 14 | T(k,i) ∈ [0,1]; T=1 when Y preserves X perfectly; T decays with increasing distortion; monotonicity: higher distortion → lower T; C(k,i) symmetric properties; aggregation=min works; k=1, k=n−1 edge cases |
| `test-scale-reliability.R` | 8 | Limits always [0,1]; data clipped on input; train accepts values outside [0,1] and clips; identity palette passes through; custom breaks work; NA values propagate |
| `test-encoding-select.R` | 10 | n=500 → halo; n=501 → landscape; n=0 → landscape; no reliability column → landscape; faceted small panels → each panel evaluated independently |
| `test-trust-metrics.R` | 12 | Perfect preservation → T=C=1; random projection → T≈C≈0.5; symmetry: swapping points doesn't change result; k > n−1 → reduced k; reproducibility: same X,Y → same result |
| `test-integration.R` | 8 | geom_trust_halo() + geom_trust_landscape() stack correctly; stat_trust_dr() + geom_trust_halo() pipeline; facet_wrap works; coord_fixed works; missing data handled |

**Critical edge cases:**
- All points have reliability = 1.0 → halos zero-sized, landscape uniform
- All points have reliability = 0.0 → halos at max radius, landscape uniform
- Single point → no smoothing denominator, landscape shows null/point
- `nrow(data) > nrow(unique(data))` → duplicate coordinates are intentional (multiple measures at same location)
- `coord_flip()` → halos must follow flipped axes
- `facet_grid()` + `scales = "free"` → each panel has different x/y ranges

### 9.2 Visual Regression Tests (vdiffr)

```
tests/vdiffr/
├── fig/
│   ├── halo-basic.svg            # 5 points at reliability 0, 0.25, 0.5, 0.75, 1
│   ├── halo-colour.svg           # Points colored by Species with halos
│   ├── halo-large-n.svg          # 500 points, check no overlap artifacts
│   ├── halo-no-reliability.svg   # Missing reliability → default 0.5 halos
│   ├── landscape-basic.svg       # Iris-tSNE + GAM landscape
│   ├── landscape-loess.svg       # Same data, loess smoothing
│   ├── landscape-contours.svg    # Contour lines visible
│   ├── landscape-points.svg      # Points with alpha on landscape
│   ├── landscape-no-reliability.svg # No reliability → uniform landscape
│   ├── stacked-halo-landscape.svg   # geom_trust_landscape + geom_trust_halo
│   ├── auto-halo.svg             # n=150 → dispatches to halo
│   └── auto-landscape.svg        # n=1000 → dispatches to landscape
```

### 9.3 Performance Benchmarks

```
benchmarks/
├── halo-bench.R          # n = 100, 500, 2000, 10000; measure draw time
├── landscape-bench.R     # n = 100, 500, 2000, 10000; measure smooth + draw
└── stat-bench.R          # n = 100, 500, 2000; measure T(k,i) computation
```

**Acceptance criteria:**
- Halo draw < 50ms for n ≤ 500
- Landscape draw < 200ms for n ≤ 2000
- Trustworthiness computation < 500ms for n ≤ 2000
- No grob count explosion: halo n_layers = 10 (bounded)

### 9.4 Manual Smoke Tests

```r
# Quick visual check suite — run before every commit
test_smoke <- function() {
  library(ggplot2)
  library(ggtrust)
  set.seed(42)

  n <- 100
  df <- data.frame(
    x = rnorm(n), y = rnorm(n),
    reliability = runif(n, 0, 1),
    colour = sample(c("A", "B"), n, TRUE)
  )

  p1 <- ggplot(df, aes(x, y, reliability = reliability)) + geom_trust_halo()
  p2 <- ggplot(df, aes(x, y, reliability = reliability)) + geom_trust_landscape()
  p3 <- ggplot(df, aes(x, y, reliability = reliability, colour = colour)) +
    geom_trust_landscape() + geom_trust_halo()
  p4 <- ggplot(df, aes(x, y)) + stat_trust_dr(original_data = df[, 1:2]) +
    geom_trust_halo()
  p5 <- ggplot(df, aes(x, y, reliability = reliability)) +
    geom_trust_point() + facet_wrap(~colour)

  # Print all
  invisible(lapply(list(p1, p2, p3, p4, p5), print))
}
```

---

## 10. Dependency Graph

```
ggtrust (v1.0)
├── Depends
│   └── ggplot2 (≥ 3.4.0)     # ggproto base, aes(), layer(), coord_transform
├── Imports
│   ├── grid                   # circleGrob, pointsGrob, rasterGrob, gTree
│   ├── mgcv                   # GAM smoothing for landscape
│   ├── scales                 # alpha(), identity_pal(), rescale()
│   ├── cli                    # User-facing messages
│   └── viridisLite            # Viridis colormap for landscape
├── Suggests
│   ├── FNN                    # Fast k-NN for trustworthiness (optional)
│   ├── dimRed                 # Alternative quality metrics (optional)
│   ├── testthat               # Unit testing
│   ├── vdiffr                 # Visual regression testing
│   ├── knitr / rmarkdown      # Vignettes
│   └── shiny / plotly         # Interactive explorer (v1.1)
└── Enhances
    └── Rtsne / umap           # DR methods for example datasets
```

**Total hard dependencies:** 6 packages (ggplot2, grid, mgcv, scales, cli, viridisLite). This is deliberately minimal — the package should be installable in restricted environments.

---

## 11. Inter-package Compatibility

| Package | Status | Notes |
|---------|--------|-------|
| **ggplot2** | ✅ Native | Full ggproto extension |
| **ggdist** | ✅ Compatible | Different focus (distribution vs. fidelity); can stack layers |
| **gganimate** | ✅ Compatible | No special support needed; animation treats reliability as static |
| **patchwork** | ✅ Compatible | Geoms don't interfere with patchwork's composition |
| **plotly** | ⚠️ Partial | `ggplotly()` drops custom geoms; use Shiny app for interactivity |
| **ggtext** | ✅ Compatible | Can be used for reliability annotations |
| **ggnewscale** | ✅ Compatible | Needed if user wants separate colour scales for data and reliability |

---

## 12. .onLoad Hook (`zzz.R`)

```r
.onLoad <- function(libname, pkgname) {
  # Register reliability aesthetic with ggplot2
  ggplot2::register_theme_elements(
    trust = ggtrust_defaults(),

    element_tree = list(
      trust = ggplot2::el_def("element_list")
    )
  )

  # Register the custom guide
  ggplot2::register_guide("reliability", GuideReliability)

  invisible()
}

ggtrust_defaults <- function() {
  TRUST_DEFAULTS
}
```

---

## 13. Summary: Data Flow Through the System

```
                           USER CODE
                              │
                    ggplot(df, aes(x, y, reliability = trust,
                                   colour = Species))
                              │
                    geom_trust_halo(max_radius = 0.02)
                              │
                    ┌─────────▼─────────┐
                    │   ggplot2::layer() │
                    │  (geom, stat, pos) │
                    └─────────┬─────────┘
                              │
                    ┌─────────▼─────────┐
                    │  Compute aesthetics│
                    │  · scales train    │
                    │  · scales map      │
                    │  · reliability →   │
                    │    [0,1] clipped   │
                    └─────────┬─────────┘
                              │
               ┌──────────────▼──────────────┐
               │  GeomTrustHalo$draw_panel()  │
               │                              │
               │  1. coord$transform()        │
               │     x, y → [0,1] NPC         │
               │                              │
               │  2. Compute per-point:       │
               │     halo_radius ← (1 - rel)  │
               │                  × R_max     │
               │     halo_alpha  ← rel × α    │
               │                              │
               │  3. render_halo_layer():     │
               │     for each point:          │
               │       for each ring:         │
               │         circleGrob(          │
               │           r = frac × r_max,  │
               │           fill = colour @ wα │
               │         )                    │
               │     pointsGrob(pch = 19)     │
               │                              │
               │  4. gTree(children = ...)    │
               └──────────────┬──────────────┘
                              │
               ┌──────────────▼──────────────┐
               │   grid::grid.draw(grob)      │
               │   → panel renders on device  │
               └─────────────────────────────┘
```

The same flow applies to landscape mode, with step 2 replaced by GAM smoothing + heatmap rasterization + contour extraction.

---

## 14. Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Separate geoms (halo/landscape) vs. one geom with param | Separate geoms compose naturally (stacking, faceting); one geom with param requires dispatch logic and prevents stacking both encodings |
| `reliability` as aesthetic vs. parameter | Aesthetic enables scale control, legend, faceting, and inheritance; parameter would bypass all ggplot2 infrastructure |
| Halos as concentric circles vs. filled circles with varying opacity | Concentric circles create the **edge softness** that distinguishes halos from simple point-size encoding; the Gaussian falloff is the core perceptual mechanism |
| GAM vs. loess for landscape (default GAM) | GAM has principled smoothness selection (GCV/REML) and better extrapolation; loess is a fast fallback |
| `compute_layer()` override in StatTrustDR | Trust metrics require ALL points; `compute_group()` would give wrong results with grouped data |
| NPC coordinates for halo radius | Ensures halos scale with plot dimensions proportionally; avoids pixel-dependent rendering |
| Grid graphics (not ggarrange, not custom device) | Native ggplot2 rendering pipeline; supports all coords, facets, themes |

---

## 15. Known Limitations (v1)

1. **coord_polar** — Halo circles rendered as grid circles in polar space; geometry is correct but visual effect is distorted (halo radii follow radial axis, not Euclidean distance). Documented for v1.1 fix.

2. **Large n performance** — Halo mode at n > 2000 generates 20K+ grid grobs (2000 points × 10 layers). Landscape mode is recommended at this scale. The auto-encoding selector enforces this threshold.

3. **GAM bandwidth lock-in** — Landscape uses a fixed 100×100 grid. For very large plotting areas (4K+ displays), the grid could show aliasing. Remediates by interpolating the rasterGrob.

4. **Missing data** — `na.rm = FALSE` propagates NA reliability → no halo drawn. `na.rm = TRUE` drops those rows. Both behaviors match ggplot2 conventions.

5. **Overplotting in landscape points** — Points over the landscape use alpha encoding only. At n > 5000, point overplotting makes per-point alpha indiscernible. Auto-selector returns "landscape-only" at this scale.
