# ggtrust: A Grammar of Graphics Extension for Visualizing Point Reliability in Scatterplots

**Synthesis of TrustDR + ggdistinct into a single coherent research project**

---

## 1. Project Title

**ggtrust: Positional Reliability as a First-Class Aesthetic in the Grammar of Graphics**

---

## 2. Research Gap

Two independent lines of recent visualization research converge on the same unmet need:

**From dimensionality reduction:** DR scatterplots (t-SNE, UMAP, PCA) "are known to produce unreliable visual representations" ("Stop Misusing", 2025), yet "scatterplots can hardly inform the original attribute values" and "limited discussion extending beyond 2D scatterplots" (Reliable VA survey, CHI 2025). Current DR tools (Rtsne, umap, scikit-learn) output only 2D coordinates — no reliability information.

**From uncertainty visualization:** "Uncertainty needs to be formalised within the grammar of graphics" ("The Noisy Work", 2024), and "a practical problem is the lack of uncertainty visualization techniques in many existing software systems" (Weiskopf, 2022). The existing ggdist package provides distribution geoms but does not integrate uncertainty as a first-class aesthetic.

**The unaddressed overlap:** No system treats *point-level reliability/trustworthiness* as a native visual channel. In any scatterplot — DR or otherwise — some points are more reliable than others. This information currently requires manual visual encoding (e.g., color mapping) rather than being a principled part of the grammar. The gap is not "general uncertainty" (too broad) or "DR-specific tools" (too narrow), but rather: **a grammar-level mechanism for encoding how much each point's position should be trusted.**

---

## 3. Problem Statement

When a scatterplot shows N points, not all points are equally trustworthy. In dimensionality reduction, some points perfectly preserve their high-dimensional neighborhood while others are severely distorted. In prediction scatterplots (predicted vs. actual), some predictions are more accurate than others. In measurement data, some observations have higher precision.

Users cannot currently answer: *Which points in this scatterplot can I trust?* Without this information, analysts draw false conclusions — interpreting cluster structure that is an artifact, or treating all predictions as equally reliable.

The problem: **There exists no principled visual grammar for encoding per-point reliability in scatterplots**, despite clear evidence that the absence of reliability information leads to systematic misinterpretation.

---

## 4. Research Questions

**RQ1 (Visual Encoding):** How should per-point reliability information be visually encoded alongside position in a scatterplot to maximize accurate interpretation without introducing visual clutter?

**RQ2 (Grammatical Integration):** Can reliability be formalized as a first-class aesthetic in the grammar of graphics, with principled automatic mappings from reliability scores to visual channels?

**RQ3 (Domain Generalization):** To what extent can a single reliability encoding grammar serve multiple domains (DR projection quality, prediction confidence, measurement precision) without domain-specific customization?

**RQ4 (Effectiveness):** Does explicit visual encoding of per-point reliability improve users' ability to correctly interpret scatterplot structure compared to standard (unreliability-augmented) scatterplots?

---

## 5. Proposed Visualization Technique

A grammatical extension to the grammar of graphics that introduces **positional reliability** as a native visual variable. The core technique is an additional aesthetic, `reliability`, that maps a per-point scalar (typically [0, 1]) to combinations of visual channels that communicate "how much this point's position can be trusted."

The extension provides three layers of reliability communication:

**Layer 1 — Implicit (automatic visual encoding):** The `reliability` aesthetic automatically maps to one or more visual channels selected by a perceptual model:
- **High reliability → solid, opaque, precise encoding**
- **Low reliability → faded, diffuse, imprecise encoding**

**Layer 2 — Explicit (interactive inspection):** Any point can be queried to reveal its reliability provenance — the high-dimensional or ground-truth context that determined its score.

**Layer 3 — Aggregate (overall reliability landscape):** A background contour or heatmap showing the 2D distribution of reliability across the plotting area.

The technique is *not* a new standalone visualization type. It is a *grammatical modifier* that can augment any existing scatterplot with a single additional aesthetic mapping.

---

## 6. Novel Visual Encodings

The core design challenge: reliability is a meta-property about position itself, not about a variable mapped to a position. This requires encoding strategies distinct from standard color/size/shape mappings.

### Encoding 1: Reliability Halos (default)
Each point is surrounded by a concentric "halo" whose radius, opacity, and spread encode the reliability of the point's position.
- High reliability: small, opaque, sharp-edged halo (point appears firmly placed)
- Low reliability: large, transparent, soft-edged halo (point appears "fuzzy" or uncertain in position)
- The halo uses a perceptually uniform diverging colormap (blue = high reliability → red = low)

### Encoding 2: Opacity Gradient Points
Rather than a binary opaque/transparent point, reliability is encoded as a radial opacity gradient within the point itself:
- High reliability: solid circle
- Low reliability: Gaussian-blurred circle (fading at edges, suggesting positional uncertainty)

### Encoding 3: Jittered Ensemble (alternative, optional)
For very low reliability, the point is shown as a small ensemble of slightly jittered positions, visually communicating the uncertainty range.

### Encoding 4: Background Reliability Landscape
A 2D kernel density estimate of reliability values across the plotting area, shown as a contour map or heatmap beneath the scatterplot. Regions of uniformly high/low reliability become immediately apparent.

### Encoding Selection
The default encoding is selected automatically:
- For small point sets (<500): Reliability Halos
- For medium (500–5000): Opacity Gradient Points
- For large (>5000): Background Landscape only (halos would cause overplotting)

All encodings are overridable by the user.

---

## 7. Interactive Features

Minimal interaction — only what is needed to make the static grammar useful:

### Feature 1: Point Inspection (essential)
Click or hover on any point to open a side panel showing:
- The point's reliability score (numeric)
- The top-5 nearest neighbors in the reliability-implied space (if DR) or the prediction confidence breakdown (if prediction)
- A small "neighborhood preservation" mini-plot showing how the point's high-D neighbors compare to its 2D neighbors

### Feature 2: Reliability Thresholding (essential)
A slider to filter out points below a user-set reliability threshold. Below-threshold points fade to 5% opacity but remain visible for context. This lets users ask: "What does the plot look like if I keep only the reliable points?"

### Feature 3: Mode Toggle (essential)
Switch between the three reliability encoding strategies to allow users to compare which encoding they find most informative.

### Non-features (explicitly excluded to maintain focus):
- No animation
- No multi-view coordination beyond the inspection panel
- No provenance logging
- No collaborative features

---

## 8. R Package Architecture

The package is named **ggtrust** and follows standard ggplot2 extension conventions.

```
ggtrust/
├── R/
│   ├── ggtrust-package.R         # Package metadata
│   ├── aesthetics.R              # New aesthetic: reliability
│   ├── geom_trust.R              # Main geom: geom_trust_point()
│   ├── geom_trust_halo.R         # Layer 1: reliability halos
│   ├── geom_trust_landscape.R    # Layer 3: background reliability landscape
│   ├── stat_trust_dr.R           # Compute reliability from DR quality metrics
│   ├── stat_trust_confidence.R   # Compute reliability from prediction confidence
│   ├── stat_trust_manual.R       # User-provided reliability vector
│   ├── scale_reliability.R       # Scale for reliability aesthetic
│   ├── theme_trust.R             # Theme elements (reliability legend)
│   ├── trust_metrics.R           # Quality metric computations (trustworthiness, continuity, stress)
│   ├── inspect_point.R           # Interactive inspection (Shiny module)
│   └── utils.R                   # Internal helpers
├── inst/
│   └── shiny/                    # Minimal Shiny app for interaction
├── vignettes/
│   ├── intro.Rmd                 # Getting started
│   ├── dr-reliability.Rmd        # Use case: DR projection quality
│   ├── prediction-confidence.Rmd # Use case: prediction scatterplots
│   └── custom-reliability.Rmd    # User-provided reliability
├── tests/
├── man/
└── DESCRIPTION
```

### API Design (user-facing)

```r
# Core usage — reliability computed from DR quality
library(ggtrust)

iris_dr <- Rtsne::Rtsne(iris[, 1:4])$Y |> as.data.frame()
iris_dr$species <- iris$Species

# Option A: Automatic reliability from DR output
ggplot(iris_dr, aes(V1, V2, color = species)) +
  geom_trust_point(computed_from = iris[, 1:4], method = "Rtsne")

# Option B: Explicit reliability column
ggplot(iris_dr, aes(V1, V2, color = species, reliability = trust_score)) +
  geom_trust_point()

# Option C: Stat-based (reliability computed in stat)
ggplot(iris_dr, aes(V1, V2, color = species)) +
  stat_trust_dr(original_data = iris[, 1:4], method = "umap")
```

---

## 9. Shiny Application Architecture

A minimal Shiny app included in the package as an interactive companion:

```
inst/shiny/ggtrust-explorer/
├── app.R
├── modules/
│   ├── scatterplot_module.R      # Renders the ggtrust scatterplot
│   ├── inspection_module.R       # Point inspection panel
│   └── threshold_module.R        # Reliability threshold slider
└── www/
    └── style.css
```

The app provides:
1. Dataset selector (built-in demo datasets)
2. DR method selector (t-SNE, UMAP, PCA)
3. Reliability encoding toggle (halo / gradient / landscape)
4. Interactive point inspection
5. Reliability threshold slider
6. Comparison mode (side-by-side: with vs. without reliability encoding)

The app is deliberately simple — its purpose is to demonstrate the package and enable the user study, not to be a standalone product.

---

## 10. System Architecture

```
┌─────────────────────────────────────────────────────┐
│                   User Interface                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │          ggplot2 + ggtrust (static plots)        │ │
│  └──────────────┬──────────────────────┬───────────┘ │
│  ┌──────────────┴──────┐    ┌──────────┴───────────┐ │
│  │  Shiny Explorer App │    │  R Markdown Reports   │ │
│  └──────────────┬──────┘    └──────────────────────┘ │
└─────────────────┼─────────────────────────────────────┘
                  │
┌─────────────────┼─────────────────────────────────────┐
│           ggtrust Package (Grammar Layer)              │
│  ┌──────────────┴──────┐                              │
│  │  Geoms + Stats +    │                              │
│  │  Scales + Themes    │                              │
│  └──────────────┬──────┘                              │
└─────────────────┼─────────────────────────────────────┘
                  │
┌─────────────────┼─────────────────────────────────────┐
│           Reliability Computation Layer                │
│  ┌──────────────┴──────────────────────────────┐      │
│  │  DR Quality   │  Prediction   │  Manual     │      │
│  │  Metrics      │  Confidence   │  Input      │      │
│  │  (trust,      │  (calibration,│  (any       │      │
│  │   continuity, │   std error)  │   numeric)  │      │
│  │   stress)     │               │             │      │
│  └──────────────┴───────────────┴─────────────┘      │
└────────────────────────────────────────────────────────┘
```

The architecture is flat and minimal — a grammar layer on top of a computation layer, with a thin Shiny app for interactivity. No external services, no databases, no complex pipeline.

---

## 11. Data Pipeline

```
Input Data                                     Output
┌──────────┐    ┌────────────────┐    ┌───────────────────┐
│ High-Dim │───▶│ DR Method      │───▶│ 2D Coordinates    │
│ Data     │    │ (t-SNE/UMAP)   │    │ + Reliability     │
└──────────┘    └────────────────┘    │ Scores (per-point)│
                                      └────────┬──────────┘
┌──────────┐    ┌────────────────┐              │
│ Pred vs  │───▶│ Model Fit      │───▶ 2D Coords + Residual │
│ Actual   │    │ Diagnostics    │      Confidence          │
└──────────┘    └────────────────┘                          │
                                      ┌─────────────────────┘
                                      ▼
                              ┌───────────────────┐
                              │ Visual Encoding   │
                              │ Selection (auto)  │
                              └─────────┬─────────┘
                                        ▼
                              ┌───────────────────┐
                              │ ggplot2 + ggtrust │
                              │ Render            │
                              └───────────────────┘
```

The pipeline is a single pass: compute coordinates → compute reliability → select encoding → render. No streaming, no incremental updates, no progressive computation.

---

## 12. Required R Packages

| Package | Purpose | Type |
|---------|---------|------|
| ggplot2 | Target extension framework | Depends |
| Rtsne | t-SNE DR for demo datasets | Suggests |
| umap | UMAP DR for demo datasets | Suggests |
| dimRed | Quality metrics (trustworthiness, continuity, stress) | Imports |
| scales | Custom scale construction for reliability aesthetic | Imports |
| grid | Low-level graphical primitives for halo rendering | Imports |
| mgcv | Smooth reliability landscape (GAM-based) | Imports |
| shiny | Interactive inspection app | Suggests |
| plotly | Interactive inspection (converting ggplot to plotly) | Suggests |
| testthat | Unit testing | Suggests |
| roxygen2 | Documentation | Suggests |
| knitr/rmarkdown | Vignettes | Suggests |

**Total dependency footprint: ~10 packages.** Deliberately minimal.

---

## 13. Datasets

| Dataset | Source | Purpose | Reliability Source |
|---------|--------|---------|-------------------|
| Iris | R built-in | Ground-truth clusters; small, well-understood | t-SNE/UMAP quality metrics |
| MNIST subset (1000) | keras/torch | High-D image projection; known structure | Neighborhood preservation |
| Wine Quality | UCI | Medium-dimensional regression prediction | Prediction confidence |
| Auto MPG | R built-in | Regression prediction scatterplot | Residual-based confidence |
| Gapminder | gapminder | Temporal + geographic patterns with measurement error | Synthetic measurement noise |
| Single-cell RNA-seq (subset) | Seurat | High-D biological data; noisy real measurements | DR quality + dropout probability |

All datasets are small (<10 MB), publicly available, and loadable directly from R packages. No downloading, preprocessing, or cleaning required.

---

## 14. Implementation Roadmap (16 weeks)

| Week | Phase | Tasks | Deliverable |
|------|-------|-------|-------------|
| 1 | **Foundation** | Package skeleton; `DESCRIPTION`, basic ggproto class structure; `geom_trust_halo` prototype with fixed opacity | Working skeleton package + minimal geom |
| 2 | **Core geom** | Complete `geom_trust_point()` with halo rendering; `reliability` aesthetic registration; `scale_reliability()` | Core geom working with manual reliability input |
| 3 | **Auto encoding** | Encoding selection logic; opacity gradient points; reliability landscape | Three encoding strategies switchable |
| 4 | **DR metrics** | `stat_trust_dr()` implemented; trustworthiness, continuity, stress computation; integration with dimRed | DR reliability computation working |
| 5 | **Prediction metrics** | `stat_trust_confidence()`; residual-based and calibration-based confidence | Prediction confidence mode working |
| 6 | **Theme & polish** | Reliability legend; theme elements; vignette infrastructure; default parameter tuning | Polished package (v0.1.0) |
| 7 | **Shiny app** | Minimal interactive explorer; point inspection; threshold slider | Working Shiny app |
| 8 | **Shiny app** | Comparison mode (with/without reliability); dataset selector; polish | Shiny app complete |
| 9 | **Vignettes** | Write 3 vignettes (DR, prediction, custom) with real datasets | Vignettes complete |
| 10 | **User study design** | Design experiment (with/without reliability); IRB (if needed); recruit participants | Study protocol |
| 11 | **User study execution** | Run study (~20 participants); collect data | Raw study data |
| 12 | **User study analysis** | Statistical analysis; effect size; qualitative feedback | Study results |
| 13 | **Writing** | Paper introduction + related work + method | Paper draft sections |
| 14 | **Writing** | Paper results + discussion + figures | Full paper draft |
| 15 | **Revision** | Review, polish, respond to feedback; reproducibility check | Camera-ready paper |
| 16 | **Buffer** | Overrun protection; optional stretch goals | Completed project |

---

## 15. Minimum Viable Research Contribution

The absolute smallest contribution that constitutes a publishable visualization research result:

1. **One new visual encoding** (reliability halos) implemented as a ggplot2 extension
2. **One reliability source** (DR quality metrics) fully integrated
3. **One interaction** (point inspection) in the Shiny app
4. **One user study** (20 participants, within-subjects: standard scatterplot vs. reliability-augmented scatterplot, measuring interpretation accuracy and confidence)
5. **One domain** (dimensionality reduction) fully demonstrated with 3 datasets

This is the "trunk" — everything else (prediction confidence, opacity gradient encoding, landscape view) is branch. The trunk alone is publishable: a complete arc from problem → technique → implementation → evaluation.

---

## 16. Stretch Goals

Only if the trunk is solidly complete:

1. **Prediction confidence mode** (`stat_trust_confidence()`)
2. **Third encoding** (jittered ensemble for very low reliability)
3. **Multi-method comparison** in the Shiny app (side-by-side t-SNE vs. UMAP with reliability)
4. **Expert user study** (in addition to the main study) — compare with practitioners who use DR regularly
5. **Vega-Lite rendering** (via vegawidget) as an alternative output format
6. **Generalized `geom_trust()`** that extends to non-scatterplot geoms (geom_col, geom_line)

---

## 17. Evaluation Methodology

### Study Design
- **Type:** Within-subjects experiment
- **Independent variable:** Visualization mode (standard scatterplot vs. reliability-augmented scatterplot)
- **Dependent variables:** Interpretation accuracy (correct identification of clusters, outliers, trends), task completion time, confidence rating, perceived trust
- **Participants:** 20–30 (data science students/researchers)
- **Datasets:** MNIST (known clusters), Wine Quality (known regression structure), Gapminder with synthetic noise
- **Tasks:** Cluster identification ("How many clusters?"), outlier detection ("Which points are most anomalous?"), structure comparison ("Which of these two projections is more reliable?")

### Metrics
- **Accuracy:** Proportion correct across tasks
- **Time:** Task completion time (seconds)
- **Trust calibration:** Difference between self-reported confidence and actual accuracy
- **Qualitative:** Think-aloud comments, post-study interview

### Hypothesis
H1: Reliability-augmented scatterplots improve interpretation accuracy compared to standard scatterplots.  
H2: Reliability-augmented scatterplots improve users' trust calibration (confidence better matches accuracy).  
H3: Users can correctly interpret the reliability encoding without training.

### Analysis
- Paired t-tests or Wilcoxon signed-rank (depending on normality)
- Effect size (Cohen's d)
- Thematic analysis of qualitative feedback

---

## 18. Comparison with Existing Work

| System/Approach | What It Does | What ggtrust Adds |
|----------------|--------------|-------------------|
| **TrustDR** (original proposal) | DR-specific: augment t-SNE/UMAP with trustworthiness glyphs + landscape | Generalizes to any scatterplot; grammatical integration with ggplot2; encoding selection model |
| **ggdistinct** (original proposal) | General uncertainty grammar for ggplot2 (distributions, confidence intervals) | Focuses specifically on positional reliability (not distributional uncertainty); lighter weight; interactive inspection |
| **ggdist** (existing) | Statistical distribution geoms (slabs, dots, intervals) | Reliability as a per-point aesthetic rather than a distribution visualization |
| **dimRed + ggplot2** (existing workflow) | User manually computes quality metrics and maps to color/size | Automated computation + principled default visual mapping + interaction |
| **Error bars in ggplot2** (existing) | Per-point error bars require manual specification | Conceptualizes reliability as a single scalar that maps to multiple channels automatically |
| **tidybayes** (existing) | Bayesian posterior uncertainty | Different type of uncertainty (model posterior vs. projection quality) |

The key differentiator: ggtrust is the first system to treat **positional reliability as a general, grammar-integrated aesthetic** rather than a domain-specific overlay or a statistical summary.

---

## 19. Publication Strategy

### Primary Target: EuroVis 2027 Short Papers
- **Why:** EuroVis is the premier European visualization conference. Short papers require a focused contribution with preliminary evaluation. The 8-page format suits ggtrust's scope perfectly.
- **Timeline:** Submission deadline ~December 2026, notification ~February 2027.
- **Relevance:** The topic addresses uncertainty visualization, high-dimensional visualization, and grammar extension — all core EuroVis themes.

### Backup Target: IEEE VIS 2027 Poster
- If EuroVis timeline is tight, a VIS poster (extended abstract) is a strong alternative with lower bar. The interactive demo would be well-received.

### Secondary Target: The R Journal
- After the conference submission, a software paper in The R Journal describing the package implementation, API design, and usage examples. This is lower prestige but higher impact for the R community.

### Timeline:
| Date | Milestone |
|------|-----------|
| Oct 2026 | Package v1.0 release on GitHub |
| Nov 2026 | User study completed |
| Dec 2026 | EuroVis short paper submission |
| Mar 2027 | R Journal submission |
| Apr 2027 | Package publication on CRAN (optional) |

---

## 20. Thesis/Report Structure

**Title:** Visualizing Positional Reliability in Scatterplots: A Grammar of Graphics Extension

| Chapter | Content | Pages |
|---------|---------|-------|
| 1. Introduction | Problem statement, motivation, research questions, contributions | 4 |
| 2. Background & Related Work | DR reliability (TrustDR), uncertainty in grammar (ggdistinct, ggdist), visual variable theory, existing ggplot2 extensions | 8 |
| 3. Design Rationale | Why positional reliability ≠ statistical uncertainty; perceptual principles for encoding; design alternatives considered and rejected | 6 |
| 4. The ggtrust Package | Architecture, API design, implementation of reliability aesthetics, encoding selection algorithm, interactive inspection | 10 |
| 5. Evaluation | User study design, results, analysis | 8 |
| 6. Discussion | Limitations, generalizability, design implications, future work | 4 |
| 7. Conclusion | Summary of contributions, reflection | 2 |
| | **Total** | **~42 pages** |

---

## Summary: Why This Design

This project is the **smallest coherent research contribution** that bridges TrustDR and ggdistinct because:

1. **It takes one idea from each:** TrustDR's per-point reliability concept + ggdistinct's grammatical approach
2. **It discards the rest:** No general uncertainty grammar (too broad), no standalone DR tool (too narrow)
3. **It creates something new:** The concept of *positional reliability as a native visual aesthetic* does not exist in any current system
4. **It is empirically testable:** The contribution can be validated in a single user study
5. **It is achievable:** One R package, one Shiny app, one user study, one paper — all in 16 weeks
6. **It builds rather than combines:** The result is not "TrustDR + ggdistinct features" but a new concept that neither project fully addressed
