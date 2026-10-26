# Advanced Data Visualization Techniques — Research Project Proposals

**Generated:** July 2026
**Purpose:** 25 research-grade visualization projects addressing documented gaps from the literature survey
**Constraint:** Every project solves one or more explicitly stated limitations from the reviewed papers

---

## Scoring Rubric

| Dimension | Description |
|-----------|-------------|
| Novelty /10 | How underexplored is the specific approach |
| Vis Contribution /10 | How significant is the visual encoding/interaction technique itself |
| Research Strength /10 | How well-grounded in literature and how methodical |
| Implementation Feasibility /10 | Can it be built in R within 4 months |
| Learning Value /10 | What the student learns about core visualization concepts |
| Publication Potential /10 | Likelihood of workshop/short-paper acceptance |
| Portfolio Value /10 | How impressive the demo/prototype looks |

---

# PROJECT 1: Uncertainty Grammar Extension for ggplot2 (ggdistinct)

## 1. Project Title
**ggdistinct: First-Class Uncertainty Primitives for the Grammar of Graphics**

## 2. Research Motivation
Despite decades of research, uncertainty visualization remains fragmented with "no commonly agreed upon methodology, formalisations, or a greater goal" (Kinkeldey et al., cited in The Noisy Work, 2024). The literature explicitly calls for formalizing uncertainty within the grammar of graphics ("Uncertainty needs to be formalised within the grammar of graphics" — The Noisy Work, 2024). Existing R packages (ggdist, tidybayes) provide distribution-focused geoms but do not integrate uncertainty as a first-class aesthetic at the grammar level. Weiskopf (2022) notes "a practical problem is the lack of uncertainty visualization techniques in many existing software systems."

## 3. Papers/Gaps Addressed
- **Section 5 (Uncertainty Visualization):** Gap 1 (no commonly agreed methodology), Gap 5 (lack in existing software), Gap 7 (no systematic UAVA approach), Future Work bullet 2 (formalize uncertainty in grammar of graphics)
- **Section 5, Gillmann et al. (2023):** "Implementation of such a [UAVA] framework was not conducted so far"

## 4. Why Existing Techniques Are Insufficient
ggdist provides distribution geoms (stat_slab, stat_dotinterval) but these are distribution-visualization geoms, not an uncertainty *grammar*. There is no way to add `aes(uncertainty = variable, uncertainty_type = "confidence")` to any geom and have it automatically select an appropriate encoding. Vega-Lite has rudimentary error encoding; ggplot2 has none. The user must manually choose error bars, ribbons, or distribution plots — there is no abstraction layer.

## 5. Visualization Contribution
A new R package that extends ggplot2 with:
- New aesthetic mappings: `uncertainty`, `uncertainty_type`, `confidence_level`, `distribution`
- A grammar rule that automatically resolves uncertainty aesthetics to appropriate visual encodings (gradient transparency for confidence, waviness for fuzziness, animation for HOPs, dotplots for quantiles)
- `geom_uncertainty()` as a unified uncertainty geometry
- `stat_uncertainty()` for computing uncertainty from raw data or model objects
- Theme elements for uncertainty legends

## 6. Novelty Level: **8/10**
The idea of uncertainty in the grammar of graphics has been discussed theoretically but never implemented as a complete, usable R package.

## 7. Technical Difficulty: **7/10**
Requires deep ggplot2 extension (ggproto, S3 methods, stat/geom building). R package development infrastructure.

## 8. Learning Value: **9/10**
Teaches: ggplot2 internals, grammar of graphics theory, uncertainty visualization literature, R package development, visual perception principles.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Simulated data with known uncertainty (Bayesian posterior samples)
- Gapminder with measurement error
- Weather forecast ensembles
- Any dataset with confidence intervals

## 11. Required R Packages
- ggplot2 (extension target)
- ggdist, tidybayes (reference implementations)
- scales, grid (low-level graphics)
- testthat, devtools, roxygen2 (package infrastructure)

## 12. Expected Final Deliverables
- R package on GitHub with vignettes
- 3–5 worked examples using real datasets
- Comparison with existing approaches
- User study or expert review

## 13. Publication Potential: **8/10**
EuroVis Short Papers, VIS Posters, Computational Statistics, R Journal.

## 14. Extension Potential
- Integration with brms/rstanarm for automatic posterior uncertainty
- Shiny interactive uncertainty explorer
- Extend to plotly for interactive uncertainty

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 9 | 8 | 7 | 9 | 8 | 8 | **57/70** |

---

# PROJECT 2: Interactive Hypothetical Outcome Plots with User Steering

## 1. Project Title
**Interactive HOPs: Steering Uncertainty Exploration Through User-Controlled Hypothesis Outcome Plots**

## 2. Research Motivation
Hypothetical Outcome Plots (HOPs) animate individual draws from a distribution to communicate uncertainty. However, Weiskopf (2022) explicitly states: "Interacting with uncertainty visualization... this topic is largely untapped so far." Current HOP implementations (in ggdist, in the wild) are passive animations — users watch, but cannot steer, select, compare, or query individual draws. This project transforms HOPs from passive to interactive.

## 3. Papers/Gaps Addressed
- **Section 5, Weiskopf (2022):** "Interacting with uncertainty visualization... this topic is largely untapped so far"
- **Section 5, Kamal et al. (2021):** Need for interactive uncertainty visualization
- **Section 5, Padilla et al. (2022):** "No one-size-fits-all approaches" — interaction could help users customize

## 4. Why Existing Techniques Are Insufficient
Existing HOPs in ggdist/gganimate are fixed animations: the user presses play and watches draws cycle. There is no way to: pause on a specific draw and inspect its values, select two draws and compare them side-by-side, highlight draws meeting a criterion, request additional draws from regions of the distribution, or annotate draws with domain knowledge.

## 5. Visualization Contribution
An interactive HOP system with:
- Pause/resume/scrub through individual draws
- Draw selection with persistent visual highlighting
- Side-by-side comparison mode for selected draws
- Query-by-brushing: select a region and see draw statistics
- "Request more draws" button that adds new samples from undersampled regions
- Animated transition between individual draws and aggregate distribution
- Narrative annotation linking specific draws to real-world outcomes

## 6. Novelty Level: **8/10**
Interaction with uncertainty is called "largely untapped" by the literature. This directly fills that gap.

## 7. Technical Difficulty: **6/10**
Requires Shiny reactivity, gganimate, plotly integration. Moderate.

## 8. Learning Value: **8/10**
Teaches: animation for uncertainty, interactive visualization design, Bayesian thinking, user control patterns, Shiny reactivity.

## 9. Expected Implementation Time: **6–8 weeks**

## 10. Suitable Datasets
- Election forecast ensembles (538)
- Weather prediction ensembles
- Bayesian regression posteriors
- Monte Carlo simulation results

## 11. Required R Packages
- shiny, shinydashboard (UI)
- gganimate (animation)
- ggdist, tidybayes (distribution data)
- plotly (interactive overlay)
- shinyWidgets (UI controls)

## 12. Expected Final Deliverables
- Interactive Shiny application
- Comparative user study (HOPs vs Interactive HOPs)
- Design guidelines for interactive uncertainty

## 13. Publication Potential: **7/10**
VIS Short Papers, EuroVis, CHI Late-Breaking Work.

## 14. Extension Potential
- Eye-tracking study on how users interact
- Voice-controlled HOPs
- Collaborative HOP exploration

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 8 | 8 | 7 | 8 | **53/70** |

---

# PROJECT 3: Uncertainty Propagation Visualization Across Analytical Pipelines

## 1. Project Title
**UAVA-R: Uncertainty-Aware Visual Analytics Framework for Propagating Uncertainty Through Analytical Pipelines**

## 2. Research Motivation
Gillmann et al. (2023) proposed the Uncertainty-Aware Visual Analytics (UAVA) cycle but note: "There does not exist an approach that provides a theory that describes a systematic approach for UAVA." Weiskopf (2022) calls for "more research to cover further examples of data types and visual analysis with uncertainty propagation." The key challenge is that most uncertainty visualizations focus on a single stage (e.g., final predictions), but users need to understand how uncertainty flows through the entire pipeline.

## 3. Papers/Gaps Addressed
- **Section 5, Gillmann et al. (2023):** No systematic UAVA approach; implementation not conducted
- **Section 5, Weiskopf (2022):** More research on uncertainty propagation
- **Section 5, Kamal et al. (2021):** Need for integrated uncertainty visualization

## 4. Why Existing Techniques Are Insufficient
No existing R tool shows how uncertainty propagates through a pipeline. For example, in a forecasting pipeline: raw data has measurement error → aggregation has sampling uncertainty → model has parameter uncertainty → predictions have forecast intervals. Current tools show only the final forecast interval. Users cannot see which stage contributes most to uncertainty or how uncertainty changes.

## 5. Visualization Contribution
A pipeline visualization framework with:
- Sankey-like flow diagram where edge width = uncertainty magnitude
- Each pipeline stage shows input/output uncertainty distributions
- "Uncertainty amplification factor" visual encoding (color intensity of stage)
- Interactive drill-down: click a stage to see detailed uncertainty decomposition
- Side-by-side comparison of alternative pipelines
- "What-if" sliders to simulate reduced uncertainty at any stage

## 6. Novelty Level: **9/10**
Directly addresses the Gillmann UAVA gap. No existing implementation.

## 7. Technical Difficulty: **8/10**
Requires careful pipeline abstraction, uncertainty propagation math, complex coordinated views.

## 8. Learning Value: **9/10**
Teaches: uncertainty quantification, propagation of errors, pipeline architecture, coordinated multiple views, sensitivity analysis.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Multi-stage survey data (collection → weighting → imputation → estimation)
- Climate model chains (emissions → climate → impact)
- Financial forecasting pipelines
- Medical diagnostic chains (test → model → diagnosis → treatment)

## 11. Required R Packages
- ggplot2, networkD3 (Sankey flows)
- shiny (interaction)
- ggdist (distributions)
- tidybayes (Bayesian uncertainty)
- metR (contour/uncertainty)

## 12. Expected Final Deliverables
- R Shiny application demonstrating UAVA
- Worked examples with 3 different pipeline types
- Design space analysis of uncertainty propagation visualization
- Evaluation with domain experts

## 13. Publication Potential: **9/10**
VIS Full Papers, EuroVis, Computer Graphics Forum.

## 14. Extension Potential
- Uncertainty provenance (where did this uncertainty come from?)
- Real-time uncertainty monitoring
- Decision-focused uncertainty communication

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 9 | 9 | 6 | 9 | 9 | 7 | **58/70** |

---

# PROJECT 4: Cognitive Load-Adaptive Dynamic Network Animation

## 1. Project Title
**CogNet: Cognitive Load-Adaptive Animation for Dynamic Network Visualization**

## 2. Research Motivation
Filipov et al. (2023) identify that "investigating the effect of a user's cognitive load when watching animations [for dynamic networks] is an open challenge." As dynamic networks grow, animations become complex and users lose track of changes. No existing technique adapts animation parameters based on user cognitive state. This project creates the first dynamic network visualization that monitors (via interaction proxies) and adapts to user cognitive load.

## 3. Papers/Gaps Addressed
- **Section 3 (Network Visualization), Filipov et al. (2023):** "User cognitive load when watching animations is an open challenge"
- **Section 4 (Dynamic Graph Visualization):** "Mental map preservation is challenging" (Kale et al., 2023)
- **Section 4, Filipov et al. (2023):** "Closer connection between dynamic network movies to statistical models"

## 4. Why Existing Techniques Are Insufficient
Existing dynamic network tools (Gephi, visNetwork, networkD3) offer fixed animation: all nodes move simultaneously, transitions are uniform speed, and complexity is not modulated. When a network changes dramatically (many nodes appearing/disappearing), users experience high cognitive load but the animation does not adapt — it may even speed up.

## 5. Visualization Contribution
A dynamic network visualization system with:
- Cognitive load estimation via interaction proxies (mouse speed, zoom frequency, pause duration, error rate in follow-tasks)
- Adaptive animation speed: slows during high-load periods, accelerates during low-load
- Adaptive transition complexity: uses gradual opacity fades + position interpolation during high load; full animation during low load
- "Cognitive load heatmap" overlay showing periods of high load on the timeline
- User control to override adaptive mode
- Split attention mode: highlight only changed nodes during high load, show all during low load

## 6. Novelty Level: **9/10**
Cognitive load adaptation in network animation is completely novel. No published work exists.

## 7. Technical Difficulty: **8/10**
Requires cognitive load measurement proxies, real-time animation adaptation, coordination with Shiny reactivity.

## 8. Learning Value: **9/10**
Teaches: cognitive load theory, dynamic network visualization, animation design, real-time user modeling, visual attention.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- ENRON email network (temporal communication)
- DBLP co-authorship over time
- Social network dynamics (Twitter interactions)
- Transportation network changes

## 11. Required R Packages
- gganimate (animation engine)
- igraph, tidygraph (network analysis)
- ggraph (network visualization)
- shiny (interaction)
- shinyjs (interaction tracking)

## 12. Expected Final Deliverables
- Interactive R prototype
- User study comparing adaptive vs. non-adaptive animation
- Design guidelines for cognitive-aware animation
- Cognitive load measurement methodology

## 13. Publication Potential: **8/10**
VIS Short Papers, EuroVis, CHI, IEEE CG&A.

## 14. Extension Potential
- Eye-tracking integration for direct cognitive load measurement
- VR/AR dynamic network adaptation
- Personalized adaptation based on user profile

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 8 | 8 | 6 | 9 | 8 | 9 | **57/70** |

---

# PROJECT 5: Hybrid Timeline-Animation Matrix for Dynamic Multivariate Networks

## 1. Project Title
**DynMarix: Hybrid Timeline-Animation-Matrix Visualization for Dynamic Multivariate Networks**

## 2. Research Motivation
Filipov et al. (2023) state: "Hybrid combinations of timeline and animation approaches are under-explored" for dynamic networks. Kale et al. (2023) further note that "very few studied matrix-based visualizations" for dynamic multivariate networks (DMVNs). This project addresses both gaps by creating a novel hybrid visualization that integrates matrix representation with timeline small-multiples and selective animation.

## 3. Papers/Gaps Addressed
- **Section 4, Filipov et al. (2023):** "Hybrid combinations of timeline and animation approaches are under-explored"
- **Section 4, Kale et al. (2023):** "Very few studied matrix-based visualizations" for DMVNs
- **Section 14 (Matrix Visualization):** Gap 3 — few matrix-based visualizations for DMVNs
- **Section 3, Filipov et al. (2023):** Lack of technique selection guidelines

## 4. Why Existing Techniques Are Insufficient
Existing dynamic network visualizations use either:
- Node-link animation (suffers from mental map issues, edge crossings)
- Timeline small-multiples (requires side-by-side comparison, does not scale)
- Pure matrix (Animatrix style, but lacks multivariate attribute encoding)
None combine all three in a coordinated, task-adaptive manner.

## 5. Visualization Contribution
A coordinated multi-view visualization with:
- **Matrix view:** adjacency matrix reordered by community + animated transitions between time steps
- **Timeline strip:** small multiples of matrix thumbnails for overview
- **Attribute view:** side panel with node/edge attribute evolution (line charts)
- **Animation controller:** play/pause/scrub with variable speed
- **Adaptive representation:** automatically switches between matrix and node-link based on network density threshold
- **Brushing across all views:** select a cell in the matrix → highlight in timeline + attribute views

## 6. Novelty Level: **8/10**
Hybrid matrix-timeline-animation for DMVNs does not exist in the current literature.

## 7. Technical Difficulty: **8/10**
Requires matrix reordering across time steps, smooth animated transitions between matrices, coordinated brushing, dynamic representation switching.

## 8. Learning Value: **9/10**
Teaches: matrix visualization, dynamic network analysis, transition design, coordinated multiple views, network properties.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Dynamic citation networks
- Brain connectivity over time (fMRI)
- Trade flow networks between countries
- Social media interaction networks

## 11. Required R Packages
- igraph, tidygraph (network analysis)
- seriation (matrix reordering)
- ggraph, networkD3 (node-link)
- gganimate (animation)
- heatmaply (interactive matrix)
- shiny (UI coordination)

## 12. Expected Final Deliverables
- Shiny application
- Comparative evaluation with pure animation and pure timeline
- Design guidelines for hybrid dynamic network visualization
- Task taxonomy for DMVN analysis

## 13. Publication Potential: **8/10**
EuroVis, VIS Short Papers, Information Visualization journal.

## 14. Extension Potential
- Web-based version for larger networks
- Integration with statistical change-point detection
- Multi-network comparison mode

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 8 | 6 | 9 | 8 | 8 | **55/70** |

---

# PROJECT 6: Graph Structure-Attribute Correlation Explorer

## 1. Project Title
**StructAttrib: Coordinated Visualization for Exploring Graph Structure–Attribute Correlations**

## 2. Research Motivation
Filipov et al. (2023) identify a critical gap: "No methods fully enable users to correlate the underlying graph structure to its attributes." In many real-world networks, understanding how node attributes relate to network position (e.g., "do central nodes have higher income?") is the primary analytical question, yet no visualization tool supports this directly.

## 3. Papers/Gaps Addressed
- **Section 3, Filipov et al. (2023):** "No methods fully enable users to correlate the underlying graph structure to its attributes"
- **Section 10 (Multivariate Visualization):** Dynamic multivariate visualization open challenge
- **Section 4, Kale et al. (2023):** Challenges visualizing multiple data dimensions simultaneously

## 4. Why Existing Techniques Are Insufficient
Existing tools separate network visualization and attribute analysis. In Gephi, you can color nodes by attribute but cannot systematically explore the relationship between network position (degree, betweenness, community) and attribute distributions. You must export to external tools (R/Python) to compute correlations. There is no linked brushing between a node-link diagram and attribute space.

## 5. Visualization Contribution
A coordinated visualization system with three linked views:
- **Network view:** node-link diagram with nodes colored by attribute, sized by centrality
- **Attribute space view:** PCA/UMAP projection of node attributes with network position encoded as color
- **Correlation matrix view:** heatmap of correlations between structural metrics (degree, betweenness, closeness, PageRank, community membership) and attributes
- **Brushing across all views:** selecting a community in the network shows its attribute distribution; selecting a region in attribute space highlights corresponding nodes
- **Statistical overlay:** trend lines, correlation coefficients, and significance tests embedded in the visualization

## 6. Novelty Level: **8/10**
Directly fills the specific gap identified by Filipov et al. No existing tool provides this exact coordinated setup.

## 7. Technical Difficulty: **7/10**
Requires coordinated brushing, attribute projection, and statistical computation integration.

## 8. Learning Value: **9/10**
Teaches: network analysis, attribute-space projection, coordinated multiple views, statistical graphics, community detection.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Social networks with demographic attributes
- Citation networks with paper metadata
- Biological networks with gene expression attributes
- Transportation networks with station characteristics

## 11. Required R Packages
- igraph, tidygraph (network)
- ggraph (network visualization)
- Rtsne, umap (attribute projection)
- GGally (correlation matrix)
- shiny (coordination)
- plotly (interactive views)

## 12. Expected Final Deliverables
- Interactive Shiny application
- 3 case studies on different network types
- Evaluation with domain experts
- Design pattern documentation

## 13. Publication Potential: **7/10**
EuroVis Short Papers, VIS Posters, IEEE CG&A Applications.

## 14. Extension Potential
- Dynamic version for temporal networks
- Attribute-based graph layout algorithms
- Automated insight reporting

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 7 | 9 | 7 | 7 | **52/70** |

---

# PROJECT 7: Reliability-Aware DR Projection with Trustworthiness Glyphs

## 1. Project Title
**TrustDR: Augmenting Dimensionality Reduction Scatterplots with Projection Trustworthiness Visualizations**

## 2. Research Motivation
"Stop Misusing t-SNE and UMAP in Visual Analytics" (2025) demonstrates widespread misuse of DR techniques and notes these methods "are known to produce unreliable visual representations." The "Unveiling High-dimensional Backstage" survey (CHI 2025) identifies that "scatterplots can hardly inform the original attribute values" and calls for visualizing confidence/trustworthiness alongside projections. Despite this, nearly all DR tools show only the 2D projection without any reliability information.

## 3. Papers/Gaps Addressed
- **Section 9 (High-dimensional Visualization):** Gap 1 (unreliable representations), Gap 2 (misuse from limited discourse), Gap 4 (scatterplots cannot inform original attributes)
- **Section 9, Future Work:** "Communicating DR Limitations" — visualizing confidence/trustworthiness
- **Section 9, Reliable VA survey:** "Limited discussion extending beyond 2D scatterplots"

## 4. Why Existing Techniques Are Insufficient
Rtsne and umap R packages return only the 2D coordinates. Users must separately compute quality metrics (stress, neighborhood preservation, co-ranking). Even then, these are global aggregate numbers — they do not show per-point trustworthiness. No visualization shows, for each point, how reliably it represents its high-dimensional neighborhood.

## 5. Visualization Contribution
Augmented DR scatterplot with:
- **Per-point trustworthiness glyphs:** each point surrounded by a glyph encoding local neighborhood preservation (e.g., pie-slice completeness, concentric ring integrity)
- **Background reliability landscape:** contour map of projection quality across the 2D space
- **Skeptical points highlighting:** points with low trustworthiness are visually flagged (desaturated, jittered, or with uncertainty halos)
- **Interactive verification:** click a point to see its high-D neighbors displayed alongside its 2D neighbors
- **DR quality dashboard:** small multiples showing multiple quality metrics (stress, K-NX, ROC AUC, trustworthiness-continuity)
- **Parameter sensitivity lens:** overlay showing projection changes under different parameters

## 6. Novelty Level: **9/10**
Directly responds to the "Stop Misusing" and "Reliable VA" papers' explicit calls. The per-point glyph approach is novel.

## 7. Technical Difficulty: **7/10**
Requires quality metric computation, glyph design, contour overlay, interactive verification view.

## 8. Learning Value: **9/10**
Teaches: dimensionality reduction theory, projection quality metrics, glyph design, visual communication of reliability, high-D data analysis.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- MNIST (high-D image data)
- Single-cell RNA sequencing data
- Word embedding vectors (GloVe, BERT)
- Any dataset with known cluster structure

## 11. Required R Packages
- Rtsne, umap (projection)
- dimRed (quality metrics)
- ggplot2, ggnewscale (layered plotting)
- scatterplot3d (alternative projections)
- shiny (interaction)

## 12. Expected Final Deliverables
- R package with interactive Shiny app
- Replication of "Stop Misusing" examples with trustworthiness overlay
- User evaluation with practitioners
- Guidelines for communicating DR reliability

## 13. Publication Potential: **9/10**
VIS Full Papers, EuroVis, TVCG, CHI. High-trend topic.

## 14. Extension Potential
- DR technique recommender based on data characteristics
- Multi-projection comparison view
- Autoencoder reliability visualization

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 9 | 8 | 7 | 9 | 9 | 8 | **59/70** |

---

# PROJECT 8: Beyond Scatterplots — Visual Metaphors for Interpreting DR Projections

## 1. Project Title
**GlyphDR: Alternative Visual Metaphors for High-Dimensional Projection Interpretation**

## 2. Research Motivation
The "Unveiling High-dimensional Backstage" survey (CHI 2025) notes "limited discussion extending beyond 2D scatterplots" for visualizing DR results. Scatterplots discard original attribute information — they show only inter-point distances in projection space, not what the original variables mean. For interpretable DR, alternative visual metaphors are needed.

## 3. Papers/Gaps Addressed
- **Section 9, Reliable VA survey (2025):** "Scatterplots can hardly inform the original attribute values"
- **Section 9, Reliable VA survey (2025):** "Limited discussion extending beyond 2D scatterplots"
- **Section 10 (Multivariate Visualization):** Glyph-based methods have limited perceptual precision
- **Section 9, Future Work:** Need for human-centered evaluations of DR

## 4. Why Existing Techniques Are Insufficient
Every DR tool (Rtsne, umap, scikit-learn) outputs a 2D scatterplot. Even advanced tools like Rdimtools only produce coordinates. Users cannot see from the plot why two points are nearby — is it because they share certain attribute values? The projection is a "black box" in terms of interpretability.

## 5. Visualization Contribution
A system implementing and comparing alternative visual metaphors:
- **Star glyphs at each projection point:** each glyph encodes original attribute values as radial spokes
- **Small attribute barcodes:** each projected point has a small horizontal barcode (color = attribute value) below it
- **Attribute-preserving coloring:** intelligent coloring combining multiple attributes via perceptual color blending
- **Linked parallel coordinates:** DR projection + parallel coordinates with records ordered by projection position
- **Attribute subspace projection matrix:** for each attribute, show how it contributes to the projection as a separate panel
- **Interactive metaphor switching:** toggle between metaphors and compare interpretability

## 6. Novelty Level: **8/10**
Goes beyond "scatterplot coloring" to fundamentally rethink how DR projections are visually represented.

## 7. Technical Difficulty: **7/10**
Requires glyph rendering, barcode implementation, coordinated views, evaluation design.

## 8. Learning Value: **9/10**
Teaches: glyph design, perceptual theory, DR interpretation, visual variable effectiveness, evaluation methodology.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Wine quality dataset (13 attributes)
- Iris (4D, known structure)
- Auto MPG dataset
- Any labeled high-D benchmark

## 11. Required R Packages
- Rtsne, umap (projection)
- ggplot2, ggforce (glyph extension)
- GGally (parallel coordinates)
- grid, gridExtra (barcode layout)
- shiny (interaction)
- tourr (for reference)

## 12. Expected Final Deliverables
- Interactive visualization system with 5+ visual metaphors
- User study comparing metaphor effectiveness
- Design guidelines for metaphor selection
- R package for metaphor-based DR visualization

## 13. Publication Potential: **8/10**
VIS Short Papers, EuroVis, Information Visualization journal.

## 14. Extension Potential
- Task-specific metaphor recommendation
- Integration with automated insight detection
- Metaphor customization tool

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 7 | 7 | 9 | 8 | 8 | **55/70** |

---

# PROJECT 9: DR Hyperparameter Sensitivity Surface Visualization

## 1. Project Title
**ParamScope: Visualizing Hyperparameter Sensitivity Surfaces for Dimensionality Reduction**

## 2. Research Motivation
The "Stop Misusing t-SNE and UMAP" paper (2025) explicitly asks for "automated hyperparameter tuning methods... without sacrificing interpretability." DR methods are notoriously sensitive to parameters (t-SNE perplexity, UMAP n_neighbors, min_dist), but users have no visual tool to understand how parameter changes affect the projection. Current practice is trial-and-error.

## 3. Papers/Gaps Addressed
- **Section 9, "Stop Misusing" (2025):** Need for automated hyperparameter tuning without sacrificing interpretability
- **Section 9, Reliable VA survey (2025):** Imbalanced research (46% propose, 12.8% evaluate)
- **Section 9, Kiefer & Rahman (2021):** Performance comparison of DR methods but no parameter sensitivity tool

## 4. Why Existing Techniques Are Insufficient
Rtsne and umap provide no parameter guidance. Users typically try a few values manually. There is no way to visualize the "landscape" of projection quality across the parameter space. Tools like optuna/ray tune provide automated search but no visualization of the parameter-quality relationship.

## 5. Visualization Contribution
A parameter sensitivity visualization system with:
- **Quality landscape heatmap:** 2D heatmap (or 3D surface) of projection quality (trustworthiness, continuity, stress) across two varying parameters
- **Projection gallery:** grid of thumbnail projections at sampled parameter combinations, ordered by quality
- **Animation sweep:** smooth parameter sweeping showing how the projection evolves
- **Optimal region highlighting:** automatically detected regions of high-quality projections
- **Stability map:** areas where small parameter changes cause large projection changes (instability) highlighted in red
- **Recommendation view:** suggested parameter ranges based on data characteristics

## 6. Novelty Level: **7/10**
The concept of parameter sensitivity visualization for DR exists in niche forms but no comprehensive R implementation.

## 7. Technical Difficulty: **7/10**
Requires running many DR computations, designing the quality landscape visualization, gallery rendering.

## 8. Learning Value: **8/10**
Teaches: DR parameter effects, projection quality metrics, sensitivity analysis, landscape visualization, experimental design.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Any high-D dataset where DR is applied
- Synthetic datasets with known structure
- Benchmark classification datasets

## 11. Required R Packages
- Rtsne, umap, dimRed (DR methods)
- ggplot2, plotly (visualization)
- reshape2, tidyr (data wrangling)
- shiny (interaction)

## 12. Expected Final Deliverables
- ParamScope Shiny application
- Case studies with 4+ datasets
- Guidelines for parameter selection
- Replication package for "Stop Misusing" examples

## 13. Publication Potential: **7/10**
EuroVis Short Papers, VIS Posters, IEEE CG&A.

## 14. Extension Potential
- Auto-parameter recommendation via ML
- Integration with mlr3/tidymodels
- Web-based gallery of parameter effects

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50/70** |

---

# PROJECT 10: Provenance Graph Visualization for Analytical Session Sense-Making

## 1. Project Title
**ProvenanceViz: Interactive Visualization of Analytical Provenance Trails**

## 2. Research Motivation
The literature review identifies that "provenance visualization itself is underexplored — how to visualize the provenance graph for sense-making" (Section 7). While provenance *capture* is well-studied (interaction logging, state graphs), the visualization of provenance *for understanding the analytical process* is neglected. Users cannot reflect on their own analytical path or share it with collaborators.

## 3. Papers/Gaps Addressed
- **Section 7 (Provenance Visualization):** Gap 3 (insight vs interaction provenance disconnect), Gap 4 (provenance visualization itself underexplored)
- **Section 7, Possible Research Opportunities:** "Interactive provenance graph visualization: Novel visualization techniques for navigating and exploring analytical provenance trails"
- **Section 7, Ragan et al. (2015):** Foundational taxonomy but no implementation

## 4. Why Existing Techniques Are Insufficient
RStudio history shows code; Tableau shows some interaction logs; but neither visualizes the *analytical reasoning process*. Key events like "user found an insight" vs. "user backtracked" vs. "user explored a dead end" are not distinguished. Provenance is stored as raw logs that are too detailed for sense-making.

## 5. Visualization Contribution
A provenance visualization system with:
- **State transition graph:** nodes = analytical states (at specific visualization configurations), edges = user actions
- **Insight event markers:** special node types for insight discoveries, annotated with user notes
- **Time-tunnel view:** interactive timeline showing the analysis session with activity density, focus changes, and insight moments
- **Provenance tree instead of line:** forks represent exploration branches (different hypotheses), merges represent returning to previous state
- **Attention heatmap:** overlay on the original visualization showing what regions the user spent time looking at
- **Comparative mode:** overlay two analysis sessions to compare analytical paths
- **Provenance summarization:** automatic extraction of key milestones, dead ends, and main discovery path

## 6. Novelty Level: **9/10**
Provenance visualization is identified as "underexplored" in the literature. Comprehensive R implementation does not exist.

## 7. Technical Difficulty: **9/10**
Requires provenance capture infrastructure, state graph rendering, interactive tree visualization, session logging.

## 8. Learning Value: **8/10**
Teaches: provenance concepts, analytical reasoning, graph visualization, session analysis, meta-visualization.

## 9. Expected Implementation Time: **12–14 weeks**

## 10. Suitable Datasets
- Self-generated: log your own Shiny analysis sessions
- Any dataset amenable to exploratory analysis
- Use existing R datasets for demo

## 11. Required R Packages
- shiny, shinydashboard (platform)
- igraph, tidygraph (state graph)
- ggraph (graph visualization)
- plotly (attention heatmap)
- visNetwork (interactive graph)
- rlang (action capture)

## 12. Expected Final Deliverables
- Shiny application with provenance capture and visualization
- User study: does provenance visualization help reflection?
- Taxonomy of provenance visualization techniques
- Open-source framework for provenance in Shiny

## 13. Publication Potential: **9/10**
VIS Full Papers, EuroVis, TVCG, CHI.

## 14. Extension Potential
- Collaborative provenance comparison
- Provenance-driven recommendation
- Provenance storytelling (export analysis path as narrative)

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 8 | 8 | 5 | 8 | 9 | 8 | **55/70** |

---

# PROJECT 11: Comparative Provenance Visualization

## 1. Project Title
**CompareProv: Side-by-Side Comparative Visualization of Analytical Provenance Paths**

## 2. Research Motivation
The literature notes that "evaluative uses of provenance are still relatively sparse" and "no standardized framework for capturing and comparing provenance across different visualization tools" (Section 7). Currently, if two analysts work on the same data, there is no way to visually compare *how* they arrived at their conclusions. This is critical for collaborative analysis, education, and quality assurance.

## 3. Papers/Gaps Addressed
- **Section 7:** Gap 1 (evaluative uses sparse), Gap 2 (no standardized framework for comparison)
- **Section 7, Research Opportunity:** "Comparative provenance visualization: Side-by-side comparison of different analytical paths"

## 4. Why Existing Techniques Are Insufficient
No tool compares analytical provenance paths. Current practice: analysts share their final results (charts, reports) but not the process. Even paired analysis sessions are not visually comparable. The only comparison is manual timeline review.

## 5. Visualization Contribution
A comparative provenance visualization with:
- **Side-by-side provenance trees:** two analysts' state-transition graphs displayed side-by-side with alignment
- **Diff highlighting:** regions where paths diverged/converged highlighted; unique states in green, shared in blue
- **Efficiency metrics overlay:** path length, backtrack count, time-to-insight shown as visual annotations
- **Attention overlay comparison:** which data regions each analyst focused on
- **Synchronized replay:** replay both analysts' sessions simultaneously
- **Merge view:** combined provenance graph showing where paths overlapped and diverged

## 6. Novelty Level: **8/10**
Comparative provenance visualization is essentially nonexistent in current literature.

## 7. Technical Difficulty: **8/10**
Requires session alignment, diff computation, side-by-side rendering, synchronized replay.

## 8. Learning Value: **8/10**
Teaches: provenance, analytical comparison, session alignment, collaborative analysis, efficiency metrics.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Self-generated paired analysis sessions
- Think-aloud protocol data from user studies
- Educational analytics sessions

## 11. Required R Packages
- shiny (platform)
- igraph, ggraph (graph visualization)
- plotly (interactive views)
- dplyr, tidyr (alignment)
- DT (event tables)

## 12. Expected Final Deliverables
- Shiny application for comparative provenance
- Collection of paired analysis sessions
- Evaluation: does comparison improve analytical outcomes?
- Design guidelines for provenance comparison

## 13. Publication Potential: **7/10**
EuroVis Short Papers, CHI Late-Breaking, VIS Workshop.

## 14. Extension Potential
- Classroom use for teaching visualization
- Team analytics for collaborative platforms
- Meta-analysis of analytical strategies

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 6 | 8 | 7 | 7 | **50/70** |

---

# PROJECT 12: Bias Discovery Visual Analytics for ML Pipelines

## 1. Project Title
**BiasVis: Coordinated Visualization for Discovering Data, Label, and Model Bias**

## 2. Research Motivation
Chatzimparmpas et al. (2024) state: "User bias is absent from almost all VA systems" and that "fairness, equality/data bias only recently emerged" as topics in XAI+VIS. Despite growing awareness of algorithmic bias, no visual analytics system comprehensively surfaces bias across all three stages: data bias (skewed distributions), label bias (annotation errors), and model bias (performance disparities across subgroups).

## 3. Papers/Gaps Addressed
- **Section 6 (XAI Visualization):** Gap 1 (user bias absent from VA systems), Gap 6 (fairness only recently emerged)
- **Section 6, Chatzimparmpas et al. (2024):** Open challenge on fairness and bias
- **Section 2 (Visual Analytics), Bikakis et al. (2025):** "Fairness and Trustworthiness" as top new challenge

## 4. Why Existing Techniques Are Insufficient
Tools like SHAP, LIME, DALEX focus on model explainability (feature importance, predictions) but do not systematically expose bias. AIF360 measures fairness metrics but provides limited visualization. There is no integrated visual tool that shows: distribution skew → annotation bias → model performance disparities → fairness metrics in a linked, coordinated manner.

## 5. Visualization Contribution
A bias discovery visualization with:
- **Data bias panel:** comparative distribution plots across subgroups with imbalance metrics; missing data patterns by subgroup
- **Label bias panel:** inter-annotator agreement visualization (alluvial diagram of label changes); label error heatmap
- **Model bias panel:** performance delta across subgroups (accuracy, precision, recall, F1 by group) as difference-from-overall bar chart
- **Intersectional bias lens:** heatmap of performance across pairs of protected attributes
- **Fairness metrics dashboard:** multiple fairness definitions (demographic parity, equal opportunity, predictive parity) shown simultaneously with acceptability thresholds
- **Bias propagation view:** Sankey showing how bias flows from data → labels → model → decisions
- **Counterfactual what-if:** toggle a subgroup's representation and see projected fairness changes

## 6. Novelty Level: **8/10**
Integrated bias visualization across all three pipeline stages does not exist in current tools.

## 7. Technical Difficulty: **7/10**
Requires bias metric computation, coordinated views, fairness library integration.

## 8. Learning Value: **9/10**
Teaches: algorithmic fairness, bias types, fairness metrics, subgroup analysis, ethical AI, XAI visualization.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- COMPAS recidivism data
- Adult Income (UCI)
- German Credit data
- Any dataset with demographic attributes

## 11. Required R Packages
- DALEX, iml (model explanation)
- fairmodels, fairness (fairness metrics)
- ggplot2, plotly (visualization)
- networkD3 (Sankey)
- shiny (interaction)
- recipes, workflows (ML pipeline)

## 12. Expected Final Deliverables
- BiasVis Shiny application
- 3 case studies demonstrating bias discovery
- User evaluation with ML practitioners
- Guidelines for bias visualization design

## 13. Publication Potential: **9/10**
VIS Full Papers, FAccT, AIES, CHI. Very high-trend topic.

## 14. Extension Potential
- Integration with LLM bias detection
- Longitudinal bias monitoring
- Regulatory compliance reporting

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 9 | 7 | 9 | 9 | 8 | **58/70** |

---

# PROJECT 13: Expertise-Adaptive XAI Visualization Framework

## 1. Project Title
**AdaptXAI: An Expertise-Adaptive Visualization Framework for Explainable AI**

## 2. Research Motivation
Chatzimparmpas et al. (2024) identify that "beginners and model developers are the two least represented target groups" in XAI visualization and that "customizable and reconfigurable visualizations that consider the users' experience level... remain largely underresearched." Most XAI tools assume a technical audience and present SHAP/LIME plots without adaptation.

## 3. Papers/Gaps Addressed
- **Section 6:** Gap 2 (beginners and developers least represented), Gap 3 (customizable visualizations for user experience level under-researched)
- **Section 6, Chatzimparmpas et al. (2024):** O1 — improving interactivity and visual representations of existing XAI methods
- **Section 2 (Visual Analytics):** "Enable visualization for non-expert users" (Bikakis et al., 2025)

## 4. Why Existing Techniques Are Insufficient
SHAP summary plots, LIME explanations, and partial dependence plots are designed for data scientists. A business stakeholder or domain expert without ML training sees them as incomprehensible. Current tools offer no adaptation: the same visualization is shown regardless of user expertise.

## 5. Visualization Contribution
Adaptive XAI visualization with three expertise levels:
- **Novice mode:** natural language explanations of model behavior, simple bar charts of "top 5 reasons," iconic representations, no math notation
- **Practitioner mode:** standard SHAP/LIME plots with guided annotations, interactive filtering, color-coded feature importance
- **Developer mode:** full technical detail with uncertainty quantification, feature interaction detection, model comparison, debugging views
- **Smooth transitions between levels:** progressive disclosure with "show more detail" expanders
- **Expertise assessment:** brief pre-test questionnaire to set initial level; user can override
- **Explanation traceability:** every claim (e.g., "income is the most important factor") linked to its supporting visualization

## 6. Novelty Level: **8/10**
Adaptive XAI is called out as "underresearched" by the literature. No comprehensive implementation exists.

## 7. Technical Difficulty: **7/10**
Requires expertise level modeling, progressive disclosure, multiple rendering pipelines.

## 8. Learning Value: **8/10**
Teaches: XAI methods, visual literacy, adaptive interfaces, progressive disclosure, explanation design.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Any classification dataset with interpretable features
- Credit scoring, housing prices, customer churn

## 11. Required R Packages
- DALEX, iml (model explanation)
- shiny (platform)
- ggplot2, plotly (visualization)
- shinyMobile (if mobile support)
- shinyWidgets (UI controls)

## 12. Expected Final Deliverables
- AdaptXAI Shiny application
- User study with 3 expertise groups
- Design patterns for adaptive XAI
- Evaluation of adaptation effectiveness

## 13. Publication Potential: **8/10**
EuroVis, VIS Short Papers, CHI, IUI.

## 14. Extension Potential
- Domain-adaptive explanations (medical, financial, legal)
- Visual literacy assessment integration
- Multi-language explanation support

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 8 | 7 | 8 | 8 | 8 | **54/70** |

---

# PROJECT 14: Visual Analytics for Reinforcement Learning Training Dynamics

## 1. Project Title
**RL-Vis: Visualizing Reinforcement Learning Training Dynamics**

## 2. Research Motivation
Chatzimparmpas et al. (2024) explicitly state that "reinforcement learning is also mostly ignored" in XAI+VIS visualization research. RL training is fundamentally different from supervised learning: agents explore, learn from delayed rewards, and their behavior evolves non-monotonically. No existing visualization tool adequately captures RL training dynamics.

## 3. Papers/Gaps Addressed
- **Section 6, Chatzimparmpas et al. (2024):** "Reinforcement learning is also mostly ignored"
- **Section 6, Gap 4:** "Real-time online training processes... current methods mainly focus on analyzing the outcomes... neglecting the potential for an interactive training process"
- **Section 8 (Streaming Data):** Streaming data visualization challenges (change perception)

## 4. Why Existing Techniques Are Insufficient
TensorBoard provides basic RL reward curves but nothing about the agent's internal learning dynamics. There is no visualization of: policy entropy over time, state visitation frequency, Q-value distributions, exploration vs. exploitation balance, or policy landscape changes. Understanding why an RL agent fails requires seeing these dynamics.

## 5. Visualization Contribution
A visualization suite for RL training with:
- **Policy landscape river plot:** how action probabilities change over training (similar to topic evolution stream graph)
- **State visitation heatmap:** which states the agent visits most/least over time, overlaid on environment state space
- **Q-value uncertainty fan:** for each state-action pair, show Q-value with uncertainty (distribution over training)
- **Reward decomposition stacked area:** decompose total reward into components over episodes
- **Exploration-exploitation gauge:** real-time indicator of exploration rate, policy entropy, and action diversity
- **Training trajectory view:** 2D projection of policy parameters over time, colored by performance
- **Episode replay with overlays:** watch the agent act with behavioral overlays (which action was chosen, Q-values, etc.)

## 6. Novelty Level: **9/10**
RL visualization is explicitly identified as "mostly ignored" in the literature. This would be among the first comprehensive RL training visualizations.

## 7. Technical Difficulty: **9/10**
Requires RL training infrastructure, data extraction, streaming visualization, complex coordinated views.

## 8. Learning Value: **9/10**
Teaches: reinforcement learning theory, streaming visualization, policy analysis, behavioral visualization, non-monotonic training dynamics.

## 9. Expected Implementation Time: **12–14 weeks**

## 10. Suitable Datasets
- Self-generated: train RL agents (cartpole, lunar lander, atari)
- OpenAI Gym environments
- Saved RL training logs (RLlib, Stable Baselines)

## 11. Required R Packages
- shiny (platform)
- gganimate (animation)
- ggplot2, plotly (charts)
- igraph (policy landscape as graph)
- reticulate (interface with Python RL libraries)
- ggridges (reward distributions)

## 12. Expected Final Deliverables
- RL-Vis Shiny application
- Training data from 3+ RL environments
- Case studies showing insight discovery
- Design guidelines for RL training visualization

## 13. Publication Potential: **9/10**
VIS Full Papers, EuroVis, NeurIPS Visualization Workshop, RL-focused venues.

## 14. Extension Potential
- Real-time agent steering during training
- Multi-agent training visualization
- Curriculum learning visualization

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 8 | 7 | 6 | 9 | 9 | 9 | **57/70** |

---

# PROJECT 15: Real-Time Progressive Model Training Visualization

## 1. Project Title
**ProgressTrain: Progressive Streaming Visualization of Machine Learning Model Training**

## 2. Research Motivation
Chatzimparmpas et al. (2025) note that "current methods mainly focus on analyzing the outcomes... neglecting the potential for an interactive training process." Ulmer et al. (2024) find that "real-time processing was only necessary for four out of the 14 temporal progressive visualizations" — most systems do not truly operate in real-time. This project creates a progressive visualization system that updates during model training, allowing users to see and steer the training process.

## 3. Papers/Gaps Addressed
- **Section 6, Gap 4:** Real-time online training processes neglected
- **Section 8 (Streaming Data), Ulmer et al. (2024):** "A focus on real-time processing is almost non-existent"
- **Section 8, Ulmer et al. (2024):** "Progressive algorithms suffer from being unstable in the beginning, resulting in frequent overwriting update patterns"
- **Section 8, Castanheira et al. (2021):** ML-based transition triggering

## 4. Why Existing Techniques Are Insufficient
TensorBoard logs and plots after training, not during. Users watch a progress bar but cannot see the loss landscape evolving, parameter space exploration, or gradient dynamics. There is no progressive visualization that works during training with stability guarantees.

## 5. Visualization Contribution
A streaming progressive visualization system with:
- **Live loss landscape contour:** 2D projection of the loss surface around current parameters, updating as training progresses
- **Parameter trajectory trail:** path of parameters through 2D projection space, with fading trail (older = more transparent)
- **Gradient flow stream:** river plot of gradient magnitudes per layer over time
- **Progressive stability indicator:** visual encoding of estimate stability (wobbliness → solid as training stabilizes)
- **Early warning system:** when progressive updates are unstable, automatically smooths or aggregates
- **Training health dashboard:** learning rate, gradient norm, parameter norm, loss in coordinated streaming views
- **Interactive intervention:** pause training, adjust learning rate, revert to checkpoint — all from the visualization

## 6. Novelty Level: **8/10**
Real-time progressive training visualization with stability guarantees does not exist.

## 7. Technical Difficulty: **9/10**
Requires real-time model training, streaming data pipeline, progressive update computation, stability metrics.

## 8. Learning Value: **9/10**
Teaches: progressive visualization, streaming data, model training dynamics, loss landscape geometry, gradient-based optimization.

## 9. Expected Implementation Time: **12–14 weeks**

## 10. Suitable Datasets
- Self-generated during model training
- Image classification (small models for fast training)
- tabular regression/classification

## 11. Required R Packages
- keras/torch (model training)
- shiny (real-time UI)
- plotly (streaming charts)
- gganimate (animation)
- promises, future (async processing)
- glmnet, xgboost (fast training models)

## 12. Expected Final Deliverables
- ProgressTrain Shiny application
- Demonstration with 3 model types
- Evaluation of progressive update quality vs. latency
- Guidelines for progressive training visualization

## 13. Publication Potential: **8/10**
VIS Short Papers, EuroVis, ICML Visualization Workshop.

## 14. Extension Potential
- Integration with MLflow/W&B
- Multi-model training comparison
- AutoML visualization

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 7 | 6 | 9 | 8 | 9 | **55/70** |

---

# PROJECT 16: Change Perception-Optimized Streaming Scatterplot

## 1. Project Title
**StreamSense: Intelligent Transition Selection for Streaming Scatterplot Visualization**

## 2. Research Motivation
Dasgupta et al. (2018) ask: "How does the state-of-the-art streaming visualization design address... challenges in change perception?" remains an open question. Castanheira et al. (2021) call for "exploring machine learning techniques so that a transition is triggered when needed." Current streaming scatterplots use a single transition type (usually position interpolation) regardless of the type of data change.

## 3. Papers/Gaps Addressed
- **Section 8 (Streaming Data):** Gap 6 (change perception open question), Gap 2 (mental map vs. information currency trade-off)
- **Section 8, Castanheira et al. (2021):** ML-based transition triggering
- **Section 8, Future Work:** Research agenda for change perception in streaming

## 4. Why Existing Techniques Are Insufficient
plotly and Shiny streaming render new points appearing/animated but use a fixed transition strategy. When new points appear, existing points may shift; when points disappear, they vanish abruptly. No system considers the *type* of change (appearance, disappearance, movement, split, merge) and selects the optimal transition accordingly.

## 5. Visualization Contribution
An intelligent streaming scatterplot with:
- **Change event classification:** automatically detects 5 change types (new point appearance, point disappearance, point movement, cluster split, cluster merge)
- **Transition type selection:** maps each change type to an optimal transition (appearance = gradual opacity fade-in; disappearance = shrink to point; movement = position interpolation with trail; split = animated separation from parent; merge = convergence animation)
- **Attention-guiding highlights:** new/changed points briefly highlighted with pre-attentive cues (color flash, motion)
- **Mental map preservation indicators:** show which regions are stable vs. changing using background tint
- **Adaptive animation speed:** faster for minor changes, slower for major structural changes
- **User preference learning:** remembers user transition preferences

## 6. Novelty Level: **8/10**
No streaming scatterplot implements change-type-aware transition selection.

## 7. Technical Difficulty: **8/10**
Requires change detection algorithm, transition design, real-time classification, smooth animation orchestration.

## 8. Learning Value: **9/10**
Teaches: streaming visualization, change perception, animated transitions, pre-attentive processing, mental map theory.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Twitter streaming data
- Sensor/IoT streaming data
- Stock market tick data
- Weather station updates

## 11. Required R Packages
- shiny (streaming platform)
- plotly (interactive scatterplot)
- gganimate (animation)
- dplyr (window operations)
- shinyWidgets (controls)
- mgcv (change detection smoothing)

## 12. Expected Final Deliverables
- StreamSense Shiny application
- User study: StreamSense vs. standard streaming scatterplot
- Transition taxonomy and design guidelines
- Change detection algorithm evaluation

## 13. Publication Potential: **8/10**
VIS Short Papers, EuroVis, CHI.

## 14. Extension Potential
- Apply to other chart types (streaming bar, streaming line)
- VR streaming visualization
- Personalized transition models

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 7 | 6 | 9 | 8 | 8 | **54/70** |

---

# PROJECT 17: Progressive Streaming with Visual Quality Guarantees

## 1. Project Title
**QualStream: Progressive Streaming Visualization with Explicit Visual Quality Encoding**

## 2. Research Motivation
Ulmer et al. (2024) identify that "progressive algorithms suffer from being unstable in the beginning, resulting in frequent overwriting update patterns" and that "quality vs. latency trade-offs are poorly understood" for progressive streaming algorithms. Users of streaming visualizations have no way to know if what they are seeing is stable or will change.

## 3. Papers/Gaps Addressed
- **Section 8, Ulmer et al. (2024):** Progressive algorithm instability; quality vs. latency trade-offs
- **Section 8, Shilpika et al. (2022):** Computational cost and cognitive load trade-offs
- **Section 5 (Uncertainty Visualization):** Need for uncertainty communication in all visualization types

## 4. Why Existing Techniques Are Insufficient
Streaming visualizations present results without indicating stability. In progressive computation, early results are based on partial data and may be misleading. Users cannot distinguish between "this is a stable pattern" and "this will change as more data arrives."

## 5. Visualization Contribution
A progressive streaming visualization framework with:
- **Quality-as-opacity:** transparency of visual marks encodes estimate stability (faint = unstable, solid = stable)
- **Convergence indicators:** small sparklines at each data point showing its value trajectory as more data arrives
- **Flicker visualization:** when updates cause rapid changes, show a "flicker frequency" indicator
- **Stability heatmap background:** background grid cells tinted by stability of aggregates within
- **Quality gauge:** global indicator showing overall stability of the current visualization
- **Confidence envelope:** for trend lines, show widening/narrowing confidence as data accumulates
- **User-controllable quality threshold:** slider to hide data below a stability threshold

## 6. Novelty Level: **8/10**
Explicit visual encoding of progressive quality/stability in streaming visualization is novel.

## 7. Technical Difficulty: **8/10**
Requires progressive computation, stability metrics, dynamic opacity control, real-time constraint satisfaction.

## 8. Learning Value: **8/10**
Teaches: progressive visualization, streaming algorithms, stability metrics, visual encoding of confidence, quality-latency trade-offs.

## 9. Expected Implementation Time: **10–12 weeks**

## 10. Suitable Datasets
- Real-time sensor streams
- Progressive k-means clustering on streams
- Streaming regression
- Online learning model outputs

## 11. Required R Packages
- shiny (streaming)
- plotly (interactive)
- dplyr (windowed computation)
- shinycssloaders (loading states)
- assertthat (quality constraints)

## 12. Expected Final Deliverables
- QualStream Shiny application
- Comparative study: with vs. without quality encoding
- Stability metric evaluation
- Design guidelines for progressive quality visualization

## 13. Publication Potential: **7/10**
EuroVis Short Papers, VIS Posters, IEEE CG&A.

## 14. Extension Potential
- Quality-preserving streaming (throttle data when unstable)
- Integration with streaming ML
- Feedback loop: user adjusts quality threshold ↔ data rate

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 7 | 8 | 7 | 7 | **51/70** |

---

# PROJECT 18: Perceptually-Optimized Parallel Coordinates with Adaptive Axis Reordering

## 1. Project Title
**PercepCoord: Perceptually-Optimized Interactive Parallel Coordinates with Adaptive Axis Reordering**

## 2. Research Motivation
The literature identifies two critical gaps: "Ordering of axes in parallel coordinates significantly impacts interpretability but no principled method exists" (Section 10) and parallel coordinates "suffer from visual clutter with large datasets" (Section 10). Current implementations use correlation-based reordering but ignore perceptual factors like visual separation, hue discriminability, and pattern emergence.

## 3. Papers/Gaps Addressed
- **Section 10 (Multivariate Visualization):** Gap 1 (visual clutter), Gap 2 (axis ordering — no principled method), Gap 6 (interaction techniques underdeveloped)
- **Section 10, Research Opportunity:** "Intelligent axis reordering for parallel coordinates"

## 4. Why Existing Techniques Are Insufficient
GGally's ggparcoord and plotly's parallel coordinates use default or correlation-ordered axes. Correlation ordering finds mathematically similar axes but does not consider perceptual clarity: whether patterns are discernible, whether colors are discriminable, whether line crossings are minimized. No tool optimizes for both mathematical and perceptual quality.

## 5. Visualization Contribution
A parallel coordinates system with:
- **Perceptual quality metrics:** new metrics for parallel coordinate quality (visual separation, pattern coherence, crossing density, color discriminability)
- **Multi-objective axis reordering:** optimizes for both statistical correlation and perceptual quality using Pareto optimization
- **Interactive drag-and-drop reorder:** users drag axes with real-time quality metric feedback
- **Clutter reduction techniques:** edge bundling (grouping similar lines), opacity gradient (dense regions = higher opacity), axis jittering
- **Focus+context brushing:** brush a subset of lines → remaining lines fade to background
- **Axis reflection optimization:** flip axis direction to minimize crossings
- **Reordering animation:** smooth transition between axis orderings to preserve mental map

## 6. Novelty Level: **8/10**
Perceptual optimization for parallel coordinates does not exist in current tools. Multi-objective reordering combining correlation + perception is novel.

## 7. Technical Difficulty: **7/10**
Requires perceptual metric design, optimization algorithm, interactive drag-and-drop, real-time metric computation.

## 8. Learning Value: **9/10**
Teaches: parallel coordinates theory, perceptual quality metrics, multi-objective optimization, clutter reduction, visual interaction.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Any dataset with 6–20 numeric variables
- Auto MPG, wine quality, iris, cancer
- High-dimensional biological data

## 11. Required R Packages
- ggplot2, GGally (base)
- plotly (interactive parallel coordinates)
- shiny (platform)
- cluster, seriation (reordering)
- GGally (extension)
- colorspace (perceptual color)

## 12. Expected Final Deliverables
- PercepCoord Shiny application
- Comparative evaluation: perceptual vs. correlation ordering
- Perceptual quality metric validation
- Design guidelines for parallel coordinate ordering

## 13. Publication Potential: **7/10**
EuroVis Short Papers, Information Visualization journal, VIS Posters.

## 14. Extension Potential
- Task-specific reordering (classification, clustering, outlier detection)
- Integration with tourr for dynamic projection pursuit
- User study on ordering preferences

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 7 | 9 | 7 | 7 | **52/70** |

---

# PROJECT 19: Scalable Perceptual Glyph Design System for Multivariate Data

## 1. Project Title
**PercepGlyph: Perceptually-Calibrated Glyph Design System for Multivariate Visualization**

## 2. Research Motivation
The literature identifies that "glyph-based methods have limited perceptual precision and high cognitive load" (Section 10). Glyph effectiveness depends on the match between visual channels (size, shape, color, orientation, texture) and data types (categorical, ordinal, quantitative). No system provides perceptually-calibrated glyph assignment with known precision estimates.

## 3. Papers/Gaps Addressed
- **Section 10:** Gap 4 (glyph-based methods have limited perceptual precision)
- **Section 9 (High-dimensional):** "Beyond scatterplots" for attribute interpretation
- **Section 5 (Uncertainty):** Glyph-based uncertainty encoding (waviness, fuzziness)

## 4. Why Existing Techniques Are Insufficient
Star glyphs, Chernoff faces, and radar charts in R (stars, fmsb, ggradar) provide glyph construction but no perceptual guidance. Users arbitrarily assign variables to visual channels without understanding perceptual precision (e.g., length is more precise than area; hue is categorical, not ordinal). No tool provides perceptually-calibrated defaults.

## 5. Visualization Contribution
A glyph design system with:
- **Perceptual calibration table:** for each visual channel, provide known perceptual precision (Just Noticeable Difference, discriminability, ordering) based on Cleveland & McGill + recent studies
- **Intelligent variable-channel mapping:** algorithm that optimally assigns variables to channels based on data type and perceptual precision
- **Glyph gallery:** interactive comparison of different glyph types (star, bar, line, polygon, Chernoff) on the same data
- **Glyph legend as interactive widget:** click a glyph component to see its data mapping
- **Hybrid glyph+plot:** small glyphs at scatterplot points (like Project 7 but generalized)
- **Cognitive load estimator:** predicts cognitive load based on glyph complexity (number of channels, visual crowding)
- **Perceptual diagnostic:** highlights problematic assignments (e.g., quantitative variable mapped to hue)

## 6. Novelty Level: **7/10**
Perceptually-calibrated glyph assignment is a known concept but no comprehensive R implementation exists.

## 7. Technical Difficulty: **6/10**
Mainly about integrating existing perceptual knowledge into a usable system. Rendering is straightforward.

## 8. Learning Value: **9/10**
Teaches: glyph design, visual perception, Cleveland & McGill rankings, visual variable effectiveness, cognitive load theory.

## 9. Expected Implementation Time: **6–8 weeks**

## 10. Suitable Datasets
- Any dataset with 5–15 variables
- Environmental monitoring data
- Quality control multivariate data

## 11. Required R Packages
- ggplot2, ggforce (glyph construction)
- fmsb, ggradar (reference)
- grid, gridExtra (layout)
- shiny (interaction)
- colorspace (perceptual color)

## 12. Expected Final Deliverables
- PercepGlyph R package
- Interactive glyph configuration tool
- User evaluation: calibrated vs. uncalibrated glyphs
- Perceptual calibration dataset and methodology

## 13. Publication Potential: **6/10**
VIS Posters, EuroVis Short Papers, IEEE CG&A.

## 14. Extension Potential
- Integration with tourr for dynamic glyphs
- VR glyph exploration
- Accessibility-focused glyph design

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 7 | 7 | 7 | 8 | 9 | 6 | 7 | **51/70** |

---

# PROJECT 20: Multi-Granularity Temporal Visualization with Smooth Semantic Zooming

## 1. Project Title
**TimeLens: Smooth Semantic Zooming Across Temporal Granularities**

## 2. Research Motivation
The literature identifies that "multiple time granularities — switching between years, months, days, hours in a single coherent view is challenging" (Section 15). When analysts zoom from decades to hours, they lose context and must manually respecify visual encodings. No tool provides smooth, semantically-aware transitions between time scales.

## 3. Papers/Gaps Addressed
- **Section 15 (Temporal Visualization):** Gap 1 (multiple time granularities), Gap 3 (scalability in time), Gap 6 (comparative time series)
- **Section 9 (Interactive Visualization):** Focus+context techniques

## 4. Why Existing Techniques Are Insufficient
dygraphs and highcharter provide zoom/pan on time series but the granularity transition is abrupt. At year level, data is aggregated to yearly values; zoom to days, and individual points appear. There is no smooth transition, no automatic aggregation, and no visual consistency across granularities. The encoding does not adapt to the temporal scale.

## 5. Visualization Contribution
A temporal visualization with smooth semantic zooming:
- **Continuous granularity axis:** a slider representing granularity from decade to second; as it moves, the visualization smoothly transforms
- **Granularity-appropriate encodings:** at coarse granularity → trend line + confidence band; at medium → bar/area with seasonal coloring; at fine → individual points with sparklines
- **Semantic transition animation:** smooth morphing between visual encodings as granularity changes
- **Context preservation:** at any zoom level, show a miniature overview (like Google Maps minimap)
- **Pattern persistence:** patterns detected at coarse level (trends, cycles) are highlighted when zooming in
- **Multi-series comparison ring:** outer ring shows comparison of selected time series at the current granularity

## 6. Novelty Level: **7/10**
Smooth semantic zooming for time series is conceptually known but no polished R implementation exists.

## 7. Technical Difficulty: **7/10**
Requires dynamic aggregation, smooth visual transitions, appropriate encoding selection at each scale.

## 8. Learning Value: **8/10**
Teaches: temporal aggregation, semantic zoom, multi-granularity visualization, pattern preservation, focus+context.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Economic time series (FRED)
- Climate time series (long-term + daily)
- Stock market data
- Website analytics over years

## 11. Required R Packages
- ggplot2 (base)
- plotly (interactive)
- shiny (platform)
- slider (rolling windows)
- timetk, tsibble (temporal data)
- feasts (decomposition)

## 12. Expected Final Deliverables
- TimeLens Shiny application
- Case studies with 3 multi-granularity datasets
- Encoding granularity mapping guidelines
- User evaluation of semantic zoom usability

## 13. Publication Potential: **7/10**
VIS Short Papers, EuroVis, Information Visualization journal.

## 14. Extension Potential
- Integration with streaming temporal data
- Multi-user temporal analysis
- Automated pattern detection at each granularity

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50/70** |

---

# PROJECT 21: Cyclic-Linear Temporal Integration Visualization

## 1. Project Title
**CycleLine: Integrating Cyclic and Linear Temporal Patterns in a Unified Visualization**

## 2. Research Motivation
"Cyclic vs. linear time representation — integrating periodic patterns with overall trends" is identified as a key challenge (Section 15). Standard line charts show trends well but obscure daily/weekly/monthly cycles. Calendar views show cycles but lose trend context. No single visualization effectively communicates both simultaneously.

## 3. Papers/Gaps Addressed
- **Section 15:** Gap 2 (cyclic vs. linear time representation)
- **Section 15:** Gap 4 (uncertainty in temporal data — forecasts combine cyclic and trend)
- **Section 10 (Multivariate):** Multiple temporal variables with cyclic patterns

## 4. Why Existing Techniques Are Insufficient
Line charts show trends; seasonal decomposition plots separate components; calendar heatmaps show daily patterns. But these are separate views. Analysts must mentally integrate cyclic and linear patterns. There is no unified visual encoding that simultaneously shows: Is there a long-term trend? Is the weekly pattern changing over time? Are cycles amplifying or dampening?

## 5. Visualization Contribution
A unified cyclic-linear visualization with:
- **Polar + Cartesian hybrid:** main chart is Cartesian (time × value); overlaid polar "rings" show typical cyclic pattern at each time point
- **Cycle strip:** below the main chart, a color strip shows the cyclic context (hour of day, day of week, month) for each data point
- **Cycle decomposition fan:** for any selected time window, show the typical cycle as a polar plot (radar) with current period highlighted
- **Cycle evolution stream:** a stream graph showing how the cyclic pattern itself evolves over time (e.g., weekday peak shifting)
- **Anomalous period highlighting:** periods where the cyclic pattern deviates from historical norm are highlighted
- **Interactive cycle selection:** user chooses which cycle to visualize (daily, weekly, monthly, annual) and sees its interaction with trend

## 6. Novelty Level: **8/10**
Unified cyclic-linear visualization that shows both simultaneously in an integrated encoding is novel.

## 7. Technical Difficulty: **7/10**
Requires complex layout combining polar and Cartesian coordinates, cycle decomposition, anomaly detection.

## 8. Learning Value: **8/10**
Teaches: cyclical data analysis, time series decomposition, polar vs. Cartesian coordinates, pattern interaction, anomaly visualization.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Weather/climate data (daily + annual cycles)
- Traffic data (hourly + weekly cycles)
- Energy consumption (daily + seasonal)
- Social media activity patterns

## 11. Required R Packages
- ggplot2, coord_polar (polar charts)
- plotly (interactive)
- shiny (platform)
- feasts, tsibble (decomposition)
- gganimate (cycle evolution animation)
- metR (contour for cycle heatmaps)

## 12. Expected Final Deliverables
- CycleLine Shiny application
- Case studies with 3 datasets having strong cycles
- User study: CycleLine vs. separate trend + cycle views
- Design patterns for cyclic-linear integration

## 13. Publication Potential: **8/10**
EuroVis, VIS Short Papers, Information Visualization journal.

## 14. Extension Potential
- Multi-cycle interaction (daily × weekly × annual)
- Forecasting with uncertainty over cycles
- Anomaly detection in cyclic patterns

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 7 | 7 | 8 | 8 | 8 | **54/70** |

---

# PROJECT 22: Dynamic Matrix Visualization for Temporal Network Evolution

## 1. Project Title
**AnimatrixR: Dynamic Matrix Visualization for Temporal Network Evolution**

## 2. Research Motivation
Kale et al. (2023) identify that "very few studied matrix-based visualizations" exist for dynamic multivariate networks. Matrix visualizations offer advantages for dense networks (no edge crossings, stable layout) but their dynamic variants (Animatrix, DynTrix) are underexplored. No R implementation exists for interactive dynamic matrix visualization.

## 3. Papers/Gaps Addressed
- **Section 14 (Matrix Visualization):** Gap 3 (few matrix-based DMVN visualizations), Gap 6 (limited interaction techniques)
- **Section 4 (Dynamic Graph):** Gap 2 (visual scalability), Gap 5 (hybrid timeline+animation under-explored)
- **Section 4, Kale et al. (2023):** Need for DMVN visualization tools

## 4. Why Existing Techniques Are Insufficient
No R package provides animated matrix visualization. heatmaply provides static/interactive heatmaps but not for network evolution. seriation provides reordering algorithms but no animation. Dynamic network tools (visNetwork, networkD3) focus on node-link diagrams. Matrix-based dynamic visualization is entirely absent from the R ecosystem.

## 5. Visualization Contribution
An interactive dynamic matrix visualization with:
- **Matrix animation:** adjacency matrix cells smoothly transition between time steps (appearance: fade in; disappearance: fade out; weight change: color interpolation)
- **Reordering preservation:** matrix reordering is consistent across time steps to preserve mental map, with smooth transition when reordering is necessary
- **Time slider:** scrub through time with real-time matrix update
- **Path tracing overlay:** user selects a node pair and sees their interaction history highlighted across the matrix time series
- **Multivariate encoding:** cell color = edge weight, cell border = edge type, cell size = interaction frequency
- **Aggregation zoom:** at coarse time granularity, show aggregate matrix; zoom to finer granularity
- **Comparison mode:** side-by-side matrices for selected time points with diff highlighting

## 6. Novelty Level: **8/10**
Dynamic matrix visualization is explicitly identified as under-explored. No R implementation exists.

## 7. Technical Difficulty: **7/10**
Requires matrix reordering across time, smooth cell animation, path tracing, aggregation.

## 8. Learning Value: **8/10**
Teaches: matrix visualization, dynamic networks, reordering algorithms, animation design, temporal network analysis.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Dynamic citation/co-authorship networks
- Brain connectivity time series
- Trade networks over time
- Email communication networks

## 11. Required R Packages
- seriation (matrix reordering)
- heatmaply (interactive heatmap reference)
- tidygraph, igraph (network)
- gganimate (animation)
- shiny (platform)
- plotly (interactive cells)

## 12. Expected Final Deliverables
- AnimatrixR Shiny application
- Comparison with node-link animation
- Reordering stability evaluation
- Case studies on temporal network datasets

## 13. Publication Potential: **7/10**
EuroVis Short Papers, VIS Posters, Information Visualization journal.

## 14. Extension Potential
- Hybrid matrix+node-link switching
- Integration with multivariate attributes
- Multi-network comparison

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 7 | 7 | 7 | 8 | 7 | 7 | **51/70** |

---

# PROJECT 23: Human-in-the-Loop Matrix Reordering with Perceptual Feedback

## 1. Project Title
**ReorderMe: Interactive Human-in-the-Loop Matrix Reordering with Perceptual Quality Feedback**

## 2. Research Motivation
The literature notes that "reordering algorithms are NP-hard — heuristics provide suboptimal results" (Section 14) and calls for "perceptually-optimized matrix reordering — reordering algorithms that optimize for human pattern perception, not just algorithmic criteria" (Section 14). Current reordering is fully automatic; users cannot guide the process based on their perceptual priorities.

## 3. Papers/Gaps Addressed
- **Section 14:** Gap 4 (reordering NP-hard, suboptimal), Research Opportunity 2 (perceptually-optimized reordering)
- **Section 14, Behrisch et al. (2016):** Comprehensive survey but no interactive reordering tools
- **Section 9 (Interactive Visualization):** Limited customization

## 4. Why Existing Techniques Are Insufficient
seriation package provides automatic reordering (PCA, MDS, TSP, OLO) but no interaction. The user cannot: mark which rows should be grouped together, specify which patterns they want to see, reject a poor ordering, or guide the algorithm iteratively. The result is purely algorithmic with no human perceptual input.

## 5. Visualization Contribution
An interactive matrix reordering system with:
- **Interactive constraints:** users can drag rows/columns to group them, pin items to fixed positions, or define "must be together" pairs
- **Perceptual quality metrics:** real-time display of block diagonal strength, anti-Robinson events, pattern clarity
- **Semi-automatic reordering:** user marks regions of interest → algorithm optimizes within constraints
- **Reordering comparison gallery:** show 4 candidate reorderings side-by-side with quality scores
- **Constraint visualization:** visual overlay showing user constraints (grouping brackets, pinned rows)
- **Iterative refinement:** user sees initial result, adjusts constraints, algorithm refines
- **Perceptual pattern annotation:** user can label detected patterns (block, band, checkerboard)

## 6. Novelty Level: **7/10**
Human-in-the-loop matrix reordering with perceptual feedback is conceptually proposed but no implementation exists.

## 7. Technical Difficulty: **7/10**
Requires constraint-based optimization, real-time metric computation, interactive dragging, comparison rendering.

## 8. Learning Value: **8/10**
Teaches: matrix reordering theory, seriation algorithms, perceptual quality metrics, human-in-the-loop design, constraint optimization.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- Any adjacency/correlation/distance matrix
- Gene expression data
- Survey response correlation matrices
- Social network adjacency matrices

## 11. Required R Packages
- seriation (reordering algorithms)
- heatmaply (interactive matrix)
- shiny (platform)
- sortable (drag-and-drop)
- shinyjqui (UI interaction)
- ggplot2 (quality metric plots)

## 12. Expected Final Deliverables
- ReorderMe Shiny application
- User study: automatic vs. human-in-the-loop reordering
- Comparison of constraint methods
- Guidelines for interactive reordering

## 13. Publication Potential: **7/10**
EuroVis Short Papers, CHI Late-Breaking, VIS Posters.

## 14. Extension Potential
- Crowd-sourced reordering evaluation
- ML-based constraint suggestion
- Integration with bi-clustering

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50/70** |

---

# PROJECT 24: NLP Uncertainty-Aware Text Visualization

## 1. Project Title
**VisUncertNLP: Visualizing Uncertainty in Natural Language Processing Pipelines**

## 2. Research Motivation
The SoS TextVis survey identifies that "uncertainty in NLP results is rarely visualized" and calls for "appropriate uncertainty visualization approaches [to] be developed" for text data (Section 13). NLP pipelines involve many uncertain steps (tokenization ambiguity, POS tagging confidence, named entity recognition uncertainty, sentiment model disagreement), none of which are typically visualized.

## 3. Papers/Gaps Addressed
- **Section 13 (Text Visualization):** Gap 7 (NLP uncertainty rarely visualized), Gap 4 (natural language ambiguity)
- **Section 5 (Uncertainty Visualization):** Need for uncertainty visualization across data types
- **Section 13, Future Work:** "Uncertainty modeling and visualization research is expected to rise"

## 4. Why Existing Techniques Are Insufficient
Text visualization tools (word clouds, LDAvis, sentiment plots) show results without confidence. When an NER model tags "Paris" as a person with 0.4 confidence, this uncertainty is hidden. Users see deterministic outputs from inherently probabilistic NLP models. No tool shows model confidence, ensemble disagreement, or ambiguity in text analysis.

## 5. Visualization Contribution
An uncertainty-aware text visualization with:
- **Token-level uncertainty heatmap:** each token colored by NLP model confidence (red = low confidence, green = high)
- **Alternative annotation view:** when NER/POS tagging is uncertain, show top-3 alternatives with probability weights as interactive overlaid text
- **Sentiment disagreement fan:** for each text segment, show sentiment model predictions from 5+ models as a fan/rose chart showing agreement
- **Topic model stability visualization:** show which documents change topic assignment across multiple LDA runs (topics as colors, uncertainty as wobble)
- **Ambiguity lens:** click on an ambiguous token/phrase → side panel showing all possible interpretations with evidence
- **Uncertainty-sorted view:** sort text segments by NLP pipeline uncertainty to prioritize human review
- **Model comparison overlay:** overlay two NLP models' outputs with disagreement highlighting

## 6. Novelty Level: **8/10**
NLP uncertainty visualization is explicitly called out as "rarely visualized." A comprehensive approach is novel.

## 7. Technical Difficulty: **7/10**
Requires NLP pipeline output, uncertainty metrics, text rendering with overlays, model comparison.

## 8. Learning Value: **8/10**
Teaches: text visualization, NLP uncertainty, model confidence, ensemble methods, uncertainty encoding in text.

## 9. Expected Implementation Time: **8–10 weeks**

## 10. Suitable Datasets
- News articles with NER/POS/sentiment
- Social media text with multiple NLP annotations
- Medical text with diagnostic coding
- Any text with multiple annotator labels

## 11. Required R Packages
- quanteda, tidytext (text processing)
- text (NLP models)
- ggplot2, ggtext (text rendering)
- shiny (platform)
- plotly (interactive)
- DT (annotated tables)

## 12. Expected Final Deliverables
- VisUncertNLP Shiny application
- Case studies with 3 NLP tasks
- User evaluation: does uncertainty visualization improve trust?
- Design guidelines for NLP uncertainty visualization

## 13. Publication Potential: **8/10**
VIS Short Papers, EuroVis, ACL Visualization Workshop, EMNLP.

## 14. Extension Potential
- LLM output confidence visualization
- Multi-language NLP uncertainty
- Real-time NLP monitoring dashboards

## 15. Patent Potential: **Medium**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 8 | 8 | 7 | 7 | 8 | 8 | 7 | **53/70** |

---

# PROJECT 25: Multi-Modal Text-Vis Integration Patterns for Data Communication

## 1. Project Title
**TextVizPatterns: Systematic Exploration of Text-Visualization Integration Patterns for Data Communication**

## 2. Research Motivation
Hearst (2023) argues: "The interplay between language and visualizations for communication is not well understood" and "The field does not use verified cognitive theories of how combinations of language and visualizations are read." The "Evolving Duet" survey (2025) catalogues 98 papers on text+vis integration but finds no systematic comparative evaluation of integration patterns.

## 3. Papers/Gaps Addressed
- **Section 13, Hearst (2023):** Interplay between language and visualization not well understood
- **Section 13, Hearst (2023):** No verified cognitive theories of text+vis reading
- **Section 13, "Evolving Duet" survey (2025):** 98 papers but no systematic comparison
- **Section 13, Voltoline et al. (2023):** Combining text with other data modalities

## 4. Why Existing Techniques Are Insufficient
Current text+vis integration is ad-hoc: some dashboards use annotations, blogs use narrative text+charts, academic papers use captions. There is no systematic understanding of which integration pattern works best for which task, audience, or data type. R/Shiny provides no framework for principled text-vis integration.

## 5. Visualization Contribution
A framework for systematic text-vis integration:
- **Integration pattern library:** 8+ defined patterns (annotation, caption, inline narrative, side-by-side, overlay, sequential, branching, integrated) each with implementation in R
- **Pattern switching:** same data + analysis shown with different text-vis integration patterns; users can toggle between them
- **Cognitive load measurement:** per-pattern measurement of task completion time, accuracy, and self-reported effort
- **Task-pattern mapping tool:** wizard that recommends integration pattern based on data type, user task, and audience
- **Implementation as R package:** easy-to-use functions for each integration pattern
- **Eye-tracking simulation overlay:** predicted attention distribution for each pattern (based on known reading patterns)

## 6. Novelty Level: **9/10**
Systematic comparison of text-vis integration patterns is explicitly called for by Hearst (2023) and the "Evolving Duet" survey (2025).

## 7. Technical Difficulty: **6/10**
Primarily about systematic implementation and evaluation rather than computationally complex.

## 8. Learning Value: **9/10**
Teaches: communication theory, text-vis integration, cognitive load, narrative visualization, pattern library design, experimental methodology.

## 9. Expected Implementation Time: **6–8 weeks**

## 10. Suitable Datasets
- Any dataset suitable for data-driven storytelling
- Gapminder, WHO, economic indicators

## 11. Required R Packages
- shiny, shinydashboard (platform)
- ggplot2, plotly (visualization)
- shinyMobile (mobile patterns)
- htmltools, markdown (text rendering)
- bs4Dash (layout patterns)

## 12. Expected Final Deliverables
- TextVizPatterns R package with 8+ pattern implementations
- Comparative user study
- Pattern selection guidelines
- Pattern library with examples

## 13. Publication Potential: **8/10**
VIS Full Papers, EuroVis, CHI, Communication Design venues.

## 14. Extension Potential
- Automated narrative generation for each pattern
- Accessibility-focused pattern adaptation
- Cultural adaptation of integration patterns

## 15. Patent Potential: **Low**

## Evaluation
| Novelty | Vis Contribution | Research Strength | Implementation Feasibility | Learning Value | Publication Potential | Portfolio Value | **Total** |
|---------|-----------------|-------------------|---------------------------|---------------|----------------------|----------------|----------|
| 9 | 8 | 8 | 8 | 9 | 8 | 7 | **57/70** |

---

# FINAL RANKING OF ALL 25 PROJECTS

| Rank | Project | Novelty | Vis | Research | Feasibility | Learning | Publish | Portfolio | **Total** |
|------|---------|---------|-----|----------|-------------|----------|---------|-----------|----------|
| 1 | P7: TrustDR (Reliability-Aware DR) | 9 | 9 | 8 | 7 | 9 | 9 | 8 | **59** |
| 2 | P3: UAVA-R (Uncertainty Propagation) | 9 | 9 | 9 | 6 | 9 | 9 | 7 | **58** |
| 3 | P12: BiasVis (Bias Discovery) | 8 | 8 | 9 | 7 | 9 | 9 | 8 | **58** |
| 4 | P1: ggdistinct (Uncertainty Grammar) | 8 | 9 | 8 | 7 | 9 | 8 | 8 | **57** |
| 5 | P4: CogNet (Cognitive Load Network Animation) | 9 | 8 | 8 | 6 | 9 | 8 | 9 | **57** |
| 6 | P14: RL-Vis (RL Training Dynamics) | 9 | 8 | 7 | 6 | 9 | 9 | 9 | **57** |
| 7 | P25: TextVizPatterns (Text-Vis Integration) | 9 | 8 | 8 | 8 | 9 | 8 | 7 | **57** |
| 8 | P5: DynMarix (Hybrid Dynamic Matrix) | 8 | 8 | 8 | 6 | 9 | 8 | 8 | **55** |
| 9 | P8: GlyphDR (Beyond Scatterplots) | 8 | 8 | 7 | 7 | 9 | 8 | 8 | **55** |
| 10 | P10: ProvenanceViz (Provenance Graph) | 9 | 8 | 8 | 5 | 8 | 9 | 8 | **55** |
| 11 | P15: ProgressTrain (Progressive Training) | 8 | 8 | 7 | 6 | 9 | 8 | 9 | **55** |
| 12 | P13: AdaptXAI (Expertise-Adaptive XAI) | 8 | 7 | 8 | 7 | 8 | 8 | 8 | **54** |
| 13 | P16: StreamSense (Streaming Transitions) | 8 | 8 | 7 | 6 | 9 | 8 | 8 | **54** |
| 14 | P21: CycleLine (Cyclic-Linear Time) | 8 | 8 | 7 | 7 | 8 | 8 | 8 | **54** |
| 15 | P2: Interactive HOPs | 8 | 7 | 7 | 8 | 8 | 7 | 8 | **53** |
| 16 | P24: VisUncertNLP (NLP Uncertainty) | 8 | 8 | 7 | 7 | 8 | 8 | 7 | **53** |
| 17 | P6: StructAttrib (Graph-Attribute Correlation) | 8 | 7 | 7 | 7 | 9 | 7 | 7 | **52** |
| 18 | P18: PercepCoord (Perceptual Parallel Coords) | 8 | 7 | 7 | 7 | 9 | 7 | 7 | **52** |
| 19 | P17: QualStream (Streaming Quality) | 8 | 7 | 7 | 7 | 8 | 7 | 7 | **51** |
| 20 | P19: PercepGlyph (Perceptual Glyph System) | 7 | 7 | 7 | 8 | 9 | 6 | 7 | **51** |
| 21 | P22: AnimatrixR (Dynamic Matrix) | 8 | 7 | 7 | 7 | 8 | 7 | 7 | **51** |
| 22 | P9: ParamScope (DR Hyperparameter Viz) | 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50** |
| 23 | P11: CompareProv (Comparative Provenance) | 8 | 7 | 7 | 6 | 8 | 7 | 7 | **50** |
| 24 | P20: TimeLens (Multi-Granularity Time) | 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50** |
| 25 | P23: ReorderMe (Matrix Reordering HITL) | 7 | 7 | 7 | 7 | 8 | 7 | 7 | **50** |

---

# TOP 10 PROJECTS — Detailed Analysis

## The Top 10

| Rank | ID | Project | Total | Key Strength |
|------|----|---------|-------|-------------|
| 1 | P7 | TrustDR | 59 | Most directly addresses a high-profile crisis (DR misuse) |
| 2 | P3 | UAVA-R | 58 | Fills the biggest theoretical gap (UAVA framework missing) |
| 3 | P12 | BiasVis | 58 | High-impact ethical AI topic; strong publication venue alignment |
| 4 | P1 | ggdistinct | 57 | Grammatical contribution; permanent value to R community |
| 5 | P4 | CogNet | 57 | Most original idea; cognitive load adaptation is genuinely novel |
| 6 | P14 | RL-Vis | 57 | Exploits largest empty space in XAI+VIS (RL ignored) |
| 7 | P25 | TextVizPatterns | 57 | Strongest evaluation angle; fills a communication theory gap |
| 8 | P5 | DynMarix | 55 | Addresses two gaps simultaneously (hybrid + matrix) |
| 9 | P8 | GlyphDR | 55 | Most creative visual design; alternative to scatterplot monoculture |
| 10 | P10 | ProvenanceViz | 55 | Highest novelty; but highest implementation risk (feasibility 5) |

## Why These Are the Strongest

1. **TrustDR (P7, 59):** The "Stop Misusing t-SNE and UMAP" paper (2025) has created urgency around DR reliability. This project directly answers the call for "communicating DR limitations." The contribution is a new visual encoding (trustworthiness glyphs), not just a tool. High publication potential at VIS or EuroVis.

2. **UAVA-R (P3, 58):** Gillmann et al. (2023) explicitly state "implementation of such a framework was not conducted so far." This project implements the UAVA cycle. The theoretical foundation (uncertainty propagation) is strong, and the Sankey+distribution hybrid visualization is novel.

3. **BiasVis (P12, 58):** Fairness in AI is perhaps the most socially relevant topic. Chatzimparmpas et al. (2024) confirm user bias is absent from VA systems. This project creates a new type of visualization (bias propagation Sankey, intersectional bias heatmap) that does not exist. FAccT and AIES venues are actively seeking this.

4. **ggdistinct (P1, 57):** Extending ggplot2's grammar with uncertainty is a contribution that benefits the entire R visualization community. The literature explicitly calls for this ("Uncertainty needs to be formalised within the grammar of graphics"). Package development teaches R internals deeply.

5. **CogNet (P4, 57):** Most conceptually original. No one has done cognitive load-adaptive network animation. The gap is explicit (Filipov et al., 2023: "investigating cognitive load when watching animations is an open challenge"). The adaptive aspect makes it a systems contribution, not just a visual design.

6. **RL-Vis (P14, 57):** RL is "mostly ignored" (Chatzimparmpas et al., 2024). This project enters a near-empty space. The visualization techniques required (policy landscapes, Q-value distributions, exploration gauges) are genuinely novel because they address RL-specific concepts not present in supervised learning visualization.

7. **TextVizPatterns (P25, 57):** Hearst (2023) and the "Evolving Duet" survey (2025) both call for systematic understanding of text-vis integration. This project has the strongest evaluation component and the broadest cross-disciplinary relevance (VIS + HCI + communication).

8. **DynMarix (P5, 55):** Addresses two gaps: hybrid timeline+animation (Filipov et al., 2023) AND matrix-based DMVN visualization (Kale et al., 2023). The coordinated multi-view approach with adaptive representation switching is technically impressive.

9. **GlyphDR (P8, 55):** The Reliable VA survey (CHI 2025) explicitly calls for "limited discussion extending beyond 2D scatterplots." This project reimagines how DR results are visually represented — a first-principles visual design contribution.

10. **ProvenanceViz (P10, 55):** Highest novelty score (9) but lowest feasibility (5). Provenance visualization is identified as "underexplored." The contribution (state transition graphs, insight event markers, provenance trees) is significant but requires substantial infrastructure.

---

# OVERLAP ANALYSIS

## Overlap Matrix (Top 10)

| | P7 | P3 | P12 | P1 | P4 | P14 | P25 | P5 | P8 | P10 |
|--|----|----|-----|----|----|-----|-----|----|----|-----|
| **P7** | — | Low | None | None | None | None | None | None | High | None |
| **P3** | Low | — | None | High | None | None | None | None | Low | None |
| **P12** | None | None | — | None | None | Low | None | None | None | None |
| **P1** | None | High | None | — | None | None | None | None | None | None |
| **P4** | None | None | None | None | — | None | None | Low | None | None |
| **P14** | None | None | Low | None | None | — | None | None | None | None |
| **P25** | None | None | None | None | None | None | — | None | None | None |
| **P5** | None | None | None | None | Low | None | None | — | None | None |
| **P8** | High | Low | None | None | None | None | None | None | — | None |
| **P10** | None | None | None | None | None | None | None | None | None | — |

**Key overlaps:**

1. **P1 (ggdistinct) ↔ P3 (UAVA-R):** Both address uncertainty visualization. P1 is a grammatical/package contribution; P3 is a pipeline/framework contribution. They are complementary, not competing — P3 could use P1's uncertainty primitives. **Can be merged** if scoped carefully.

2. **P7 (TrustDR) ↔ P8 (GlyphDR):** Both address high-D visualization. P7 augments scatterplots with trustworthiness; P8 replaces scatterplots with alternative metaphors. They overlap in the "how to visually represent DR quality" question. **Can be merged** into a single project that both adds trustworthiness metadata AND offers alternative visual metaphors.

## Merged Projects

### Merge Candidate A: P1 + P3 → Unified Uncertainty Visualization Framework (UAViz)
Combines the grammar extension (P1) with the pipeline propagation (P3) into a single framework. The grammar provides the primitives; the pipeline provides the application. This creates a more compelling narrative: "from uncertainty primitives to pipeline-wide uncertainty propagation."
- **New total:** 58 (P3 score, since P1 complements)
- **Strength:** Creates a complete uncertainty visualization ecosystem in R
- **Risk:** Scope may be too large for a single project

### Merge Candidate B: P7 + P8 → High-D Visualization Beyond Unreliable Scatterplots
Combines trustworthiness encoding (P7) with alternative visual metaphors (P8). The merged project asks: "If scatterplots are unreliable and lose attribute information, what should replace them?" Answer: projections augmented with trustworthiness + alternative metaphors that preserve attribute information.
- **New total:** 59 (P7 score enhanced by P8's scope)
- **Strength:** Addresses the DR visualization problem comprehensively
- **Risk:** Both components are substantial independently

---

# FINAL FIVE RECOMMENDED PROJECTS

After accounting for overlaps and feasibility, the five strongest distinct projects are:

## 1. TrustDR (P7) — Reliability-Aware DR Projection with Trustworthiness Glyphs
**Score: 59/70** | **Difficulty: 7/10** | **Novelty: 9/10**

The strongest single project. It addresses the most urgent gap (DR misuse, Section 9), produces a visually striking output (glyph-augmented scatterplots), has clear publication targets (VIS, EuroVis), and is implementable in R within 8–10 weeks. The contribution — augmenting every point in a DR scatterplot with its projection trustworthiness — is a pure visualization contribution. It does not build a dashboard, an ML model, or a prediction system.

**Why it stays as-is (not merged with P8):** P8's alternative metaphors are a separate research question. Merging would dilute the clear, focused contribution of trustworthiness encoding. P8 is better as a follow-up project.

## 2. BiasVis (P12) — Bias Discovery Visual Analytics for ML Pipelines
**Score: 58/70** | **Difficulty: 7/10** | **Novelty: 8/10**

The strongest socially relevant project. Fairness in AI is the highest-trend topic in XAI+VIS. The project creates genuinely novel visualization types (bias propagation Sankey, intersectional bias heatmap) that do not exist. R ecosystem support (fairmodels, DALEX) is strong. Multiple publication venues (FAccT, AIES, VIS). The visualization techniques developed (comparing subgroup performance as difference-from-overall, showing how bias propagates through pipelines) are contributions to visual analytics methodology.

**Differentiation from P14:** BiasVis covers supervised learning fairness; P14 covers RL training dynamics. No overlap.

## 3. CogNet (P4) — Cognitive Load-Adaptive Dynamic Network Animation
**Score: 57/70** | **Difficulty: 8/10** | **Novelty: 9/10**

The most original project. While TrustDR and BiasVis address existing topics with new techniques, CogNet opens an entirely new direction: cognitive-aware network visualization. The gap is explicitly identified (Filipov et al., 2023). The adaptive approach — where the visualization changes based on user cognitive state — represents a paradigm shift from "one-size-fits-all animation" to "adaptive visualization." The portfolio value is high (cognitive load heatmap overlay, adaptive animation speed).

**Risk:** Higher implementation difficulty (8/10) due to cognitive load measurement proxying. Mitigation: use interaction-based proxies (mouse speed, zoom frequency) rather than physiological sensors.

## 4. TextVizPatterns (P25) — Multi-Modal Text-Vis Integration Patterns
**Score: 57/70** | **Difficulty: 6/10** | **Novelty: 9/10**

The strongest evaluation-driven project. Hearst (2023) argues the text-vis interplay is not understood; this project creates a systematic comparative framework. It has the lowest implementation difficulty (6/10) and the highest feasibility among top-scoring projects. The contribution is both a reusable R package (8 integration patterns) and empirical evidence about which pattern works best. Publication potential is high across VIS, CHI, and communication venues.

**Differentiation from all others:** Unique area (text + vis integration). No overlap with DR, network, XAI, uncertainty, or streaming projects.

## 5. RL-Vis (P14) — Visual Analytics for Reinforcement Learning Training Dynamics
**Score: 57/70** | **Difficulty: 9/10** | **Novelty: 9/10**

The highest-risk, highest-reward project. RL visualization is "mostly ignored" (Chatzimparmpas et al., 2024), meaning the space is wide open. The visualization challenges in RL (non-monotonic training, policy landscapes, exploration-exploitation balance) require fundamentally new visual approaches. If successful, this is the most publishable project (NeurVIS, VIS, RL conference workshops). However, it requires understanding RL training infrastructure, which adds complexity.

**Risk:** Difficulty 9/10. Requires reticulate to interface with Python RL libraries. Mitigation: use pretrained RL logs and focus on the visualization, not the RL training.

---

## Why These Five?

1. **Coverage of different gap clusters:** TrustDR → high-D visualization; BiasVis → XAI fairness; CogNet → network/cognitive; TextVizPatterns → text/communication; RL-Vis → XAI under-explored areas. No two projects occupy the same gap space.

2. **Diverse skill development:** TrustDR teaches DR+visual perception; BiasVis teaches fairness+ethics; CogNet teaches cognitive theory+HCI; TextVizPatterns teaches experimental design+communication; RL-Vis teaches streaming+ML dynamics.

3. **Clear differentiation from each other:**
   - TrustDR: DR projection quality
   - BiasVis: Algorithmic fairness
   - CogNet: Adaptive animation
   - TextVizPatterns: Text+vis integration
   - RL-Vis: RL training dynamics

4. **Feasibility range:** TextVizPatterns (6/10) offers a safe, completable option. RL-Vis (9/10) offers the highest challenge. The range ensures a student can choose based on confidence.

5. **Publication potential:** All five have clear paths to VIS Short Papers, EuroVis, or specialized venues (FAccT, NeurIPS workshops, CHI).

---

## What These Projects Are NOT

| Rejected Pattern | Reason |
|-----------------|--------|
| Dashboard for X | Not a visualization contribution |
| BI application | Not research |
| ML model for prediction | Not visualization |
| Web app with charts | Not visualization research |
| Another survey/literature review | Already done |
| Generic dashboard | Rejected by criteria |

Every recommended project's primary contribution is a **novel visual encoding, interaction technique, or visualization framework** that addresses a specific documented gap in the peer-reviewed visualization literature.

---

*End of Report*
