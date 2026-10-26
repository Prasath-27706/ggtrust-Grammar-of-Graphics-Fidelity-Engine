# Spatialization Fidelity: A Taxonomy of 7 Data Visualization Techniques

**Project:** `ggtrust` — Grammar-of-Graphics Framework for Visualizing Point Reliability in Dimensionality Reduction  
**Academic Focus:** Comparative Visualization Research & Grammar Extension  

---

## 1. Executive Summary

When high-dimensional data ($\mathbb{R}^D$) is projected to 2D scatterplots ($\mathbb{R}^2$) using Dimensionality Reduction (t-SNE, UMAP, PCA), the algorithms introduce severe **spatial distortion**—tearing apart genuine clusters or fabricating artificial groupings.

Rather than relying on a single visual encoding, **`ggtrust` implements and empirically compares a comprehensive taxonomy of 7 distinct Data Visualization Techniques** spanning point-intrinsic, point-extrinsic, relational/network, continuous field, and multi-view coordinated paradigms.

---

## 2. The 7 Implemented Visualization Techniques

```
                                  ┌─────────────────────────────────────────────────────────┐
                                  │      Taxonomy of Visualization Techniques for          │
                                  │               Spatialization Fidelity                   │
                                  └────────────────────────────┬────────────────────────────┘
                                                               │
        ┌────────────────────────┬─────────────────────────────┼─────────────────────────────┬───────────────────────────┐
        ▼                        ▼                             ▼                             ▼                           ▼
┌──────────────┐         ┌───────────────┐             ┌───────────────┐             ┌───────────────┐           ┌───────────────┐
│   Family A   │         │   Family B    │             │   Family C    │             │   Family D    │           │   Family E    │
│Point-Intrinsic│        │Point-Extrinsic│             │Relational Net │             │Continuous Field│          │  Multi-View   │
└───────┬──────┘         └───────┬───────┘             └───────┬───────┘             └───────┬───────┘           └───────┬───────┘
        │                        │                             │                             │                           │
  [Technique 5]            [Technique 1]                 [Technique 3]                 [Technique 2]               [Technique 7]
  Alpha Saliency          Concentric Halos              Neighbor Tethers              Fidelity Surface            Strata Faceting
  (Opacity Fade)          (Gaussian Glow)               (Elastic Lines)               (GAM Isolines)              (Small-Multiples)
                                 │
                           [Technique 4]
                            Crosshairs
                           (Error Arms)
```

---

### Technique 1: Concentric Gaussian Halos (`geom_trust_halo`)
* **Visual Family:** Point-Extrinsic Compound Mark
* **Visual Encoding:** Multi-ring concentric Gaussian halos rendered *behind* scatterplot points.
  * **Halo Extent / Radius $\propto (1 - \text{fidelity})$**: Low-fidelity points expand outward to pre-attentively flag analyst attention.
  * **Halo Opacity $\propto \text{fidelity}$**: Unreliable points are rendered with faint, translucent ring intensity.
* **Paradox Resolution:** Solves the *Assessment vs. Flagging Paradox* in a single graphical mark without hijacking primary color aesthetics.
* **Best Used For:** Sparse to moderate scatterplots ($N \le 500$).

---

### Technique 2: Continuous Fidelity Heatmap Surface (`geom_trust_landscape`)
* **Visual Family:** Context-Level Continuous Field
* **Visual Encoding:** 2D Thin-Plate Spline Generalized Additive Model (GAM) or LOESS regression fitting a continuous fidelity surface across the canvas, overlaid with contour isolines.
* **Perceptual Principle:** Cleveland & McGill Position-along-a-scale ranking (Rank 1 for isoline elevation).
* **Best Used For:** Dense scatterplots ($N > 500$) where per-point marks would cause severe overplotting.

---

### Technique 3: Topological Neighbor Tethers (`geom_trust_tether`)
* **Visual Family:** Relational / Network Graph Encoding
* **Visual Encoding:** Draws elastic dashed vector line segments from displaced points to their true high-dimensional nearest neighbors ($k$-NN in $\mathbb{R}^D$).
* **Visual Impact:** When t-SNE tears a cluster apart across the 2D plane, long spider-web tethers stretch across the canvas, exposing the exact topological tear and distance distortion.
* **Best Used For:** Diagnosing cluster splitting and severe projection artifacts.

---

### Technique 4: Geometric Uncertainty Crosshairs (`geom_trust_crosshair`)
* **Visual Family:** Geometric Glyphs
* **Visual Encoding:** Orthogonal horizontal and vertical crosshairs centered on each point. Arm length $L \propto (1 - \text{fidelity}) \times L_{\text{max}}$.
* **Perceptual Principle:** Length comparison (Cleveland & McGill Rank 2). High-fidelity points have zero arm length (pure dot); low-fidelity points have large crosshairs showing positional margin of error.
* **Best Used For:** Precision-oriented engineering and quantitative error comparison.

---

### Technique 5: Point-Intrinsic Alpha Saliency (`geom_trust_alpha`)
* **Visual Family:** Point-Intrinsic Modulation
* **Visual Encoding:** Modulates point opacity $\alpha \in [0.10, 1.00]$ directly on the point glyphs without adding secondary geometry.
* **Visual Metaphor:** *"Vivid Signal vs. Ghost Data"*. High-fidelity points stand out sharply; distorted points fade into background translucency.
* **Best Used For:** Minimalist visualizations where no additional visual marks or clutter are permitted.

---

### Technique 6: Stacked Hybrid Mode (Halos + Landscape)
* **Visual Family:** Multi-Channel Hybrid
* **Visual Encoding:** Combines macro-level background GAM terrain (showing broad regional projection quality) with per-point concentric halos (highlighting point-level anomalies).
* **Best Used For:** Multi-scale visual analytics tasks requiring both regional "gist" and individual point verification.

---

### Technique 7: Fidelity Strata Small-Multiples (`facet_trust_strata`)
* **Visual Family:** Multi-View Coordinated Faceting
* **Visual Encoding:** Partitions the scatterplot across 4 discrete quality strata:
  1. Low Fidelity ($[0.00 - 0.60)$)
  2. Moderate Fidelity ($[0.60 - 0.80)$)
  3. High Fidelity ($[0.80 - 0.90)$)
  4. Very High Fidelity ($[0.90 - 1.00]$)
* **Best Used For:** Analytical filtering, progressive data revelation, and comparing clean clusters against noisy outliers.

---

## 3. Theoretical Comparison Matrix

| # | Technique | Bertin (1967) Visual Variable | Cleveland & McGill (1984) Rank | Primary Strength | Perceptual Limitation |
|---|---|---|---|---|---|
| **1** | **Concentric Halos** | Size + Value | Area (4) + Alpha (8) | Resolves flagging paradox | Occlusion at $N > 5000$ |
| **2** | **Fidelity Surface** | Position + Value | Position / Isoline (1) | Macro regional topology | Loses per-point nuance |
| **3** | **Neighbor Tethers** | Position + Length | Length (2) + Direction | Exposes topological tears | Visual clutter in dense areas |
| **4** | **Crosshair Glyphs** | Size (Length) | Length (2) | High quantitative precision | Directional line interference |
| **5** | **Alpha Saliency** | Value / Lightness | Value (8) | Zero clutter / native mark | Hard to spot missing points |
| **6** | **Stacked Hybrid** | Multi-channel | Multi-rank combination | Dual-scale overview + detail | Highest visual density |
| **7** | **Small Multiples** | Position (Panels) | Common Scale (1) | Clean progressive separation | Divided visual attention |

---

## 4. How to Demonstrate in the Interactive Explorer

1. Launch the interactive Shiny dashboard:
   ```r
   shiny::runApp("ggtrust/inst/shiny")
   ```
2. Navigate to the **"🏛️ Multi-Technique Taxonomy Gallery"** tab to view all 6 key techniques rendered side-by-side simultaneously on the active benchmark dataset.
3. Switch between **Iris (t-SNE)**, **Wine (PCA)**, **MNIST-400 Digits**, and **Synthetic Clusters** to observe how each technique handles different types of projection distortion.

