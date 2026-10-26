# Advanced Data Visualization Techniques — Research Landscape Analysis

**Generated:** July 2026  
**Purpose:** Literature review of visualization research (2020–2026) for final-year project identification  
**Scope:** 15 research areas across Information Visualization, Visual Analytics, and HCI

---

## Table of Contents

1. [Interactive Visualization](#1-interactive-visualization)
2. [Visual Analytics](#2-visual-analytics)
3. [Network Visualization](#3-network-visualization)
4. [Dynamic Graph Visualization](#4-dynamic-graph-visualization)
5. [Uncertainty Visualization](#5-uncertainty-visualization)
6. [Explainable AI Visualization](#6-explainable-ai-visualization)
7. [Provenance Visualization](#7-provenance-visualization)
8. [Streaming Data Visualization](#8-streaming-data-visualization)
9. [High-dimensional Visualization](#9-high-dimensional-visualization)
10. [Multivariate Visualization](#10-multivariate-visualization)
11. [Dashboard Visualization](#11-dashboard-visualization)
12. [Geospatial Visualization](#12-geospatial-visualization)
13. [Text Visualization](#13-text-visualization)
14. [Matrix Visualization](#14-matrix-visualization)
15. [Temporal Visualization](#15-temporal-visualization)
16. [Comparative Analysis & Ranking](#16-comparative-analysis--ranking)

---

# 1. Interactive Visualization

## Overview

Interactive visualization enables users to directly engage with visual representations of data through manipulation, exploration, and dynamic querying. Recent research has expanded from traditional WIMP interfaces to large high-resolution displays (LHRDs), immersive environments (VR/AR), and natural language interfaces powered by large language models (LLMs).

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Belkacem et al., "Interactive Visualization on Large High-Resolution Displays: A Survey" | CGF (EuroVis STAR) | 2024 | Comprehensive survey of 701 papers on LHRD visualization across visualization, interaction, evaluation, and applications |
| Ortega-Bustamante et al., "Interactive Information Visualization Models: A Systematic Literature Review" | ICCSA | 2023 | SLR of 52 papers on interactive DR-oriented models; identifies scatter plots as predominant but limited |
| "A survey of immersive visualization: Focus on perception and interaction" | Visual Informatics | 2023 | Survey of 47 representative immersive visualization works (2014–2023) |
| Brossier et al., "State of the Art of LLM-Enabled Interaction with Visualization" | CGF (EuroVis STAR) | 2026 | PRISMA-guided survey of 48 papers on LLM-vis interaction; identifies gaps in visualization reading vs. authoring |
| Ye et al., "Generative AI for visualization: State of the art and future directions" | Visual Informatics | 2024 | Survey of 81 GenAI4VIS papers covering data enhancement, visual mapping, stylization, interaction |

## Existing Techniques

- **Direct manipulation**: Brushing, linking, zooming, panning, filtering
- **Focus+context**: Fisheye views, semantic zooming, overview+detail
- **Natural language interfaces**: LLM-driven chart creation, query, and explanation
- **Immersive interaction**: Mid-air gestures, gaze-based interaction, voice commands
- **Mixed-initiative systems**: AI-assisted visualization recommendation with human steering

## Existing Software

- **Vega-Lite / Vega**: Declarative grammar for interactive graphics
- **Plotly / R Shiny**: Interactive web-based visualization
- **D3.js**: Low-level interactive visualization library
- **Tableau / Power BI**: Commercial interactive dashboards
- **Observable**: Interactive notebook environment for visualization

## GitHub Projects

- vega/vega-lite (declarative interaction)
- rstudio/shiny (interactive R web apps)
- d3/d3 (interactive visualization framework)
- vega/vega (interactive grammar)

## Limitations

1. **LLM spatial reasoning is poor** (Brossier et al., 2026): LLMs struggle with complex spatial reasoning and contextual grounding for visualization
2. **Interaction across LHRDs remains challenging** (Belkacem et al., 2024): Interaction across larger distances, multiple users, and heterogeneous devices
3. **Visualization reading vs. authoring imbalance** (Brossier et al., 2026): Most prior work focused on visualization authoring, not visualization reading or interactive data analysis
4. **Limited customization** (Ortega-Bustamante et al., 2023): "Limited options for customizing the display of raw data and details in application windows"
5. **Evaluation is ad-hoc**: "Design-focused evaluations and human studies provide rich insights but lack scalability" (Hutchinson et al., 2024)

## Future Work

- "A closer connection between... statistical models describing the network's change" (Filipov et al., 2023)
- "Exploring non-interactive techniques, examining the interplay between different visualization elements" (VIS 2024 narrative visualization review)
- "Developing comprehensive evaluation frameworks... should assess guidance quality, system adaptability across domains and tasks" (Hutchinson et al., 2024)

## Possible Research Opportunities

1. **LLM-guided interactive visualization reading**: Systems that help users interpret and reason about visualizations through natural language, not just create them
2. **Adaptive interaction for multi-device LHRD environments**: Interaction techniques that adapt to display size, user position, and device type
3. **Progressive interactive visualization**: Combining progressive computation with interactive steering for large datasets

---

# 2. Visual Analytics

## Overview

Visual analytics (VA) combines automated analysis techniques with interactive visualization to support analytical reasoning. The field has matured significantly, but recent surveys identify critical challenges around evaluation rigor, deployment, and integration with AI/LLMs.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Bikakis et al., "Visual Analytics Challenges and Trends in the Age of AI: The BigVis Community Perspective" | arXiv | 2025 | Expert survey (32 scientists) identifying top challenges: LLMs, fairness, trustworthiness, non-expert users |
| Wu et al., "Grand Challenges in Visual Analytics Applications" | IEEE CG&A | 2023 | 12 open challenges across foundation, methodology, application, and community |
| Wang et al., "Visual Analytics for Machine Learning: A Data Perspective Survey" | IEEE TVCG | 2024 | 143 papers surveyed from data perspective across 5 data types and 6 tasks |
| Wang et al., "A Survey on ML4VIS: Applying Machine Learning Advances to Data Visualization" | IEEE TVCG | 2022 | Survey of ML techniques applied to visualization |
| Wu et al., "AI4VIS: Survey on Artificial Intelligence Approaches for Data Visualization" | IEEE TVCG | 2022 | Survey of AI approaches for data visualization |
| Chatzimparmpas et al., "Visualization for Trust in ML Revisited" | IEEE CG&A | 2024 | 542 techniques categorized; 8 open challenges identified |
| Hutchinson et al., "Foundation model assisted visual analytics" | Computers & Graphics | 2025 | Opportunities and challenges for FM-assisted VA |
| McTaggart et al., "VA + Embeddings STAR" | CGF (EuroVis STAR) | 2024 | 122 entries on embedding visualization in VA |

## Existing Techniques

- **Visual knowledge discovery**: Combined automated pattern detection with visual interpretation
- **Mixed-initiative analytics**: Systems where human and machine collaborate iteratively
- **Progressive visual analytics**: Incremental computation with intermediate visual feedback
- **Human-in-the-loop ML**: Interactive model building, debugging, and refinement

## Existing Software

- **KNIME**: Visual analytics workflow platform
- **Orange**: Data mining and visualization toolkit
- **RStudio + Shiny**: R-based visual analytics
- **TensorBoard**: ML experiment visualization
- **What-If Tool**: ML model exploration

## GitHub Projects

- knime/knime-core
- orange3/orange3
- tensorflow/tensorboard
- PAIR-code/what-if-tool

## Limitations

1. **Evaluation in VA is fundamentally broken** (Wu et al., 2023): "44% of studies performed summative evaluation without any human subjects"; classic quantitative/HCI approaches do not apply well
2. **VA systems rarely deployed in the wild** (Chatzimparmpas et al., 2024): "Many application-specific VA systems are never deployed in the real world"
3. **LLMs lack VA domain expertise** (Hutchinson et al., 2025): "LLMs often lack explicit domain-specific knowledge regarding VA principles and established best practices"
4. **Data faithfulness / hallucination** (Hutchinson et al., 2025): "LLMs have a propensity to 'hallucinate' or generate plausible but incorrect information"
5. **Black-box nature of LLMs undermines trust** (Hutchinson et al., 2025): "opaque inference processes... make it difficult for users to understand how the system arrived at a particular output"

## Future Work

- "Scalability & efficiency" identified as #1 most important challenge (94% agree/strongly agree) (Bikakis et al., 2025)
- "Use of LLMs in visualization and analytics" is the #1 new challenge (16% of experts) (Bikakis et al., 2025)
- "Enable visualization for non-expert users" is the #2 new challenge (13%) (Bikakis et al., 2025)
- "Fairness and Trustworthiness" also at 13% (Bikakis et al., 2025)
- "Developing Generic Methods" for VA evaluation (Wu et al., 2023)
- "Promoting Open-Source Contributions" in VA (Wu et al., 2023)

## Possible Research Opportunities

1. **VA evaluation frameworks for LLM-assisted systems**: Rigorous methods to evaluate mixed human-AI analytical workflows
2. **Fairness-aware visual analytics**: Visualization techniques that expose and mitigate algorithmic bias
3. **Non-expert VA systems**: Lowering barriers for users without data science training
4. **Progressive VA with quality guarantees**: Visual analytics that provides reliable intermediate results with uncertainty quantification

---

# 3. Network Visualization

## Overview

Network visualization represents entities (nodes) and their relationships (edges) visually. Research has expanded from static node-link diagrams to dynamic, multivariate, geospatial, and hybrid representations. Visual scalability remains the dominant challenge.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Filipov et al., "Are We There Yet? A Roadmap of Network Visualization from Surveys to Task Taxonomies" | CGF (EuroVis STAR) | 2023 | Meta-survey consolidating terminology and identifying saturated vs. unsaturated research areas |
| Zhang et al., "Large graph layout optimization based on vision and computational efficiency: a survey" | Visual Intelligence | 2023 | Taxonomy of pre-layout, in-layout, post-layout optimization for large graphs |
| Schöttler et al., "Visualizing and Interacting with Geospatial Networks: A Survey and Design Space" | CGF | 2021 | 95 papers surveyed across representation of geography, network, integration, and interaction |

## Existing Techniques

- **Node-link diagrams**: Force-directed, hierarchical, circular layouts
- **Matrix representations**: Adjacency matrices for dense networks
- **Hybrid representations**: NodeTrix (combining node-link and matrix)
- **Edge bundling**: Reducing visual clutter by bundling adjacent edges
- **Hierarchical aggregation**: Clustering nodes for scalable overviews

## Existing Software

- **Gephi**: Interactive network visualization platform
- **Cytoscape**: Network visualization for bioinformatics
- **igraph**: Network analysis library (R/Python)
- **networkD3**: R package for D3 network visualization
- **visNetwork**: R package for interactive network visualization

## GitHub Projects

- gephi/gephi
- cytoscape/cytoscape
- igraph/igraph
- christophergandrud/networkD3
- datastorm-open/visNetwork

## Limitations

1. **Visual scalability is still a major concern** (Filipov et al., 2023): "Visual scalability is still a major concern in the design of most dynamic network visualization methods"
2. **Lack of guidelines for technique selection** (Filipov et al., 2023): "there is a lack of guidelines and direction regarding which technique to choose based on the application"
3. **User cognitive load when watching animations** (Filipov et al., 2023): "investigating the effect of a user's cognitive load when watching animations is an open challenge"
4. **Hybrid timeline+animation approaches are under-explored** (Filipov et al., 2023)
5. **No methods fully enable users to "correlate the underlying graph structure to its attributes"** (Filipov et al., 2023)

## Future Work

- "Deep learning graph drawing... has not been verified whether this kind of method is available for large graph data rendering" (Zhang et al., 2023)
- "Interpretability of the deep learning models" for graph layout (Zhang et al., 2023)
- "Iteration process [for graph layout] needs further investigation" (Zhang et al., 2023)
- "Extending dynamic network movies from exploratory data analysis stage to a confirmatory analytic modelling stage" (Filipov et al., 2023)

## Possible Research Opportunities

1. **Deep learning-based graph layout with interpretability guarantees**: Neural network-driven layouts where the layout quality can be explained
2. **Hybrid visualization for dynamic multivariate networks**: Combining animation, timeline, matrix, and attribute views in a coordinated manner
3. **Cognitive load-aware network animation**: Adaptive animation speed and complexity based on user state

---

# 4. Dynamic Graph Visualization

## Overview

Dynamic graph visualization represents how relationships between entities evolve over time. The major design distinction is between animation (time-to-time mapping) and timeline-based (time-to-space mapping) approaches. Recent work extends to dynamic multivariate networks.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Kale et al., "The State of the Art in Visualizing Dynamic Multivariate Networks" | CGF (EuroVis STAR) | 2023 | First STAR focusing on visualization techniques that simultaneously encode dynamic and multivariate characteristics |
| Beck et al., "A Taxonomy and Survey of Dynamic Graph Visualization" | CGF | 2017 | Hierarchical taxonomy of techniques; standard reference |
| Abdelaal et al., "STEP: Sequence of time-aligned edge plots" | Information Visualization | 2024 | Novel sequence- and edge-scalable dynamic network visualization |
| "DynTrix: A Hybrid Representation for Dynamic Graphs" | IEEE | 2024 | Extends NodeTrix hybrid representation to dynamic networks |
| "DyGETViz" | arXiv | 2024 | Open-source Python framework for dynamic graph embedding trajectories |

## Existing Techniques

- **Animation**: Time-to-time mapping; preserving mental map via dynamic stability
- **Timeline (small multiples)**: Time-to-space mapping; comparing different time steps
- **Hybrid**: Combining animation and timeline approaches
- **Attribute-driven layouts**: Using node/edge attributes to drive layout creation
- **Matrix-based dynamic visualization**: Animatrix, DynTrix

## Existing Software

- **DyGETViz**: Python package for dynamic graph visualization
- **Gephi + Gephi Toolkit**: Dynamic graph support
- **DynNetwork**: R package for dynamic network visualization
- **networkDynamic**: R package for dynamic network analysis

## GitHub Projects

- DynamicGraphVisualizations/DyGETViz
- statnet/networkDynamic

## Limitations

1. **Mental map preservation is challenging** (Kale et al., 2023): "Preserving mental map is challenging" for animation approaches
2. **Visual scalability is a major concern** for multiple time steps approaches (Kale et al., 2023)
3. **List views not yet evaluated** for DMVNs (Kale et al., 2023)
4. **Limited user evaluation**: Most evaluations use use cases (58%), few user studies (24%) (Kale et al., 2023)
5. **"Hybrid combinations of timeline and animation approaches are under-explored"** (Filipov et al., 2023)

## Future Work

- "Multiple (dynamic) data dimensions, interaction methods, and continuous (event-based) representations... present research directions with significant potential" (Filipov et al., 2023)
- "How to effectively visualize large-scale and time-intensive dynamic graph data with subtle changes is still challenging" (DGSVis, 2024)
- Need for "closer connection between dynamic network movies to statistical models describing the network's change" (Filipov et al., 2023)

## Possible Research Opportunities

1. **Continuous event-based dynamic graph visualization**: Moving beyond discrete time steps to truly continuous temporal representations
2. **Scalable dynamic multivariate network visualization**: Techniques that handle large networks with multiple changing attributes simultaneously
3. **Comparative dynamic network visualization**: Methods for comparing evolution patterns across multiple networks

---

# 5. Uncertainty Visualization

## Overview

Uncertainty visualization addresses the representation of data quality, confidence intervals, probability distributions, and error in visualizations. Despite being identified as a top research problem for decades, the field remains fragmented with conflicting results and no unified theory.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Kamal et al., "Recent advances and challenges in uncertainty visualization: a survey" | Journal of Visualization | 2021 | Comprehensive survey of uncertainty visualization techniques and evaluation |
| "Maybe, Maybe Not: A Survey on Uncertainty in Visualization" | arXiv | 2023 | Overview across 4 pipeline phases: data collection, preprocessing, visualization, inference |
| "The Noisy Work of Uncertainty Visualisation" | arXiv | 2024 | Critical review identifying lack of clarity, conflicting results, and need for unifying theory |
| Padilla et al., "Uncertainty Visualization" (Chapter) | Springer | 2022 | Cognitive theory-based overview of best practices |
| Weiskopf, "Uncertainty Visualization: Concepts, Methods, and Applications" | Frontiers in Bioinformatics | 2022 | General concepts with emphasis on visual mappings and layout for uncertainty |
| Gillmann et al., "Uncertainty-aware visual analytics: scope, opportunities, and challenges" | The Visual Computer | 2023 | Proposes UAVA cycle; identifies open challenges |

## Existing Techniques

- **Error bars / confidence intervals**: Traditional but problematic for viewer comprehension
- **Hypothetical Outcome Plots (HOPs)**: Animation of individual draws from distribution
- **Quantile dotplots**: Show distribution quantiles directly
- **Violin plots / gradient plots**: Show distribution density
- **Glyph-based uncertainty**: Waviness, sketchiness, fuzziness of visual marks
- **Ensemble visualization**: Multiple simulation runs displayed simultaneously

## Existing Software

- **ggplot2**: Supports error bars, ribbons, confidence bands in R
- **ggdist / tidybayes**: R packages for distribution visualization
- **uncertainty-vis**: Web-based uncertainty visualization browser
- **Altair/Vega-Lite**: Supports error bars and intervals

## GitHub Projects

- mjskay/ggdist (R distribution visualization)
- mjskay/tidybayes (R tidy Bayesian analysis)
- uiuc-ischool-archived/uncertainty-vis (uncertainty visualization browser)

## Limitations

1. **"No commonly agreed upon methodology, formalisations, or a greater goal"** (Kinkeldey et al., cited in "The Noisy Work", 2024)
2. **"Conflicting results in the field are not limited to plot design and extend to the experimental findings"** (MacEachren et al., 2005, still unresolved in 2024)
3. **"The field is in desperate need of a unifying theory"** ("The Noisy Work", 2024)
4. **"There are no one-size-fits-all uncertainty visualization approaches"** (Padilla et al., 2022)
5. **"A practical problem is the lack of uncertainty visualization techniques in many existing software systems"** (Weiskopf, 2022)
6. **"Even experts struggle with judging the encoded uncertainty of comparably simple displays"** (Weiskopf et al., 2022)
7. **"There does not exist an approach that provides a theory that describes a systematic approach for UAVA"** (Gillmann et al., 2023)
8. **"The amount of knowledge that can be created by visualization is a highly subjective process... cannot be quantified so far"** (Gillmann et al., 2023)

## Future Work

- "Frameworks/libraries with ready-to-use UAVA approaches... implementation of such a framework was not conducted so far" (Gillmann et al., 2023)
- "Uncertainty needs to be formalised within the grammar of graphics" ("The Noisy Work", 2024)
- "Interacting with uncertainty visualization... this topic is largely untapped so far" (Weiskopf, 2022)
- "Layout is key to advanced visual mappings... visualization space is a scarce resource" (Weiskopf, 2022)
- "More research is needed to cover further examples of data types and visual analysis with uncertainty propagation" (Weiskopf, 2022)

## Possible Research Opportunities

1. **Unified uncertainty visualization grammar**: Extending the grammar of graphics (like ggplot2/Vega-Lite) with first-class uncertainty primitives
2. **Interactive uncertainty exploration**: Novel interaction techniques for exploring uncertain data distributions
3. **Uncertainty-aware R visualization framework**: Implementation of UAVA concepts as an R package with uncertainty propagation throughout the visualization pipeline
4. **Cognitive evaluation of combined uncertainty encodings**: How multiple uncertainty cues interact perceptually

---

# 6. Explainable AI Visualization

## Overview

Visualization for explainable and trustworthy machine learning (XAI+VIS) is one of the fastest-growing research areas. Chatzimparmpas et al. (2024) catalogued 542 techniques (up from 200 in 2020), demonstrating explosive growth. The focus is shifting from model explanation to fairness, bias, and user trust.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Chatzimparmpas et al., "Visualization for Trust in ML Revisited: The State of the Field in 2023" | IEEE CG&A | 2024 | 542 techniques; 119 categories; 8 open challenges; online browser |
| Wang et al., "Visual Analytics for ML: A Data Perspective Survey" | IEEE TVCG | 2024 | 143 papers from data-centric perspective |
| Chatzimparmpas et al., "A survey of visual analytics for XAI methods" | Computers & Graphics | 2022 | Review of VA for interpreting DL models |
| "Explanation User Interfaces: A Systematic Literature Review" | arXiv | 2025 | 146 papers on XUI design; HERMES framework |
| Kucher et al., "Towards Visual Analytics for XAI in Industrial Applications" | Analytics | 2025 | Conceptual framework for VA+XAI in industry |

## Existing Techniques

- **SHAP / LIME visualizations**: Feature importance explanations
- **Saliency maps / heatmaps**: Input attribution for deep learning
- **Counterfactual visualization**: "What if" scenario exploration
- **Decision tree extraction**: Rule-based model surrogate visualization
- **Confusion matrix / ROC curves**: Model performance visualization
- **Activation maximization**: Neuron-level understanding

## Existing Software

- **SHAP**: Python library for SHAP values
- **LIME**: Local interpretable model-agnostic explanations
- **TensorBoard**: ML training visualization
- **What-If Tool**: Interactive ML model exploration
- **DALEX**: R package for model explanation
- **iml**: R package for interpretable ML

## GitHub Projects

- slundberg/shap
- marcotcr/lime
- PAIR-code/what-if-tool
- ModelOriented/DALEX
- christophM/iml

## Limitations

1. **"User bias is absent from almost all VA systems"** (Chatzimparmpas et al., 2024)
2. **"Beginners and model developers are the two least represented target groups"** (Chatzimparmpas et al., 2024)
3. **"Customizable and reconfigurable visualizations that consider the users' experience level... remain largely underresearched"** (Chatzimparmpas et al., 2024)
4. **"Real-time online training processes... current methods mainly focus on analyzing the outcomes... neglecting the potential for an interactive training process"** (Chatzimparmpas et al., 2025)
5. **"Limited number of publications in other discipline venues may imply that visualization researchers struggle with external outreach"** (Chatzimparmpas et al., 2024)
6. **Fairness, equality/data bias only recently emerged** (Chatzimparmpas et al., 2024)
7. **Reinforcement learning "is also mostly ignored"** (Chatzimparmpas et al., 2024)

## Future Work

- O1: "Improving Popular XAI Methods" — improving interactivity and visual representations of existing XAI methods (Chatzimparmpas et al., 2024)
- O2: "New NN Approaches & Self-Supervision" (Chatzimparmpas et al., 2024)
- O3: "Multiverse & Confirmatory VA" — hypothesis testing, causal reasoning (Chatzimparmpas et al., 2024)
- O4: "Input/Output Uncertainty Quantification" — conformal prediction, robustness (Chatzimparmpas et al., 2024)
- O5: "Rigorous Evaluation & Benchmarking" — AI-assisted evaluation methods (Chatzimparmpas et al., 2024)
- O7: "Advancing the Impact & Reproducibility" — deployment, open-source (Chatzimparmpas et al., 2024)

## Possible Research Opportunities

1. **Bias-aware model visualization**: Visual techniques that explicitly surface data bias, label bias, and algorithmic bias
2. **Real-time model training visualization**: Interactive dashboards for monitoring and steering online/active learning
3. **Visual analytics for ensemble model explanation**: Visualization of bagging, boosting, stacking ensembles (identified as underexplored by Chatzimparmpas et al., 2024)
4. **Progressive XAI visualization**: Incremental model explanation as training progresses

---

# 7. Provenance Visualization

## Overview

Provenance visualization captures and visualizes the analytical reasoning process — how users arrived at insights, what data transformations were applied, what visualizations were inspected, and what conclusions were drawn. It supports reproducibility, collaboration, and self-reflection.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Ragan et al., "Characterizing Provenance in Visualization and Data Analysis" | IEEE TVCG | 2015 | Foundational taxonomy of provenance types |
| North et al., "Analytic Provenance: Process + Interaction + Insight" | CHI | 2011 | Early framework for analytic provenance |
| Xu et al., "Provenance for Visual Analytics: A Systematic Review" | Various | 2020+ | Multiple surveys on provenance capture, visualization, and reuse |

## Existing Techniques

- **Interaction logging**: Recording user actions (clicks, filters, selections)
- **State graphs**: Visualizing the sequence of analytical states
- **Insight provenance**: Recording findings and their derivation
- **Automated provenance**: Passive capture of analytical workflow
- **Manual annotation**: User-driven documentation of insights

## Existing Software

- **RStudio history / R Markdown**: Code-level provenance
- **Tableau / Power BI**: Some interaction logging
- **VisTrails**: Provenance-enabled scientific workflow system
- **No standard R package for visualization provenance**

## Limitations (Key Research Gaps)

1. **"Evaluative uses of provenance are still relatively sparse"** — few systems evaluate how provenance improves analysis outcomes
2. **No standardized framework** for capturing and comparing provenance across different visualization tools
3. **Insight provenance vs. interaction provenance disconnect** — most systems capture interactions, few capture the semantic meaning of insights
4. **Provenance visualization itself is underexplored** — how to visualize the provenance graph for sense-making
5. **Scalability of provenance data** — long analytical sessions produce massive provenance logs
6. **Privacy concerns** — detailed provenance captures sensitive analytical behavior

## Possible Research Opportunities

1. **Interactive provenance graph visualization**: Novel visualization techniques for navigating and exploring analytical provenance trails
2. **Provenance-driven visualization recommendation**: Using provenance history to recommend next analytical steps
3. **Comparative provenance visualization**: Side-by-side comparison of different analytical paths
4. **R package for visualization provenance**: Standardized provenance capture and visualization for R/Shiny applications

---

# 8. Streaming Data Visualization

## Overview

Streaming data visualization addresses the challenges of visualizing data that arrives continuously, often at high velocity. Key challenges include computational cost (processing infinite streams), cognitive load (keeping users oriented amid change), and balancing update frequency with visual stability.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Dasgupta et al., "Human Factors in Streaming Data Analysis: Challenges and Opportunities for Information Visualization" | CGF | 2018 | Survey focusing on change perception and human-centered design for streaming |
| Ulmer et al., "A Survey on Progressive Visualization" | IEEE TVCG | 2024 | Taxonomy of progressive visualization systems; 48 publications analyzed |
| Castanheira et al., "Evaluating Transitions for Streaming Big Data" | IEEE | 2021 | User study evaluating animated transitions between visual idioms for streaming data |
| Shilpika et al., "A Visual Analytics Approach for Hardware System Monitoring with Streaming FDA" | IEEE TVCG | 2022 | Incremental/progressive algorithms for streaming functional data analysis |

## Existing Techniques

- **Windowing**: Sliding windows, tumbling windows for data aggregation
- **Incremental computation**: Updating results without recomputing from scratch
- **Progressive visualization**: Showing intermediate results while computation continues
- **Animated transitions**: Smooth visual transitions between data updates
- **Change highlighting**: Pre-attentive visual cues for data changes

## Existing Software

- **Shiny**: R reactive programming for streaming data
- **Plotly + Dash**: Real-time streaming visualization
- **D3.js**: Custom streaming visualization
- **Apache Kafka + Kafka Streams**: Streaming data pipeline
- **Bokeh**: Python streaming visualization

## GitHub Projects

- rstudio/shiny
- plotly/dash
- bokeh/bokeh
- apache/kafka

## Limitations

1. **"The major bottlenecks in visualizing continuous data streams are computational cost and cognitive load"** (Shilpika et al., 2022)
2. **Trade-off between mental map preservation and information currency** (Krstajic and Keim, cited in Shilpika et al.)
3. **"Real-time processing was only necessary for four out of the 14 temporal progressive visualizations"** (Ulmer et al., 2024) — most systems do not truly operate in real-time
4. **Quality vs. latency trade-offs are poorly understood** for progressive streaming algorithms
5. **"A focus on real-time processing is almost non-existent"** (Ulmer et al., 2024)
6. **"How does the state-of-the-art streaming visualization design address... challenges in change perception?"** remains an open question (Dasgupta et al., 2018)

## Future Work

- "Developing a sustained research agenda around investigating how visualizations can better facilitate change perception in a streaming environment" (Dasgupta et al., 2018)
- "Exploring machine learning techniques so that a transition is triggered when needed" (Castanheira et al., 2021)
- "Progressive algorithms suffer from being unstable in the beginning, resulting in frequent overwriting update patterns" (Ulmer et al., 2024)
- "Handle high dimensional & stream data" identified as a new challenge (Bikakis et al., 2025)

## Possible Research Opportunities

1. **Cognitive-aware streaming visualization**: Visual encodings that adapt update frequency and salience based on measured cognitive load
2. **Progressive R Shiny dashboard for streaming data**: Implementing progressive computation patterns in R/Shiny with uncertainty visualization
3. **Smart transition selection for streaming visualizations**: ML-based selection of optimal animated transitions between visual idioms
4. **Hybrid streaming + batch visualization**: Combining real-time updates with historical context in a single coordinated view

---

# 9. High-dimensional Visualization

## Overview

High-dimensional visualization uses dimensionality reduction (DR) techniques to project high-dimensional data into 2D/3D for visual exploration. Despite the popularity of t-SNE and UMAP, critical concerns about misuse, unreliability, and interpretability have emerged.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| "Unveiling High-dimensional Backstage: A Survey for Reliable Visual Analytics with Dimensionality Reduction" | ACM CHI | 2025 | 133 papers; workflow model for DR reliability; taxonomy of unreliability sources |
| "Stop Misusing t-SNE and UMAP in Visual Analytics" | arXiv | 2025 | 114 papers reviewed; demonstrates widespread misuse; interview study with 12 practitioners |
| Kiefer & Rahman, "An Analytical Survey on Recent Trends in High Dimensional Data Visualization" | arXiv | 2021 | Performance comparison of t-SNE, UMAP, LargeVis, TriMap |
| do Nascimento, "Getting over High-Dimensionality: How Multidimensional Projection Methods Can Assist Data Science" | Applied Sciences | 2022 | Comprehensive overview with example code in Python and R |
| "Towards a Quantitative Survey of Dimension Reduction Techniques" | IEEE TVCG | 2019 | 44 techniques, 18 datasets, 7 quality metrics benchmarked |

## Existing Techniques

- **t-SNE**: Local structure preservation; computationally expensive; sensitive to parameters
- **UMAP**: Faster than t-SNE; better global structure preservation claimed
- **PCA**: Linear method; preserves global structure; cannot handle non-linear structures
- **MDS**: Preserves distance relationships; O(n³) complexity
- **LargeVis**: Scalable graph-based DR
- **TriMap**: Fast global structure preservation
- **Autoencoders / deep learning DR**: Neural network-based dimensionality reduction

## Existing Software

- **Rtsne / umap**: R packages for t-SNE and UMAP
- **scikit-learn**: Python DR implementations
- **dimRed / Rdimtools**: R packages for DR
- **FIt-SNE**: Fast interpolation-based t-SNE

## GitHub Projects

- KieranCampbell/Rtsne
- scikit-learn/scikit-learn
- jkrijthe/Rtsne
- berenslab/rner

## Limitations

1. **"The most commonly used DR methods, such as t-SNE and UMAP, are known to produce unreliable visual representations"** ("Stop Misusing", 2025)
2. **"Misuse of t-SNE and UMAP primarily stems from limited discourse on their appropriate use in visual analytics"** ("Stop Misusing", 2025)
3. **"Each scatterplot can only depict a single projection at once"** — fundamental limitation for subspace analysis (Reliable VA survey, 2025)
4. **"Scatterplots can hardly inform the original attribute values"** (Reliable VA survey, 2025)
5. **Research landscape is imbalanced**: "46% of papers propose new DR techniques but only 12.8% evaluate them" (Reliable VA survey, 2025)
6. **"We lack human-centered evaluations"** of DR techniques (Reliable VA survey, 2025)
7. **Limited discussion extending beyond 2D scatterplots** (Reliable VA survey, 2025)

## Future Work

- "Limited discussion extending beyond 2D scatterplots and the lack of available libraries to support more advanced DR techniques" (Reliable VA survey, 2025)
- Need for "three crucial challenges": human-centered evaluations, interpretability, reflection to domain knowledge (Reliable VA survey, 2025)
- "Automated hyperparameter tuning methods... without sacrificing interpretability" ("Stop Misusing", 2025)
- "Communicating DR Limitations" — visualizing confidence/trustworthiness of projections ("Stop Misusing", 2025)

## Possible Research Opportunities

1. **Reliability-aware DR visualization in R**: An R package that visualizes projection trustworthiness (stress, neighborhood preservation) alongside the projection
2. **Beyond scatterplots for high-D data**: Novel visualizations for DR projections using alternative visual metaphors (glyphs, linked matrices, etc.)
3. **Human-in-the-loop DR steering**: Interactive DR where users can guide projection quality based on domain knowledge
4. **Hyperparameter sensitivity visualization**: Visual tools for understanding how DR parameters affect projection outcomes

---

# 10. Multivariate Visualization

## Overview

Multivariate visualization techniques enable the exploration of datasets with many variables simultaneously. Core techniques include parallel coordinates, scatterplot matrices, radar/spider charts, and glyph-based approaches.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Nonato & Aupetit, "Multidimensional Projection for Visual Analytics: Linking Theory with Practice" | IEEE CG&A | 2019 | Linking DR theory with practical VA |
| Various surveys on parallel coordinates, scatterplot matrices | TVCG, CGF | Various | Design space analysis |
| Elmqvist & Fekete, "Hierarchical Aggregation for Information Visualization" | IEEE TVCG | 2010 | Subsetting and aggregation for multivariate data |

## Existing Techniques

- **Parallel coordinates**: Each dimension as a vertical axis; polylines represent data items
- **Scatterplot matrices (SPLOM)**: Matrix of 2D scatter plots for all dimension pairs
- **Star coordinates / radar plots**: Radial axis representation
- **Pixel-oriented techniques**: Each data value mapped to a colored pixel
- **Glyph-based**: Chernoff faces, star glyphs
- **Multiple coordinated views**: Linking across different visual representations

## Existing Software

- **GGally / plotly**: R parallel coordinates and SPLOM
- **parcoords**: R package for interactive parallel coordinates
- **tourr**: R package for grand tour visualization
- **liminal**: R package for multivariate tour animation

## GitHub Projects

- ggobi/ggally
- nspyrison/tourr
- nspyrison/liminal

## Limitations (Key Research Gaps)

1. **Parallel coordinates suffer from visual clutter** with large datasets — overplotting of polylines is severe
2. **Ordering of axes in parallel coordinates significantly impacts interpretability** but no principled method exists
3. **SPLOM does not scale** beyond ~10 dimensions
4. **Glyph-based methods have limited perceptual precision** and high cognitive load
5. **Dynamic multivariate visualization** — combining time with many variables — remains an open challenge
6. **Interaction techniques for multivariate visualization** are underdeveloped compared to the encoding techniques themselves

## Possible Research Opportunities

1. **Intelligent axis reordering for parallel coordinates**: ML-based ordering optimized for user tasks
2. **Interactive multivariate tour visualization in R**: Extending `tourr` with interactive Shiny-based exploration
3. **Scalable glyph-based multivariate visualization**: Perceptually optimized glyphs for dense multivariate displays
4. **Dynamic multivariate visualization**: Coordinated views combining time-series with multivariate data

---

# 11. Dashboard Visualization

## Overview

Dashboards are the most widely deployed form of data visualization in industry, yet they are surprisingly understudied in academic visualization research. Recent work has begun formalizing dashboard design patterns, evaluation methods, and user challenges.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Bach et al., "Dashboard Design Patterns" | IEEE TVCG | 2023 | 42 design patterns from 144 dashboards; 8 pattern groups; 6 dashboard genres |
| Alhamadi et al., "Data Quality, Mismatched Expectations, and Moving Requirements: The Challenges of User-Centered Dashboard Design" | ACM | 2022 | Interview study with 18 dashboard developers; 5 themes of challenges |
| Sarikaya et al., "What Do We Talk About When We Talk About Dashboards?" | IEEE TVCG | 2019 | Foundational characterization of dashboards |
| "Organizational decision making and analytics: An experimental study on dashboard visualizations" | Decision Support Systems | 2024 | 524-participant experiment on dashboard impact on decision-making |

## Existing Techniques

- **Overview + detail**: Summary metrics with drill-down capability
- **Multiple coordinated views**: Linked charts across a single canvas
- **Design patterns**: Narrative, analytical, embedded, operational, strategic dashboard genres
- **Responsive dashboards**: Adapting layout to screen size, device, and user role
- **Personalized/adaptive dashboards**: Tailoring content to user needs and behavior

## Existing Software

- **R Shiny**: Interactive R dashboard framework
- **Tableau / Power BI**: Commercial dashboard platforms
- **Flexdashboard**: R Markdown dashboard format
- **Grafana**: Real-time monitoring dashboards
- **Dash (Plotly)**: Python dashboard framework

## GitHub Projects

- rstudio/flexdashboard
- rstudio/shiny
- plotly/dash
- grafana/grafana

## Limitations

1. **"Dashboards have their distinct place in the visualization landscape, yet are still an overlooked subject in the VIS community"** (Bach et al., 2023)
2. **"Lack of responsiveness to different screen sizes"** — few solutions for adaptive/responsive dashboards (Bach et al., 2023)
3. **"Only a small number of dashboards support personalization"** (Bach et al., 2023)
4. **Developers are aware of user problems but "most of them do not use [automatic adaptation] on their dashboards"** (Alhamadi et al., 2022)
5. **"We still have minimal knowledge about how dashboards influence decision-makers"** (Decision Support Systems, 2024)
6. **"It is difficult to thematically tailor [visualization] to real-world domain expert projects"** (Wada et al., 2022)
7. **Lack of systematic evaluation frameworks** for dashboard effectiveness

## Future Work

- "What makes for a 'good' dashboard... will depend on many subjective and domain-specific factors" (Bach et al., 2023)
- "The diversity in dashboard design found here suggests more research into strengths and weaknesses of different dashboard genres" (Bach et al., 2023)
- "Personalization could allow a user to specify data they consider important and adapt the layout and size of components accordingly" (Bach et al., 2023)
- Adaptive, context-aware dashboards that adapt in real-time based on user behavior

## Possible Research Opportunities

1. **Adaptive dashboard framework for R/Shiny**: A flexible framework enabling personalized dashboard layouts, content, and interaction modes based on user profiling
2. **Dashboard effectiveness evaluation methodology**: Systematic approach to measuring how dashboards impact decision quality (not just user satisfaction)
3. **Dashboard design pattern recommender**: ML-based recommendation of dashboard design patterns based on data characteristics, user tasks, and domain
4. **Visual literacy-adaptive dashboards**: Dashboards that adjust complexity and annotation based on user visualization literacy

---

# 12. Geospatial Visualization

## Overview

Geovisualization integrates cartographic principles with interactive visualization for spatial data analysis. With the growth of IoT, smart cities, and remote sensing, the volume of geospatial data presents major challenges. Recent research addresses 3D urban data, AI integration, and cyberspace.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Krassanakis et al., "Geovisualization: Current Trends, Challenges, and Applications" | Geographies | 2023 | Editorial summarizing 8 contributions across diverse geovisualization domains |
| "Review of the state of practice in geovisualization in the geosciences" | Frontiers in Earth Science | 2024 | Survey of 3D geovisualization limitations: GIS, processing, occlusion, data management |
| Chen et al., "Artificial intelligence and visual analytics in geographical space and cyberspace" | Earth-Science Reviews | 2023 | Research opportunities and challenges for GeoAI and GeoVA |
| Miranda et al., "The State of the Art in Visual Analytics for 3D Urban Data" | CGF (EuroVis STAR) | 2024 | Categorization of VA for 3D urban data across why, what, and how dimensions |
| Schöttler et al., "Visualizing and Interacting with Geospatial Networks: A Survey and Design Space" | CGF | 2021 | 95 papers; 4 design dimensions for geospatial network visualization |

## Existing Techniques

- **Choropleth maps**: Thematic mapping with color-coded regions
- **Flow maps**: Showing movement between geographic locations
- **Heatmaps / density maps**: Continuous spatial distribution
- **3D terrain visualization**: DEM, LiDAR, photogrammetry rendering
- **Space-time cubes**: 3D representation of spatiotemporal data
- **Web maps**: Interactive tile-based mapping (Leaflet, Mapbox)

## Existing Software

- **Leaflet / mapview**: R interactive mapping packages
- **tmap**: R thematic mapping package
- **ggplot2 + sf**: R geospatial visualization
- **QGIS**: Open-source GIS
- **ArcGIS**: Commercial GIS platform
- **kepler.gl**: Web-based geospatial analysis

## GitHub Projects

- rstudio/leaflet
- r-spatial/sf
- r-tmap/tmap
- keplergl/kepler.gl

## Limitations

1. **"GIS has difficulties displaying 3D data beyond current applications that use DEMs"** and "undergoes translations to pseudo-3D, thus losing fidelity" (Frontiers in Earth Science, 2024)
2. **"Terabytes of data... computing and processing continually lag behind the development of data collection methods"** (Frontiers in Earth Science, 2024)
3. **"The benefits of 3D visualizations are not yet clear in geoscience applications"** — contradictory results on 3D vs. 2D effectiveness (Frontiers in Earth Science, 2024)
4. **"It remains challenging to thematically tailor geovisualization to real-world domain expert projects"** (Wada et al., 2022)
5. **"Digital occlusion and spatial interpretation challenges with users"** — 3D perception issues (Frontiers in Earth Science, 2024)

## Future Work

- "Effectiveness and efficiency analysis based on behavioral research methods and/or AI techniques" (Krassanakis et al., 2023)
- "Adaptation to modern virtual environments" (Krassanakis et al., 2023)
- "Creating synergies between the processing and analysis of geographical and cyber data" (Chen et al., 2023)
- "Interactivity and immersion are becoming more popular, particularly in the field of extended reality" (Frontiers in Earth Science, 2024)

## Possible Research Opportunities

1. **Uncertainty-aware geovisualization in R**: Techniques for visualizing spatial data quality, resolution limits, and interpolation uncertainty
2. **Multi-scale geospatial dashboard**: Smooth transitions between global, regional, and local views with appropriate visual encodings at each scale
3. **3D urban data visual analytics**: Coordinated 2D/3D views for urban data exploration

---

# 13. Text Visualization

## Overview

Text visualization transforms unstructured textual data into visual representations for analysis. The field spans document analysis, corpus linguistics, social media monitoring, and literary analysis. Recent work has focused on integrating LLMs, narrative visualization, and natural language generation for charts.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Liu et al., "Bridging Text Visualization and Mining: A Task-Driven Survey" | IEEE TVCG | 2019 | Comprehensive task-driven survey |
| "SoS TextVis: An Extended Survey of Surveys on Text Visualization" | Computers | 2019 | Meta-survey of 14 text visualization surveys |
| Voltoline et al., "Understanding Massive Text Visualization" | ACM | 2023 | Review of massive text visualization objectives, preprocessing, processing, visualization |
| Hearst, "Show It or Tell It? Text, Visualization, and Their Combination" | CACM | 2023 | Argues for text as co-equal with visualization; identifies research gaps |
| Hoque & Islam, "Natural Language Generation for Visualizations: State of the Art, Challenges and Future Directions" | CGF | 2025 | Survey of NLG for visualizations: chart captioning, QA, storytelling |
| He et al., "Leveraging Foundation Models for Crafting Narrative Visualization: A Survey" | IEEE TVCG | 2025 | 66 papers; reference model for FM-assisted narrative visualization |
| "The Evolving Duet of Two Modalities: A Survey on Integrating Text and Visualization for Data Communication" | arXiv | 2025 | 98 papers on text as narrative in visualization |

## Existing Techniques

- **Word clouds / tag clouds**: Frequency-based text visualization
- **Document similarity / topic maps**: MDS/t-SNE of document embeddings
- **Sentiment visualization**: Time series of sentiment polarity
- **Topic evolution**: River/stream graphs of topic prevalence over time
- **Text network analysis**: Co-occurrence networks, citation networks
- **Chart captioning**: NLG for automated chart description
- **Chart QA**: Question answering about chart content

## Existing Software

- **wordcloud / wordcloud2**: R word cloud packages
- **quanteda / tidytext**: R text analysis
- **LDAvis**: R topic model visualization
- **text2vec / text**: R text embedding and visualization

## GitHub Projects

- kshirley/LDAvis
- tidyverse/tidytext
- quanteda/quanteda

## Limitations

1. **"Scalability and handling huge volumes of data"** — most frequently reported challenge across 9 of 14 text visualization surveys
2. **"Lack of in-depth effective quantitative or qualitative evaluation"** — 9 of 14 surveys (SoS TextVis)
3. **"Adopting advanced linguistics techniques"** — 8 of 14 surveys (SoS TextVis)
4. **"Natural language ambiguity and uncertainty"** — 6 of 14 surveys (SoS TextVis)
5. **"The interplay between language and visualizations for communication is not well understood"** (Hearst, 2023)
6. **"The field does not use verified cognitive theories of how combinations of language and visualizations are read"** (Hearst, 2023)
7. **Uncertainty in NLP results is rarely visualized** — "Appropriate uncertainty visualization approaches should be developed" (SoS TextVis)

## Future Work

- "The visualization field should treat textual content as a primary design element" (Hearst, 2023)
- "Combining text with other data modalities, such as images, time series data, or geographical information" (Voltoline et al., 2023)
- "Uncertainty modeling and visualization research is expected to rise" in text visualization (SoS TextVis)
- "Need for a collaboration framework between multidisciplinary scholars" (SoS TextVis)
- "Automated data storytelling is still in its infancy" (Hoque & Islam, 2025)

## Possible Research Opportunities

1. **Uncertainty-aware text visualization**: Visualizing NLP uncertainty (confidence, ambiguity, model disagreement) in text analysis interfaces
2. **Interactive text-visualization storytelling**: R/Shiny-based narrative visualization combining text annotation with interactive charts
3. **Text-driven dashboard authoring**: Using natural language to generate and modify analytical dashboards
4. **Multi-modal text + visualization for data communication**: Systematic study and implementation of optimal text-vis integration patterns

---

# 14. Matrix Visualization

## Overview

Matrix visualization represents relational data as adjacency matrices. While less intuitive for path tracing than node-link diagrams, matrices excel for dense networks, do not suffer from edge crossing, and provide stable layouts.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Behrisch et al., "Matrix Reordering Methods for Table and Network Visualization" | CGF (EuroVis STAR) | 2016 | Comprehensive survey of matrix reordering |
| "DynTrix: A Hybrid Representation for Dynamic Graphs" | IEEE | 2024 | Extends NodeTrix to dynamic networks |
| "Animatrix" — animated matrix visualization for dynamic graphs | Various | 2014 | Animation-based dynamic matrix visualization |

## Existing Techniques

- **Adjacency matrices**: Raw matrix display with color encoding
- **Reordered matrices**: Permuting rows/columns to reveal patterns
- **NodeTrix**: Hybrid node-link + matrix representation
- **Hierarchical matrices**: Multi-level aggregation for large networks
- **Animation matrices**: Animated transitions for dynamic networks

## Existing Software

- **seriation**: R package for matrix reordering
- **heatmaply**: R interactive heatmap visualization
- **corrplot**: R correlation matrix visualization
- **ggcorrplot**: R correlation matrix via ggplot2

## GitHub Projects

- mhahsler/seriation
- talgalili/heatmaply
- taiyun/corrplot

## Limitations (Key Research Gaps)

1. **"Not intuitive for path tracing tasks"** compared to node-link (Kale et al., 2023)
2. **"Poor visual scalability"** for list-based views in matrix representations (Kale et al., 2023)
3. **"Very few studied matrix-based visualizations"** for dynamic multivariate networks (Kale et al., 2023)
4. **Reordering algorithms are NP-hard** — heuristics provide suboptimal results
5. **Large matrix visualization** — cells become too small to perceive
6. **Interaction techniques for matrices** are limited compared to node-link diagrams

## Possible Research Opportunities

1. **Interactive dynamic matrix visualization**: Animation and interaction techniques for exploring temporal change in matrix representations
2. **Perceptually-optimized matrix reordering**: Reordering algorithms that optimize for human pattern perception, not just algorithmic criteria
3. **Hybrid matrix+node-link for large dynamic networks**: Adaptive switching between representations based on network density and task
4. **Matrix visualization for uncertainty**: Encoding edge uncertainty in matrix cells

---

# 15. Temporal Visualization

## Overview

Temporal visualization focuses on representing time-oriented data. This area overlaps significantly with streaming, dynamic graph, and multivariate visualization. Key challenges include handling multiple time granularities, cyclic patterns, and event sequences.

## Major Papers

| Paper | Venue | Year | Contribution |
|-------|-------|------|-------------|
| Aigner et al., "Visualization of Time-Oriented Data" (Book) | Springer | 2023 | Comprehensive reference on time visualization |
| Burch et al., "Time Curves: Temporal Visualization" | IEEE TVCG | Various | Time curve techniques |
| "Time-series visualization" course module | — | 2026 | Course materials covering temporal data types and visualization methods |

## Existing Techniques

- **Line charts / area charts**: Standard temporal representation
- **Horizon graphs**: Space-efficient time series
- **Calendar views**: Cyclic temporal patterns
- **Time curves**: Abstract representation of temporal progression
- **Stream graphs**: Temporal evolution of compositional data
- **Gantt charts / timeline**: Event-based temporal representation

## Existing Software

- **ggplot2**: Comprehensive time series plotting
- **dygraphs**: R interactive time series
- **highcharter**: Interactive time series charts
- **timetk**: R time series visualization and analysis
- **TSstudio**: R time series exploration

## GitHub Projects

- rstudio/dygraphs
- jbkunst/highcharter
- business-science/timetk

## Limitations (Key Research Gaps)

1. **Multiple time granularities** — switching between years, months, days, hours in a single coherent view is challenging
2. **Cyclic vs. linear time representation** — integrating periodic patterns with overall trends
3. **Scalability in time** — very long time series with billions of observations
4. **Uncertainty in temporal data** — representing prediction intervals and forecast uncertainty over time
5. **Event sequence analysis** — visualizing sequences of events with complex temporal relationships
6. **Comparative time series** — comparing multiple time series across different time scales

## Possible Research Opportunities

1. **Multi-granularity temporal visualization**: Smooth semantic zooming across time scales in R/Shiny
2. **Uncertain time series visualization**: Combining forecast uncertainty, prediction intervals, and actual data in a unified visual representation
3. **Event sequence analytics dashboard**: Visual analytics for complex event sequence data (e.g., healthcare, user behavior)
4. **Comparative temporal visualization**: Techniques for comparing temporal patterns across groups, conditions, or scenarios

---

# 16. Comparative Analysis & Ranking

## Ranking Criteria

| Criterion | Description |
|-----------|-------------|
| **Novelty** | How underexplored is the area? How many open problems exist? |
| **Learning value** | How much will the researcher learn about core visualization concepts? |
| **Difficulty** | Technical and conceptual challenge level |
| **Dataset availability** | Are suitable datasets readily accessible? |
| **R package availability** | Does the R ecosystem support this area? |
| **Suitability for final-year project** | Can a student deliver meaningful results in 1-2 semesters? |
| **Publication potential** | Could results be published at a workshop or short paper venue? |

## Area Rankings

| Rank | Area | Novelty | Learning | Difficulty | Datasets | R Pkgs | Suitability | Publish | Overall |
|------|------|---------|----------|------------|----------|--------|-------------|---------|---------|
| 1 | **Uncertainty Visualization** | ★★★★★ | ★★★★★ | ★★★★ | ★★★★ | ★★★ | ★★★★★ | ★★★★★ | **32/35** |
| 2 | **Explainable AI Visualization** | ★★★★★ | ★★★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★★★ | ★★★★★ | **32/35** |
| 3 | **Streaming Data Visualization** | ★★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★★ | ★★★★ | ★★★★ | **29/35** |
| 4 | **High-dimensional Visualization** | ★★★★ | ★★★★★ | ★★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★★★ | **29/35** |
| 5 | **Dashboard Visualization** | ★★★★ | ★★★★ | ★★★ | ★★★★★ | ★★★★★ | ★★★★★ | ★★★ | **29/35** |
| 6 | **Dynamic Graph Visualization** | ★★★★ | ★★★★ | ★★★★★ | ★★★ | ★★★ | ★★★ | ★★★★ | **26/35** |
| 7 | **Text Visualization** | ★★★ | ★★★★ | ★★★★ | ★★★★★ | ★★★★ | ★★★★ | ★★★ | **26/35** |
| 8 | **Provenance Visualization** | ★★★★★ | ★★★ | ★★★★ | ★★ | ★ | ★★★ | ★★★★ | **25/35** |
| 9 | **Interactive Visualization** | ★★★ | ★★★★ | ★★★ | ★★★★ | ★★★★★ | ★★★★ | ★★★ | **25/35** |
| 10 | **Visual Analytics** | ★★★ | ★★★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★★ | ★★★★ | **25/35** |
| 11 | **Geospatial Visualization** | ★★★ | ★★★★ | ★★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★★ | **25/35** |
| 12 | **Multivariate Visualization** | ★★★ | ★★★★ | ★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★ | **24/35** |
| 13 | **Network Visualization** | ★★ | ★★★★ | ★★★★ | ★★★★ | ★★★★★ | ★★★★ | ★★ | **24/35** |
| 14 | **Temporal Visualization** | ★★ | ★★★ | ★★★ | ★★★★★ | ★★★★★ | ★★★★ | ★★ | **23/35** |
| 15 | **Matrix Visualization** | ★★★ | ★★★ | ★★★ | ★★★ | ★★★ | ★★★ | ★★ | **20/35** |

## Key Insights from Ranking

1. **Uncertainty Visualization** ranks highest because: (a) "no commonly agreed methodology" exists, (b) "the field is in desperate need of a unifying theory," (c) "there are no one-size-fits-all approaches," (d) frameworks/libraries are missing, (e) interaction with uncertainty is "largely untapped," (f) there is high publication potential, and (g) R has strong foundations (ggplot2, ggdist) that could be extended.

2. **Explainable AI Visualization** ranks highly because: (a) explosive growth (200→542 techniques), (b) fairness and bias are newly emerging, (c) reinforcement learning is "mostly ignored," (d) real-time ML training visualization is an open challenge, and (e) user bias is absent from almost all systems.

3. **Dashboard Visualization** ranks well for a final-year project because: (a) dashboards are "overlooked" in academic VIS research, (b) personalization and adaptation are underdeveloped, (c) R/Shiny provides a strong implementation platform, (d) evaluation methodology is lacking, and (e) the practical impact is immediate and demonstrable.

4. **Provenance Visualization** is high in novelty but low in R ecosystem support, making it harder to implement.

5. **Streaming Data Visualization** is strong but technically demanding due to real-time computation requirements.

---

## Methodological Notes

- This review covers approximately the last 5 years (2020–2026) with foundational earlier references where necessary.
- Literature was drawn from IEEE VIS, TVCG, EuroVis, PacificVis, CHI, ACM Digital Library, CGF, and other major venues.
- Claims of open problems are supported by explicit statements from published surveys and research papers with citations.
- The rankings in Section 16 reflect a qualitative synthesis of all reviewed literature and are indicative, not absolute.

---

*End of Report*