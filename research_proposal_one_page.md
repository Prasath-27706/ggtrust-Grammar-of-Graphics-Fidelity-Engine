# ggtrust: A Grammar of Graphics Extension for Visualizing Spatialization Fidelity in DR-Derived Scatterplots

## Research Gap

Two convergent findings from recent visualization research: (a) DR scatterplots (t-SNE, UMAP) "are known to produce unreliable visual representations" yet current tools output only 2D coordinates — no reliability information (Stop Misusing t-SNE, 2025; Reliable VA Survey, CHI 2025); (b) "uncertainty needs to be formalised within the grammar of graphics" but no system implements this (The Noisy Work, 2024; Weiskopf, 2022). The unaddressed overlap: **no system provides a principled, grammar-integrated mechanism for encoding per-point spatialization fidelity** — the degree to which each point's 2D position faithfully preserves its high-dimensional neighborhood structure.

## Problem Statement

Analysts using DR projections (t-SNE, UMAP, PCA) cannot answer: *Which points in this scatterplot can I trust?* Per-point spatialization fidelity — quantified by trustworthiness T(k,i) and continuity C(k,i) — is mathematically well-defined but never visually encoded. Without it, analysts systematically misinterpret cluster structure, treat artifacts as real patterns, and draw conclusions unsupported by the data. Existing tools require manual, ad-hoc mapping of quality metrics to visual channels with no principled perceptual basis.

## Research Questions

**RQ1 (Encoding Design):** What visual encoding optimally communicates per-point spatialization fidelity in DR scatterplots, resolving the paradox that low-fidelity points require both visual de-emphasis (to signal untrustworthiness) and visual emphasis (to flag them for attention)?

**RQ2 (Grammatical Integration):** Can spatialization fidelity be formalized as a layer-level annotation in the Grammar of Graphics, analogous to how `geom_smooth` adds a derived property (LOESS fit) as a visual modifier?

**RQ3 (Empirical Effectiveness):** Does explicit visual encoding of spatialization fidelity improve users' ability to correctly interpret cluster structure, identify unreliable points, and assess projection quality compared to standard scatterplots?

## Objectives

1. Design and implement two complementary visual encodings for spatialization fidelity — **Halo Mode** (concentric Gaussian halos: extent flags attention, opacity signals fidelity) and **Landscape Mode** (GAM-smoothed background heatmap: region-level assessment) — as an R ggplot2 extension
2. Develop `StatTrustDR` for automatic computation of per-point T(k,i) and C(k,i) metrics from DR output
3. Empirically validate both encodings against baseline scatterplots in a controlled user study (n=24) measuring accuracy, response time, and trust calibration across three task types (region assessment, point flagging, cluster reality judgment)

## Proposed Framework

**ggtrust** — an R package extending ggplot2's ggproto system. The core innovation is treating spatialization fidelity as a *layer-level annotation* (not an aesthetic): it computes derived properties from the data-transformation pipeline and modifies point appearance accordingly. Two encoding modes address the interpretation paradox: **Halo Mode** (scale of concentric Gaussian rings around each point; extent ∝ 1−fidelity → flagging, opacity ∝ fidelity → assessment) and **Landscape Mode** (2D GAM smooth of fidelity values rendered as viridis heatmap with contour overlays; supports region-level gist). A `StatTrustDR` stat computes per-point trustworthiness and continuity using k-NN neighborhood analysis. The package follows ggplot2 extension conventions — full compatibility with faceting, coordinate systems, themes, and guides.

## Expected Contributions

- **Visual encoding design:** Two novel, perceptually grounded encodings for spatialization fidelity, with the Halo encoding providing the first natural resolution of the assessment-flagging paradox within a single mark
- **Grammar extension:** The first implementation of a layer-level fidelity annotation in the Grammar of Graphics, demonstrating a pattern applicable beyond scatterplots (bar charts, line charts with derived-position uncertainty)
- **Open-source R package:** ggtrust on CRAN, with documented API, vignettes for DR quality analysis, and full test coverage (~80 unit tests, visual regression tests)
- **Empirical evidence:** Controlled experiment quantifying the accuracy and trust-calibration benefits of fidelity-augmented scatterplots vs. standard practice

## Evaluation Plan

Within-subjects experiment: 4 conditions (Baseline, Halo, Landscape, Stacked) × 3 task types (region fidelity assessment, point flagging, cluster reality judgment) × 3 datasets (Iris-tSNE, MNIST-UMAP, Wine-PCA). n=24 participants (data science graduates). Metrics: accuracy, response time, trust calibration (|confidence − accuracy|), SUS, qualitative preference. Primary analysis: repeated-measures ANOVA with Holm-corrected post-hoc comparisons. Preregistered on OSF.

## Deliverables

| Week | Deliverable |
|------|-------------|
| 4 | ggtrust package v0.1 (halo + landscape geoms, stat_trust_dr, scales) |
| 6 | Pre-registered user study protocol + stimulus rendering pipeline |
| 8 | Completed study (n=24) + analysis scripts |
| 10 | Full paper draft (6–8 pages, EuroVis short format) |
| 12 | Package v1.0 on GitHub with vignettes + CRAN submission |
