# ggtrust — Decision Record (source of truth)

**Purpose:** Reconcile conflicts across the ten design documents in this folder into a single authoritative spec. When docs disagree, this file wins.

**Conflicts resolved (see analysis at bottom):** C1 encodings scope · C2 grammar treatment · C3 study conditions · C4 stat scope · C5 z-order bug · C6 timeline.

---

## Locked scope (v1.0)

| Dimension | Decision | Rationale |
|-----------|----------|-----------|
| **Encodings** | **Halo + Landscape only** (C1) | Matches `ggtrust_architecture_v2.md` and `research_proposal_one_page.md`. Blur is deferred to follow-up (rank-3 encoding, raster complexity). |
| **Grammar treatment** | Fidelity is an **aesthetic** `aes(reliability = ...)` (C2) | Both architecture docs implement it this way; pragmatic, ggplot2-native. The `ggtrust_theoretical_critique.md` position (layer-level annotation) is recorded as a design note / follow-up, not a v1 API change. |
| **Study conditions** | Baseline, Halo, Landscape, **Stacked** (C3) | `research_proposal_one_page.md` is the newest protocol; supersedes the 4-condition `ggtrust_user_study_protocol.md` which includes Blur. |
| **Stats** | `stat_trust_dr` + `stat_trust_manual` in v1 (C4) | `stat_trust_confidence` deferred to v1.1 — the theoretical critique restricts spatialization fidelity to DR-derived positions. |
| **Halo z-order** | Halos rendered **behind** points (C5) | `gList(halos..., point_grob)` — first grob in gList is bottom. The `architecture_v2` skeleton doc had this backwards in §5.1 code and self-flagged it; fixed here. |
| **Timeline** | Single 12-week build→study→write arc (C6) | `research_proposal_one_page.md` deliverable grid adopted; no fixed external deadline. |

## Domain scope

Applies to **DR-derived scatterplots** (t-SNE, UMAP, PCA, MDS projections). Per the theoretical critique: direct-measurement scatterplots and predicted-vs-actual plots are out of scope (their uncertainty is standard statistical uncertainty).

## Package structure (from `ggtrust_architecture_v2.md` §2, unchanged)

```
ggtrust/
├── DESCRIPTION ├── NAMESPACE ├── NEWS.md
├── R/
│   ├── ggtrust-package.R
│   ├── geom_trust_point.R     # dispatcher
│   ├── geom_trust_halo.R
│   ├── geom_trust_landscape.R
│   ├── stat_trust_dr.R
│   ├── stat_trust_manual.R
│   ├── scale_reliability.R
│   ├── guide_reliability.R
│   ├── trust_metrics.R
│   ├── smooth_reliability.R
│   ├── encoding_select.R
│   ├── theme_trust.R
│   ├── trust_defaults.R
│   ├── render_halo.R
│   ├── render_landscape.R
│   ├── legend_glyphs.R
│   ├── utils.R
│   └── zzz.R
├── tests/testthat/            # 7 suites (~74 tests) + tests/testthat.R
├── benchmarks/                # halo-bench.R, landscape-bench.R, stat-bench.R
├── vignettes/                 # intro.Rmd, dr-reliability.Rmd
└── man/                       # roxygen-generated
```

## API surface (from `architecture_v2` §3)

- `geom_trust_halo(max_radius, halo_layers, na.rm, show.legend, inherit.aes, ...)`
- `geom_trust_landscape(smoothing, smoothing_bandwidth, contour, contour_bins, raster_alpha, ...)`
- `geom_trust_point(encoding = c("auto","halo","landscape"), ...)`
- `stat_trust_dr(original_data, k, aggregation = c("min","prod","avg"), geom = "trust_point", ...)`
- `stat_trust_manual(na.rm, show.legend, inherit.aes, ...)`
- `scale_reliability_continuous(...)`, `scale_reliability_binned(n_bins, ...)`
- `theme_trust(halo.max_radius, halo.layers, landscape.colormap, landscape.raster_alpha, ...)`

## Defaults (from `trust_defaults.R` / `architecture_v2`)

| Param | Default | Notes |
|-------|---------|-------|
| halo.max_radius | 0.02 npc | 2% of plot range |
| halo.n_layers | 10 | concentric rings |
| halo.falloff | 0.3 | Gaussian sigma for ring weights |
| halo.base_intensity | 0.3 | center opacity at reliability=1 |
| landscape.grid | 100 | 100×100 evaluation grid |
| landscape.smoothing | "gam" | gam/loess |
| landscape.raster_alpha | 0.5 | heatmap opacity |
| landscape.contour_bins | 5 | contour levels |
| selection.halo_max | 500 | n≤500 → halo, else landscape |

## Alignment of docs → status

| Doc | Status |
|-----|--------|
| Literature Review | Background, unchanged |
| Research Project Proposals | Background (project selection), unchanged |
| Thesis Committee Evaluation | Background (selection), unchanged |
| ggtrust_project_design | Superseded by decision record for scope; conceptual background |
| ggtrust_theoretical_critique | Adopted for naming (spatialization fidelity) + domain scope; NOT for grammar position in v1 |
| spatialization_fidelity_encodings | Adopted: Halos (#1) + Landscape (#2) in scope, Blur (#3) deferred |
| ggtrust_ggproto_architecture | Superseded by v2 for code; historical (contains Blur) |
| ggtrust_architecture_v2 | **Base spec for implementation** (z-order §5.1 fixed here) |
| ggtrust_user_study_protocol | Active but must add Stacked condition (C3); Blur sections deferred |
| research_proposal_one_page | Active; matches v1 scope and timeline |

## Design note (from theoretical critique, recorded for future work)

Spatialization fidelity is conceptually a meta-property of the position mapping, not a data variable; the critique argues for layer-level annotation. v1 treats it as an aesthetic for engineering pragmatism. If a future grammar-level API (`layer_fidelity()`) is adopted, the aesthetic remains as a compatibility facade. The **interpretation paradox** (low-fidelity points need both de-emphasis and flagging) is resolved within the Halo mark: extent ∝ 1−fidelity (flagging), opacity ∝ fidelity (assessment).