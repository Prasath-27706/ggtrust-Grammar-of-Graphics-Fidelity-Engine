# 15 Alternative Visual Encodings for Spatialization Fidelity

**Context:** Designed for ggtrust — a grammar-of-graphics extension for visualizing per-point spatialization fidelity in DR-derived scatterplots (t-SNE, UMAP, PCA). Fidelity quantifies how faithfully a point's 2D position preserves its high-D neighborhood structure.

---

## Overview of the Encoding Design Space

Spatialization fidelity is a per-point scalar s_i ∈ [0,1] attached to a point at position (x_i, y_i). The encoding challenge: communicate "how much this point's position should be trusted" without interfering with the primary data channels (x, y, color, shape, size).

All 15 encodings are organized into four families by their relationship to the point mark.

---

## Family A: Point-Intrinsic Modulations (modify the point's own visual properties)

### Encoding 1: Alpha (Opacity) Modulation
**Mapping:** high fidelity → opaque (α=1.0), low fidelity → transparent (α→0.05)
**Metaphor:** "Unreliable points fade into background"
**Implementation:** geom_point(aes(alpha = fidelity)) in ggplot2
**Scalability:** Works at all point densities; overplotting at low alpha layers naturally
**Limitation:** Invisible points = untrustworthy points, yet they may still be informative; low-fidelity points become indiscernible
**Discriminability:** Human perception of alpha differences is ~10-15 steps (Ware, 2013)

### Encoding 2: Point Size Modulation
**Mapping:** high fidelity → small (precise dot), low fidelity → large (spread dot)
**Metaphor:** "Precision is compact; uncertainty spreads"
**Implementation:** geom_point(aes(size = 1 - fidelity)) — inverted mapping
**Scalability:** Poor at high densities — large low-fidelity points occlude neighbors
**Limitation:** Size conflates with importance (big = important in most visual conventions), creating opposite metaphor
**Discriminability:** ~5-7 discriminable steps for area (Cleveland & McGill, 1984)

### Encoding 3: Gaussian Blur (Spatial Spread)
**Mapping:** high fidelity → sharp point (σ=0), low fidelity → blurred (σ up to 3px)
**Metaphor:** "Fidelity is sharpness; uncertainty is fuzziness"
**Implementation:** Custom grid rasterization with Gaussian kernel applied per point
**Scalability:** Moderate — blur rendering is computationally expensive; overplotting merges blurs into blobs
**Limitation:** Requires raster graphics; not natively supported in vector-based ggplot2
**Discriminability:** Poorly studied; blur differences are continuous but non-metric

### Encoding 4: Radial Opacity Gradient
**Mapping:** high fidelity → solid circle (step function), low fidelity → radial gradient (Gaussian falloff from center)
**Metaphor:** "Certain points have hard edges; uncertain points are diffuse"
**Implementation:** Custom geom rendering point as radial gradient with fidelity-controlling sigma
**Scalability:** Better than blur — gradients render efficiently; overplotting blends gracefully
**Limitation:** Subtle differences at moderate fidelity levels are hard to discriminate
**Discriminability:** ~6-8 steps (estimated from gradient perception literature)

### Encoding 5: Shape Regularity (Deformation)
**Mapping:** high fidelity → perfect circle, low fidelity → irregular/deformed polygon
**Metaphor:** "Fidelity is geometric regularity"
**Implementation:** Circle with radial noise applied; noise amplitude = 1 - fidelity
**Scalability:** Very poor — irregular shapes are hard to render consistently; shape recognition fails at small sizes
**Limitation:** Perceptually, regularity requires large marks (>20px); at scatterplot scales (~5px), shape differences are invisible
**Discriminability:** Very low — only 2-3 distinguishable levels (Bertin, 1967 on shape channel)

### Encoding 6: Color Saturation (Desaturation)
**Mapping:** high fidelity → fully saturated color, low fidelity → desaturated/grey
**Metaphor:** "Vivid = reliable; washed out = untrustworthy"
**Implementation:** geom_point(aes(color = ...)) with saturation modulated on the color scale
**Scalability:** Excellent — color applies at any point size; no occlusion cost
**Limitation:** Conflicts with existing color mapping (e.g., species or category); requires the user's color aesthetic to be multi-channel
**Discriminability:** ~7-10 steps for saturation (Cleveland & McGill, 1984; Ware, 2013)

### Encoding 7: Point Border/Stroke Weight and Style
**Mapping:** high fidelity → thin/solid border, low fidelity → thick/dashed border
**Metaphor:** "Clean lines = reliable; messy lines = questionable"
**Implementation:** geom_point with stroke aesthetic controlling border width + linetype
**Scalability:** Good — borders render at any size; dashed patterns visible even at small sizes
**Limitation:** Dual-encoding required (fill + stroke) adds rendering complexity; stroke weight confounds with point size
**Discriminability:** ~4-5 steps for stroke width; linetype is categorical (3-4 types discriminable)

---

## Family B: Point-Extrinsic Modifications (additions around the point)

### Encoding 8: Concentric Fidelity Halos
**Mapping:** high fidelity → tight, opaque, sharp-edged halo; low fidelity → wide, transparent, soft-edged halo
**Metaphor:** "The point is anchored firmly vs. floating in a cloud of uncertainty"
**Implementation:** Custom geom rendering a concentric circle around each point with radius α (1 - fidelity) * R_max and opacity = fidelity
**Scalability:** Poor at >5000 points (overplotting); uses ~3x the point area per mark
**Limitation:** Dominant encoding — halos are visually salient and may distract from point position itself
**Discriminability:** ~6-8 steps for radius; halo opacity adds redundant channel for ~10 combined steps

### Encoding 9: Uncertainty Crosshairs
**Mapping:** high fidelity → small cross (+), low fidelity → large cross extending outward
**Metaphor:** "The point's position has a margin of error"
**Implementation:** Custom geom drawing crossed lines centered at (x,y); line length = (1-fidelity) * L_max
**Scalability:** Moderate — crosses extend into neighboring space, causing occlusion at high densities
**Limitation:** Error bars are conventionally used for measurement uncertainty (Cleveland & McGill rank: position-length tasks); reusing for fidelity creates semantic confusion
**Discriminability:** ~8-10 steps for line length (best discriminable channel, per Cleveland & McGill)

### Encoding 10: Jittered Ensemble (Multi-Dot)
**Mapping:** high fidelity → single dot; low fidelity → N dots jittered around position with spread α (1-fidelity)
**Metaphor:** "Low-fidelity points are scattered; they could plausibly be elsewhere"
**Implementation:** For each low-fidelity point, render M sub-points sampled from a 2D Gaussian centered at (x,y) with σ = (1-fidelity) * σ_max
**Scalability:** Very poor — each low-fidelity point becomes M+1 marks, multiplying density by 2-10x
**Limitation:** Interpretability — users may perceive jittered ensembles as actual data clusters rather than uncertainty
**Discriminability:** Not well-characterized; ensemble spread perception follows Weber's law

### Encoding 11: Trajectory/Vector Tails
**Mapping:** high fidelity → point only; low fidelity → point with trailing vector/arrow showing displacement direction under parameter variation
**Metaphor:** "This point would move if the projection parameters changed"
**Implementation:** Compute alternative projection (different perplexity/n_neighbors) and draw arrow from original to alternative position; arrow length α instability
**Scalability:** Moderate — arrows cross the plotting area, creating occlusion even for moderate numbers
**Limitation:** Requires computing at least one alternative projection (2x computation); arrows create directional bias in visual perception
**Discriminability:** Excellent for direction (pre-attentive pop-out); poor for magnitude (angle perception has ~7 levels per Cleveland & McGill)

---

## Family C: Context-Level Modifications (relational/background)

### Encoding 12: Background Fidelity Landscape
**Mapping:** 2D contour map or heatmap showing smoothed reliability across the plotting area
**Metaphor:** "The plotting plane itself has regions of reliability"
**Implementation:** 2D KDE or loess smooth of fidelity values; rendered as filled contours or heatmap beneath points
**Scalability:** Excellent — works for any number of points; landscape is a single graphic layer regardless of n
**Limitation:** Not per-point — it shows regions, losing per-point specificity; smooth may obscure local variation
**Discriminability:** Contour perception is good (4-6 levels); color fill perception follows color saturation ranking

### Encoding 13: Connecting Lines to "Reliable Neighbors"
**Mapping:** For each low-fidelity point, draw thin lines to its k nearest high-fidelity neighbors; line opacity = fidelity of source
**Metaphor:** "Unreliable points are 'tethered' to their reference points"
**Implementation:** For s_i < threshold, find k nearest neighbors with s_j > threshold; draw connecting lines with α = s_i
**Scalability:** Poor — each low-fidelity point adds k lines; worst-case O(n²) line count
**Limitation:** Creates visual spaghetti in low-fidelity regions; only meaningful for k-NN metrics (trustworthiness/continuity)
**Discriminability:** Line length and angle follow Cleveland & McGill ranking (high accuracy) but clutter dominates

### Encoding 14: Small-Multiples Panels by Fidelity Decile
**Mapping:** The full scatterplot is replicated in 3-5 small-multiple panels, each showing only points above a fidelity threshold (e.g., 0.9, 0.7, 0.5, all)
**Metaphor:** "Progressive revelation: what remains if I filter by fidelity?"
**Implementation:** ggplot2 faceting with each panel showing cumulatively more (or fewer) low-fidelity points
**Scalability:** Excellent — facet grid uses the full plot area; no per-point rendering cost increase
**Limitation:** Not a single integrated view — requires comparison across panels; loses spatial correspondence of low-fidelity points relative to high-fidelity structure
**Discriminability:** Position along common scale (best per Cleveland & McGill) but divided attention across panels

---

## Family D: Hybrid / Multi-Channel Combinations

### Encoding 15: Redundant Dual-Channel (Alpha + Size)
**Mapping:** Both opacity and point size encode fidelity redundantly: high fidelity → small, opaque; low fidelity → large, transparent
**Metaphor:** "Double signal for reliability"
**Implementation:** geom_point(aes(alpha = fidelity, size = 1 - fidelity)) with custom scales
**Scalability:** Good — combined effect is visually dominant; may compensate for individual channel weaknesses
**Limitation:** Redundancy consumes two visual channels; occludes underlying data at low fidelity (both large and transparent — conflicting perceptual effects)
**Discriminability:** ~10-15 combined steps (multiplicative effect of two channels, per Ware's integration theory)

---

## Theoretical Comparison

### Bertin's Visual Variables (1967)

| Encoding | Visual Variable | Selective | Associative | Ordered | Quantitative | Length |
|----------|----------------|:---------:|:-----------:|:-------:|:------------:|:------:|
| 1. Alpha | Value | Yes | No | Yes | Partial | Point |
| 2. Size | Size | Yes | No | Yes | Yes | Point |
| 3. Blur | Texture (grain) | Yes | Yes | Partial | No | Point |
| 4. Gradient | Value + Texture | Yes | No | Yes | Partial | Point |
| 5. Shape | Shape | Yes | Yes | No | No | Point |
| 6. Saturation | Color | Yes | No | Yes | Partial | Point |
| 7. Stroke | Size + Texture | Yes | No | Yes | Partial | Point |
| 8. Halo | Size | Yes | No | Yes | Yes | Extrinsic |
| 9. Crosshair | Size (line length) | No | No | Yes | Yes | Extrinsic |
| 10. Jitter | Position | Yes | No | Partial | No | Extrinsic |
| 11. Trajectory | Angle + Size | Yes | No | Partial | Partial | Extrinsic |
| 12. Landscape | Color (Value) | Yes | No | Yes | Partial | Context |
| 13. Connectors | Position (line) | No | No | No | No | Context |
| 14. Small-multiples | Position (panel) | Yes | No | Yes | Yes | Context |
| 15. Dual | Size + Value | Yes | No | Yes | Yes | Point |

**Key Bertin insight:** Shape (encoding 5) cannot communicate ordered quantitative data — it is associative and selective but neither ordered nor quantitative, making it unsuitable for fidelity's [0,1] scale. Conversely, position and size are the strongest ordered-quantitative channels.

### Cleveland & McGill's Perceptual Accuracy Ranking (1984)

| Encoding | Primary Channel | C&M Rank | Accuracy | Notes |
|----------|----------------|:--------:|:--------:|-------|
| 9. Crosshair | Position along length | 1 (tied) | Highest | But semantic mismatch with fidelity concept |
| 14. Small-multiples | Position along common scale | 1 | Highest | Best for comparison, worst for integration |
| 13. Connectors | Length (lines) | 2 | High | But clutter negates perceptual advantage |
| 2. Size | Area | 4 | Medium | Only ~5 steps; size/area discrimination is poor |
| 8. Halo | Area (ring area) | 4 | Medium | Area perception has ~10% just-noticeable difference |
| 11. Trajectory | Angle | 3 | Medium | ~7 steps for angle; direction pre-attentive |
| 3. Blur | Color saturation (grain) | 7-8 | Low-Medium | Saturation perception is task-dependent |
| 6. Saturation | Color saturation | 7 | Low-Medium | ~7 steps; confounded with hue |
| 1. Alpha | Color density | 8 | Low | ~10-15 steps per Ware, but value/lightness perception has non-linear mapping |
| 4. Gradient | Color density | 8 | Low | Similar to alpha but less studied |
| 5. Shape | Shape | N/A | N/A | Shape is categorical, not ordered |
| 7. Stroke | Length/width | 2 (length) | High | But very narrow range for stroke width |
| 10. Jitter | Position (spread) | 1 (position) | High | But misinterpretation risk (ensemble as clusters) |
| 12. Landscape | Position (contour) | 1 | High | But aggregates away per-point specificity |
| 15. Dual | Area + Density | 4 + 8 | Medium-Low | Redundant; conflicting perceptual effects |

**Key Cleveland & McGill insight:** Position-along-a-scale and length are the most accurate channels. However, the best channels (position, length) are already used by the primary data (x, y position) or require significant visual real estate (line length for connectors, crosshairs). There is a fundamental tension: the most accurate channels for encoding fidelity are the same channels used for the primary data.

### Ware's (2013) Pre-Attentive and Attentive Processing

| Encoding | Pop-out? | Conjunctive Search? | Quantitative gist? | Pattern perception? |
|----------|:--------:|:------------------:|:------------------:|:------------------:|
| 1. Alpha | Yes (at extremes) | Yes | Poor | Moderate |
| 2. Size | Yes (at extremes) | Yes | Medium | Poor (occlusion) |
| 3. Blur | Yes (unique attribute) | No | Poor | Poor |
| 4. Gradient | No | Yes | Poor | Moderate |
| 5. Shape | Yes (unique shapes) | Yes | N/A (categorical) | N/A |
| 6. Saturation | Yes | Yes | Medium | Good |
| 7. Stroke | Partial | Yes | Poor | Poor |
| 8. Halo | Yes (pop-out) | Yes | Medium | Good (gestalt grouping) |
| 9. Crosshair | Yes (pop-out) | Yes | High | Poor (occludes pattern) |
| 10. Jitter | Yes (texture difference) | No | Medium (spread) | Poor |
| 11. Trajectory | Yes (line orientation) | Yes | Medium | Poor (clutter) |
| 12. Landscape | N/A (background) | N/A | High | Excellent |
| 13. Connectors | No (dense) | Yes | Low | Poor (spaghetti) |
| 14. Small-multiples | N/A (panel level) | N/A | High (comparison) | Good |
| 15. Dual | Yes | Yes | Medium | Moderate |

**Key Ware insight:** Blur (encoding 3) is a unique pre-attentive feature — it triggers pop-out in visual search (Wolfe & Horowitz, 2004). However, blur magnitude is not quantitatively discriminable. Halos (encoding 8) benefit from pre-attentive pop-out for extreme values AND support pattern perception through gestalt grouping (similar halo sizes group). The background landscape (encoding 12) is the only encoding that supports texture perception and region-level gist extraction.

### Munzner's (2014) Nested Model Analysis

| Encoding | Domain fit | Task fit | Idiom suitability | Algorithm feasibility |
|----------|:----------:|:--------:|:----------------:|:--------------------:|
| 1. Alpha | High | Assessment only | Medium | Easy (native ggplot2) |
| 2. Size | Medium | Both | Low (conflict with importance) | Easy |
| 3. Blur | Medium | Assessment | Medium | Hard (vector → raster) |
| 4. Gradient | High | Assessment | Medium-High | Medium (custom geom) |
| 5. Shape | Low | Neither | Very Low | Medium |
| 6. Saturation | High (if no color used) | Assessment | High (when color free) | Easy |
| 7. Stroke | Low | Flagging | Low | Medium |
| 8. Halo | High | Both | High | Medium (custom geom) |
| 9. Crosshair | Medium | Assessment | Medium (semantic conflict) | Medium |
| 10. Jitter | Low | Assessment | Low (misinterpretation) | Medium |
| 11. Trajectory | Low | Flagging | Low (directional bias) | Hard (2x computation) |
| 12. Landscape | High | Assessment | High (region-level) | Medium (smooth + contour) |
| 13. Connectors | Low | Neither | Low (spaghetti) | Hard (quadratic edges) |
| 14. Small-multiples | High | Assessment | High (comparison) | Easy (facet wrap) |
| 15. Dual | High | Both | Medium-High | Medium |

**Key Munzner insight:** The interpretation paradox (theoretical critique §6, Weakness 3) is visible across encodings. Assessment tasks (how reliable is this region?) favor landscape, alpha, and small-multiples. Flagging tasks (which points are problematic?) favor halos, crosshairs, and dual-encoding. No single encoding serves both tasks optimally, confirming the critique's prediction that two modes are necessary.

---

## The Interpretation Paradox Across All 15 Encodings

The theoretical critique identified that low-fidelity points require both visual de-emphasis (to communicate untrustworthiness) and visual emphasis (to flag them for attention). Here is how each encoding handles this paradox:

| Encoding | Low-fidelity visual effect | Assessment support | Flagging support | Paradox resolution |
|----------|---------------------------|:------------------:|:----------------:|:------------------:|
| 1. Alpha | Faded/invisible | Excellent (ignores) | Terrible (misses) | **Fails** — disappears |
| 2. Size | Large/dominant | Poor (confuses) | Excellent (big=attention) | **Fails** — big = important |
| 3. Blur | Fuzzy/blobby | Good (hard to read) | Moderate (blob = anomaly) | Partial |
| 4. Gradient | Diffuse/soft | Good | Moderate | Partial |
| 5. Shape | Irregular | Poor (hard to see) | Poor | Fails |
| 6. Saturation | Grey/washed out | Good | Moderate (grey = dull) | Partial — grey is ignored |
| 7. Stroke | Thick/dashed border | Poor | Good (border draws eye) | Partial |
| 8. Halo | Wide, soft, transparent | Good (soft fade) | Good (large extent catches eye) | **Best resolution** — two sub-channels |
| 9. Crosshair | Long lines | Good (reads as error) | Good (long lines intrude) | Good but semantic mismatch |
| 10. Jitter | Scattered multi-dot | Poor (looks like data) | Good (cluster = anomaly) | Fails — misread as clusters |
| 11. Trajectory | Arrow/vector | Moderate | Good (direction draws eye) | Partial |
| 12. Landscape | Background region | Excellent | Poor (not per-point) | Single-mode only |
| 13. Connectors | Many lines | Poor (unreadable) | Poor (spaghetti) | Fails |
| 14. Small-multiples | Panel difference | Excellent (comparison) | Moderate (cross-panel) | Context-switch cost |
| 15. Dual | Large + transparent | Good (large = fuzzy) | Conflicting (large draws eye, transparent hides) | **Conflicting channels** |

**Conclusion on paradox:** Encoding 8 (halos) is the only encoding that naturally resolves the paradox: the halo's *extent* (which grows with uncertainty) serves as a flagging cue (larger area draws attention), while the halo's *opacity and edge softness* (which decrease with fidelity) serve as the assessment cue (faded = uncertain). This dual sub-channel within a single mark is theoretically elegant.

---

## Cross-Cutting Analysis

### Scalability (point count)

| Scale | Recommended encodings | Poor choices |
|-------|----------------------|--------------|
| <500 points | 8 (halos), 4 (gradient), 15 (dual) | 13 (connectors), 11 (trajectory) |
| 500-5000 | 1 (alpha), 6 (saturation), 12 (landscape), 14 (small-multiples) | 5 (shape), 10 (jitter) |
| >5000 | 12 (landscape) only; 14 (small-multiples) | Anything per-point fails from overplotting |

### Color Conflict Matrix

| Encoding | Conflicts with user's color aesthetic? | Mitigation |
|----------|:--------------------------------------:|------------|
| 1. Alpha | No — alpha is independent of color hue | None needed |
| 2. Size | No | But may conflict with existing size mapping |
| 6. Saturation | **Yes** — desaturation directly modifies user's color | Switch to encoding 1 or 8 when color is used |
| 8. Halo | Partial — halo uses its own color | Use neutral/diverging halo colormap |
| 15. Dual | No (alpha + size) | Best for plots with existing color mapping |

### Learning/Training Requirements

| Encoding | Intuitive? (no training) | Training needed? | Cultural dependence? |
|----------|:------------------------:|:----------------:|:--------------------:|
| 1. Alpha | Yes | Minimal | Low |
| 2. Size | No (inverted) | Yes — big = important convention must be unlearned | High |
| 8. Halo | Yes | Minimal | Low |
| 12. Landscape | Yes | Minimal | Low |
| 14. Small-multiples | Yes | Some | Low |

---

## Recommendation: Best 3 Encodings for Evaluation

### Rank 1: Encoding 8 — Concentric Fidelity Halos

**Why:**
- Best paradox resolution — extent catches attention while softness communicates uncertainty
- Pre-attentive pop-out for extreme values (Ware)
- Uses size channel (Cleveland & McGill rank 4) redundantly with alpha (rank 8) for ~10 discriminable steps
- Selective, ordered, and partially quantitative (Bertin)
- Highest domain + task fit across all Munzner levels
- Natural metaphor alignment (precision-of-form)
- Compatible with existing color aesthetics
- The original ggtrust default encoding — continuity with the project design

**Risks:** Poor scalability beyond 5000 points; rendering complexity in ggproto.

### Rank 2: Encoding 3 — Gaussian Blur (Spatial Spread)

**Why:**
- Unique pre-attentive channel — blur is a dedicated "uncertainty" signal in visual perception (Kosara, 2007; Ware, 2013)
- No conflict with any existing aesthetic — works orthogonally to color, size, shape
- Natural mapping that requires no training (Norman's natural mapping principle)
- Supports the assessment task well (low-fidelity regions appear "fuzzy")
- Theoretically grounded in the "precision-of-form" conceptual metaphor (Lakoff & Johnson)

**Risks:** Requires raster rendering (not native ggplot2 vector graphics); blur magnitude discrimination is poorly characterized in the perception literature; rendering cost at scale.

### Rank 3: Encoding 12 — Background Fidelity Landscape (with option for Encoding 1 as per-point complement)

**Why:**
- Only encoding that supports region-level gestalt perception (Munzner: idiom suitability for assessment task is highest)
- Best scalability — works at any point count without occlusion
- Position-based accuracy (Cleveland & McGill rank 1)
- Provides an "overall reliability topology" that per-point encodings cannot
- Can be combined with Encoding 1 (alpha) as a two-layer solution: landscape for assessment, point alpha for per-point detail
- Separates the paradox into two visual layers

**Risks:** Loses per-point specificity; smooth may be misleading if fidelity changes sharply over small distances; requires choosing interpolation kernel and bandwidth.

---

## Summary Decision Matrix

| Criterion | 8. Halos (Rank 1) | 3. Blur (Rank 2) | 12. Landscape (Rank 3) |
|-----------|:-----------------:|:----------------:|:----------------------:|
| Perceptual theory support | High (size + alpha) | Medium (blur as unique attribute) | High (position + color) |
| Paradox resolution | **Best** | Moderate (partial by de-emphasis) | Assessment only |
| Scalability | Moderate (<5K) | Moderate (<5K) | **Excellent** (any n) |
| Color conflict | None | **None** | Partial (background) |
| Implementation feasibility | Medium (custom ggproto) | **Hard** (raster → vector bridging) | Medium (smooth + contour) |
| Intuitiveness | High | High | High |
| R package fit | Direct (geom_trust_halo) | Indirect (needs rastify) | Direct (stat_trust_landscape) |
| Evaluation tractability | High | Medium | High |
| **Overall rank** | **1** | **3** | **2** |

The proposed evaluation path: Implement and evaluate Halos (primary, paradox-resolving) and Landscape (complementary, region-level) as the two default modes (Assessment Mode = Landscape + Alpha, Flagging Mode = Halos). Blur is the recommended third alternative for follow-up study due to its unique theoretical position (pre-attentive uncertainty channel) but higher implementation risk.
