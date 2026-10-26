# ggtrust: Grammar-of-Graphics Fidelity Engine

> **Visualizing Point Reliability in Dimensionality Reduction Scatterplots**  
> *A Multi-Scale Framework for Resolving the Silent Hallucination Crisis in t-SNE, UMAP, and PCA Projections through In-Situ Topological Fidelity Annotations.*

---

## 📌 Overview

Over 80% of modern genomics and high-dimensional data science papers rely on 2D scatterplots (t-SNE, UMAP, PCA) as their primary exploratory medium. However, current visual analytics workflows suffer from the **Silent Hallucination Crisis**: compressing high-dimensional manifolds into 2D coordinates inevitably incurs topological distortion. Standard visualization tools plot these coordinates with uniform graphical confidence, concealing two critical failure modes:

1. **False Intrusions (Impostors):** Unrelated high-dimensional points artificially crammed into close 2D proximity, mimicking genuine biological or statistical similarity.
2. **Torn Extrusions (Exiles):** Homogeneous high-dimensional clusters artificially shattered into disjoint 2D islands, creating the illusion of novel sub-populations.

**ggtrust** bridges this gap by calculating local topological metrics—**Trustworthiness** $T(k, i)$ and **Continuity** $C(k, i)$—via vectorized tensors executing in sub-50ms, and rendering them through a comprehensive suite of **14 Data Visualization Techniques**.

---

## 🏗️ System Architecture & Workflow

![ggtrust System Architecture & Workflow](project_visual_architecture.png)

---

## ✨ Core Features & Visual Analytics Techniques

1. **In-Situ Glyph Encodings (Concentric Gaussian Halos):**
   - Resolves the *Visual Saliency Paradox* by decoupling spatial extent (halo radius commands peripheral awareness) from mark opacity (point fading signals unreliability).
2. **Topological Micro-Inspector Lens:**
   - Real-time interactive query lens rendering green elastic tethers connecting a selected observation to its true high-dimensional neighbors, paired with glowing red warning rings around 2D intruder points.
3. **4-Quadrant Distortion Typology Phase Plane:**
   - Orthogonal diagnostic phase space mapping Trustworthiness $T(k)$ vs Continuity $C(k)$ to classify points into *Faithful Anchors*, *False Impostors*, *Torn Exiles*, and *Critical Artifacts*.
4. **Multi-Scale Scale-Space Stability Horizons:**
   - Evaluates stability curves across a continuum of neighborhood sizes ($k \in [3, 45]$) to overcome *Scale-Space Myopia* and identify phase transitions.
5. **High-Dimensional Parallel Coordinates Plot (PCP) & Co-Ranking:**
   - Integrates 8-axis marker gene brushings colored by continuous manifold fidelity, alongside Co-Ranking rank-error heatmaps and Shepard distance correlation plots ($r = 0.812$).
6. **Dual-Canvas Comparative Validation:**
   - Synchronized side-by-side view contrasting baseline unannotated scatterplots against ggtrust fidelity annotations, complete with automated Python (Scanpy/Plotly) and R (ggplot2/ggtrust) code generation.
7. **Interactive Diagnostic Table & Outlier Filtering:**
   - Searchable, sortable data matrix with in-cell metric progress micro-bars and one-click CSV export for automated downstream quality control.
8. **Operational Impact Assessment & Clinical Decision Support:**
   - 6-axis Radar / Spider profile and clinical risk protocol rules preventing costly false-positive wet-lab assay validations.

---

## 🚀 Quickstart

### Prerequisites
- Python 3.9+
- Recommended packages:
```bash
pip install streamlit plotly numpy scipy scikit-learn pandas python-docx
```

### Running the Interactive Web Dashboard
```bash
streamlit run streamlit_app.py
```
Access the application in your browser at `http://localhost:8501`.

### Generating the Academic Report (.docx)
```bash
python3 build_academic_report.py
```
This compiles the publication-grade 17-page `ACADEMIC_PROJECT_REPORT.docx` with embedded high-resolution figures, formatted tables, and verified hyperlinked citations.

---

## 📁 Repository Structure

```text
├── streamlit_app.py                   # Main interactive Streamlit visual analytics platform
├── build_academic_report.py           # Document compilation script generating 17-page report
├── ACADEMIC_PROJECT_REPORT.md         # Full text academic project report (Markdown format)
├── ACADEMIC_PROJECT_REPORT.docx       # Publication-ready academic project report (Word format)
├── project_visual_architecture.html   # Visual architecture & workflow diagram source (HTML/SVG)
├── project_visual_architecture.png    # High-resolution multi-tier architecture diagram
├── architecture_diagram.html          # System architectural schema source
├── architecture_diagram.png           # System architecture diagram
├── formula_fidelity_math.png          # Mathematical formulation diagram (T, C, S metrics)
├── pipeline_workflow_diagram.png      # Pipeline workflow diagram
├── scrna_technique1_*.png             # High-res technique screenshots & validation figures
├── .streamlit/config.toml             # Streamlit visual theme configuration
└── README.md                          # Project documentation and guide
```

---

## 👥 Project Team

* **Department of Computer Science & Data Science**  
* **Advanced Data Visualization Techniques (ADVT) — Digital Assessment**  
* **Academic Year:** 2025 – 2026

| Candidate Name | Register Number |
| :--- | :--- |
| **S DHAKSHITHA** | 24MID0071 |
| **M SAI LAHARI** | 24MID0061 |
| **KAMESH Y** | 23MID0147 |
| **DHIVYA PRASATH K** | 22MID0072 |
| **SRIVARSHAN** | 23MIC0066 |

---

## 📜 License & Citation
Licensed under the [MIT License](LICENSE). If you utilize this framework or dashboard in your research, please cite the project repository.

