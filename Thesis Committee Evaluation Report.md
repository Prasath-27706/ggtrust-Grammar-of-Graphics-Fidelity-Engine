# PhD Thesis Committee — Research Project Evaluation

**Committee:** IEEE VIS | EuroVis | IEEE TVCG | ACM CHI | Information Visualization | HCI | Data Visualization | R Package Development

**Date:** July 2026

**Evaluation Method:** Full research review of Top 5 projects from the preceding project ranking.

**Constraint:** 16 weeks, single final-year student, primary language R.

---

## FINAL RANKING REFERENCE

| Rank | ID | Project | Score |
|------|----|---------|-------|
| 1 | P7 | TrustDR — Reliability-Aware DR with Trustworthiness Glyphs | 59 |
| 2 | P3 | UAVA-R — Uncertainty Propagation Across Pipelines | 58 |
| 3 | P12 | BiasVis — Bias Discovery Visual Analytics | 58 |
| 4 | P1 | ggdistinct — Uncertainty Grammar for ggplot2 | 57 |
| 5 | P4 | CogNet — Cognitive Load-Adaptive Network Animation | 57 |

---

# PROJECT 1: TrustDR — Reliability-Aware DR Projection with Trustworthiness Glyphs

## PART 1: Research Novelty

**Claimed novelty:** Per-point trustworthiness glyphs for DR projections; background reliability landscape; skeptical point highlighting; interactive verification view.

**Is the claim actually novel?** Partially. The idea that DR projections are unreliable is well-established (Wattenberg et al., 2016; "Stop Misusing t-SNE", 2025). The literature explicitly calls for communicating DR limitations. However, per-point quality metrics already exist: co-ranking matrices (Lee & Verleysen, 2009), trustworthiness-continuity curves (Venna & Kaski, 2006), and neighborhood preservation measures. The R package `dimRed` already computes these. The novelty is in the **visual encoding** of these metrics as per-point glyphs, not in the metrics themselves.

**Closest existing systems:**
- `dimRed` R package (quality metrics, but no per-point glyph visualization)
- `Rtsne` / `umap` (no reliability visualization at all)
- Embedding Projector (Google) — shows projection but no per-point quality
- "DR Quality Metrics" by Martins et al. (VIS 2024) — evaluates DR quality but does not provide a general-purpose R implementation with glyphs
- ViDX (visual debugging of DR) — closest in concept but focused on parameter tuning, not general glyph annotation

**Which papers already solve part of the problem?**
- Lee & Verleysen (2009) — co-ranking matrix for quality assessment
- Venna & Kaski (2006) — trustworthiness and continuity measures
- Martins et al. (VIS 2024) — visual quality assessment framework
- "Unveiling High-dimensional Backstage" (CHI 2025) — identifies the gap but does not implement

**Incremental parts:**
- Computing trustworthiness/continuity per point is straightforward `dimRed` functionality
- The contour overlay is a standard 2D interpolation (kriging, loess)
- The linked verification view is a standard coordinated-view pattern

**Genuinely new parts:**
- The specific glyph design (pie-slice completeness, concentric ring integrity) for per-point trustworthiness
- The skeptical-point highlighting paradigm (desaturation, jitter, halos)
- Combining all elements into a single, usable R package
- The parameter sensitivity lens

**Novelty assessment:** Moderate. The visual encoding of per-point trustworthiness is new, but the underlying quality metrics and interaction patterns are not. This is a **visual design innovation** rather than a methodological breakthrough.

## PART 2: Research Risk

| Risk | Severity | Explanation |
|------|----------|-------------|
| Glyph design validation | HIGH | Designing glyphs that actually convey trustworthiness effectively requires perceptual validation. Without a user study, the glyphs may not be better than existing methods (coloring by quality). |
| Perceptual clutter | HIGH | Adding glyphs to every point in a scatterplot with thousands of points creates visual clutter. The glyphs may obscure the very structure they aim to annotate. |
| Existing solutions | MEDIUM | Users can already color points by quality metrics using standard ggplot2. The incremental benefit of glyphs over simple color encoding needs justification. |
| Evaluation difficulty | MEDIUM | Proving that "glyphs improve trust in DR" requires a carefully designed user study with appropriate tasks. Self-reported trust is unreliable. |
| R performance | LOW | t-SNE/UMAP in R handle thousands of points; glyph rendering with ggplot2 extensions is feasible. |
| Just noticeable differences | MEDIUM | Glyph elements must be perceptually discriminable. Small differences in trustworthiness must map to visible glyph differences. |

**Overall risk:** MEDIUM-HIGH. The main risk is that the glyphs are not perceptually effective, and the project produces a tool that nobody uses because coloring already works well enough.

## PART 3: Implementation Review (16 Weeks)

| Weeks | Tasks | Effort |
|-------|-------|--------|
| 1–2 | Literature review: DR quality metrics, glyph design principles, existing tools | Low |
| 3–4 | Implement quality metric computation wrapper (dimRed + custom per-point metrics) | Medium |
| 5–7 | Implement glyph rendering system (ggproto extension, multiple glyph types) | HIGH — bottleneck |
| 8–9 | Implement background reliability landscape (2D interpolation + contour) | Medium |
| 10 | Implement interactive verification view (click → show neighbors) | Medium |
| 11–12 | Implement parameter sensitivity lens | Medium |
| 13–14 | User study design, IRB, recruitment, data collection | HIGH — bottleneck |
| 15–16 | Analysis, writing, package documentation, vignettes | High |

**Bottlenecks:**
1. **Glyph rendering in ggplot2** — building custom ggproto geoms is notoriously difficult. The glyphs must be parameterized, handle overplotting, and work with facets. Expect 2–3 weeks of trial-and-error.
2. **User study** — recruiting 20+ participants, running the study, and analyzing results in 2 weeks is extremely tight. Most VIS papers spend 4–6 weeks on evaluation alone.

**Feasibility:** MARGINAL. The implementation itself is doable, but the user study timeline is unrealistic. Without the user study, the paper is a "tool paper" with anecdotal validation — likely only workshop-level publication.

## PART 4: Visualization Contribution

**Is the visualization actually the contribution?** YES — but barely.

The contribution is a **new visual encoding** (per-point glyphs for trustworthiness). However, the project relies heavily on:
- Pre-existing quality metrics (dimRed)
- Standard interaction patterns (brushing, linking)
- Standard ggplot2 extension patterns

The visualization contribution is **moderate**: the glyph designs are new, but they are applied to an existing problem using existing metrics. The committee notes that the project is more of an **R package/tool contribution** than a fundamental visualization research contribution. The question "what new visual encoding or interaction technique does this introduce?" has a positive but weak answer.

## PART 5: R Suitability

**Can R implement this?** 90%

**What works in R:**
- `Rtsne`, `umap`, `dimRed` — all available
- `ggplot2` + `ggproto` — glyph extension possible
- `interp`, `akima`, `metR` — contour/interpolation
- `shiny` — interaction
- `plotly` — interactive verification

**Where R becomes limiting:**
- **Glyph rendering performance** — rendering thousands of custom glyphs with grid graphics will be slow. For >5000 points, expect multi-second rendering delays.
- **3D surface interaction** — the parameter sensitivity lens (3D surface) is clunky in R/plotly compared to Python alternatives.
- **Real-time parameter sweep** — recomputing t-SNE at multiple parameter settings is CPU-bound but manageable with parallel processing.

**Required packages:** Rtsne, umap, dimRed, ggplot2, ggnewscale, interp/akima, shiny, plotly, ggforce, grid.

## PART 6: Publication Review

**Target:** IEEE VIS, EuroVis, TVCG

**Reviewer verdict:** *"Interesting but incremental."*

**Reviewer comments would likely include:**
- "The per-point glyph design is novel but the evaluation does not show that it outperforms simpler alternatives (color encoding, size encoding)."
- "The quality metrics used are well-established. The contribution is primarily in the visual encoding, which is a modest contribution."
- "The study has limited statistical power (n=20) and the tasks are artificial. Real analysts do not need per-point quality for routine DR use."
- "The parameter sensitivity lens is useful but similar to existing tools (optuna dashboard)."
- "The skeptical point highlighting is a nice interaction technique but not sufficient for a full paper."

**Best outcome:** EuroVis Short Paper or VIS Poster. **Not** a VIS Full Paper.

## PART 7: Minimum Publishable Unit

Cut the project to:
1. **One glyph design** (star glyph with wedge completeness) — not five alternatives
2. **One quality metric** (trustworthiness) — not all metrics
3. **Static R package** — remove the Shiny app
4. **No user study** — replace with expert review + case studies
5. **No parameter sensitivity lens**

This reduces the project to 6–8 weeks and preserves the core novelty: per-point trustworthiness glyphs for DR. The paper becomes a short design study.

## PART 8: Evaluation Plan

**Design:** Within-subjects comparison of three conditions: (a) standard scatterplot, (b) color-by-quality, (c) glyph-enhanced.

**Tasks:**
1. Identify which points are reliably placed (accuracy)
2. Estimate projection quality in a region (accuracy)
3. Compare two projections' reliability (time + accuracy)
4. Detect misleading projections (error detection)

**Metrics:** Accuracy, completion time, confidence, trust (Likert), preference.

**Statistical tests:** Repeated-measures ANOVA (or Friedman for non-parametric).

**Participants:** 20–30, drawn from data science students/staff.

**Success criteria:** Glyph condition shows statistically significant improvement in accuracy and trust without significant increase in time.

**Committee note:** This is a textbook evaluation but risks showing that color-by-quality performs equally well, which would undermine the entire project.

## PART 9: Learning Value

- Dimensionality reduction theory — HIGH
- Projection quality metrics — HIGH
- Glyph design — HIGH
- Visual perception of symbols — MEDIUM
- ggplot2 ggproto extension — HIGH
- R package development — HIGH
- User study design — MEDIUM (rushed)
- Contour/surface interpolation — MEDIUM

## PART 10: Commercial Potential

- R package on CRAN — YES (moderate adoption)
- GitHub project — YES
- Research paper — YES (short)
- Patent — NO (prior art on quality metrics)
- Startup — NO
- Commercial software — NO

---

# PROJECT 2: UAVA-R — Uncertainty Propagation Visualization Across Analytical Pipelines

## PART 1: Research Novelty

**Claimed novelty:** Sankey-like flow diagram where edge width = uncertainty magnitude; uncertainty amplification factor encoding; what-if sliders for uncertainty simulation.

**Is the claim actually novel?** The gap is real and well-identified (Gillmann et al., 2023: "No systematic UAVA approach"). However, the proposed solution has **severe novelty issues**.

**Closest existing systems:**
- **Uncertainty propagation is a solved problem in statistics** — error propagation formulas (Taylor, 1997) are textbook material. The math is not new.
- **Sankey diagrams with width encoding** — standard and widely implemented (networkD3, ggplot2 + ggsankey).
- **Pipeline visualization** — Apache Beam, TensorBoard, KNIME, and RapidMiner all visualize analytical pipelines.
- **What-if analysis** — Tableau "what-if" parameters, Shiny sliders.

**Which papers already solve part of the problem?**
- Gillmann et al. (2023) — proposed the UAVA cycle theoretically
- Becker et al. (2021) — uncertainty propagation in visualization pipelines
- All statistical error propagation literature (Taylor, JCGM 100:2008)

**Incremental parts:**
- Sankey diagram with edge width = uncertainty — trivial modification of existing Sankey implementations
- What-if sliders — standard Shiny interaction pattern
- Pipeline stage drill-down — standard coordinated-view pattern
- Side-by-side pipeline comparison — standard dual-view pattern

**Genuinely new parts:**
- Uncertainty amplification factor as a specific visual encoding
- Integrated pipeline + distribution view showing uncertainty flow
- Practical R implementation of the UAVA cycle

**Novelty assessment:** LOW. The committee is concerned that this project is **re-packaging known techniques** (error propagation, Sankey diagrams, what-if analysis) under a new name (UAVA). The "uncertainty amplification factor" is a ratio of variances — a standard statistical quantity. Sankey edge width encoding is already used for flows. The committee notes that Gillmann's paper is a **conceptual framework**, not a call to implement obvious visualization mappings.

## PART 2: Research Risk

| Risk | Severity | Explanation |
|------|----------|-------------|
| Novelty rejection | VERY HIGH | A VIS reviewer will immediately recognize that Sankey diagrams, what-if sliders, and variance propagation are all well-known. The project may be desk-rejected as "insufficient novelty." |
| User understanding | HIGH | The intended audience (data analysts) already understands uncertainty propagation from standard statistical training. The visualization may not add value over numerical uncertainty tables. |
| Pipeline generality | HIGH | A "general" pipeline abstraction that works across survey data, climate models, financial forecasting, and medical diagnostics is extremely difficult to design. Each domain has different uncertainty semantics. |
| Mathematical complexity | HIGH | The student must correctly implement uncertainty propagation for arbitrary pipelines, which requires understanding correlated vs. uncorrelated errors, non-linear propagation (delta method), Monte Carlo simulation, and Bayesian hierarchical models. |
| Scope creep | HIGH | "What-if" sliders, "side-by-side comparison," "drill-down," and "uncertainty decomposition" are each substantial features individually. |
| Existing commercial tools | MEDIUM | Simul8, @RISK, and ModelRisk already do pipeline uncertainty simulation with visualization. |

**Overall risk:** VERY HIGH. This is the riskiest project in the top 5.

## PART 3: Implementation Review (16 Weeks)

| Weeks | Tasks | Effort |
|-------|-------|--------|
| 1–2 | Literature review + pipeline abstraction design | Medium |
| 3–5 | Implement pipeline uncertainty propagation engine | VERY HIGH — bottleneck |
| 6–7 | Implement Sankey visualization with uncertainty width | Medium |
| 8–9 | Implement distribution views at each stage | Medium |
| 10–11 | Implement what-if sliders + drill-down | Medium |
| 12 | Implement pipeline comparison mode | Medium |
| 13–15 | Three case studies with different pipeline types | HIGH |
| 16 | Writing + documentation | High |

**Bottlenecks:**
1. **Pipeline uncertainty engine** — building a general-purpose uncertainty propagation framework that handles correlated errors, non-linear transformations, Monte Carlo, and Bayesian models is a **semester-long project in itself**. A single student cannot do this in 3 weeks.
2. **Three diverse case studies** — each domain (survey, climate, finance) requires deep domain understanding to set up realistic pipelines.
3. **Correctness** — uncertainty propagation errors are subtle. The student may produce a visualization that is **mathematically wrong**.

**Feasibility:** NOT FEASIBLE in 16 weeks. The uncertainty propagation engine alone is a research project.

## PART 4: Visualization Contribution

**Is the visualization actually the contribution?** NO.

The primary contribution is an **analytics framework** (uncertainty propagation pipeline) that happens to include visualization. The Sankey diagram, distribution plots, and what-if sliders are all **standard visualizations applied to a non-standard problem domain**. There is no new visual encoding, no new interaction technique, and no new visual design.

The committee would reject this project as **not a visualization contribution**. It belongs in a statistics or simulation journal, not VIS.

## PART 5: R Suitability

**Can R implement this?** 50%

**What works in R:**
- Sankey diagrams — `networkD3`, `ggsankey`
- Distribution plots — `ggplot2`, `ggdist`
- What-if sliders — `shiny`
- Error propagation — manual implementation

**Where R becomes limiting:**
- **Symbolic uncertainty propagation** — R is not designed for symbolic computation. The project may require the `Deriv` package or manual derivative coding.
- **Monte Carlo simulation** — R can do this, but large simulations (>1M draws) are slow.
- **Bayesian uncertainty propagation** — requires `brms`, `rstan`, or `rjags`, which have complex installation requirements and long computation times.
- **Climate model chain integration** — impossible in R. Climate models are Python/C++ ecosystems.
- **General pipeline abstraction** — R's type system makes it difficult to build a general pipeline representation that works across multiple domains.

**Required packages:** ggplot2, networkD3/ggsankey, ggdist, shiny, brms/rstan, Deriv, tidyverse, metR.

## PART 6: Publication Review

**Target:** IEEE VIS, EuroVis, TVCG

**Reviewer verdict:** *"Already exists. Insufficient novelty."*

**Reviewer comments would likely include:**
- "This is a straightforward application of Sankey diagrams and error propagation formulas. The uncertainty amplification factor is simply the ratio of output to input variance."
- "The UAVA framework (Gillmann et al., 2023) proposes a conceptual model, but the authors do not justify why a visualization is needed rather than standard uncertainty quantification."
- "The what-if analysis is a standard parameter sensitivity analysis, well-covered in existing tools."
- "The paper lacks evidence that this visualization improves understanding over numerical uncertainty reporting."
- "The implementation is limited to simple linear pipelines. Real pipelines have feedback loops, non-linearities, and correlated errors that this system does not handle."

**Best outcome:** Desk rejection from VIS. Possibly a workshop paper at a statistics venue.

## PART 7: Minimum Publishable Unit

Even reduced to:
- One pipeline type (simple linear chain with 3 stages)
- One uncertainty propagation method (Monte Carlo)
- No what-if sliders
- No comparison mode
- No domain case studies

The core remains: "Sankey diagram with variance widths." This is a **tutorial example**, not a research contribution. The MPU is not publishable.

## PART 8: Evaluation Plan

**Design:** Compare UAVA-R visualization vs. numerical uncertainty table.

**Tasks:**
1. Identify which stage contributes most to overall uncertainty
2. Decide whether to invest in reducing uncertainty at a specific stage
3. Estimate output uncertainty given input uncertainty

**Committee note:** The evaluation is doomed. If the visualization helps, it proves only that "a picture is better than numbers" — known for decades. If it does not help, the project has no value.

## PART 9: Learning Value

- Uncertainty quantification theory — HIGH
- Error propagation — HIGH
- Monte Carlo simulation — HIGH
- Sankey diagram construction — MEDIUM
- Pipeline architecture — MEDIUM
- Domain-specific modeling — LOW (too diverse)

## PART 10: Commercial Potential

- R package — NO (too specialized)
- GitHub — MAYBE
- Research paper — VERY LOW
- Patent — NO
- Startup — NO
- Commercial — NO

**Committee verdict on UAVA-R: REJECT.** Insufficient visualization contribution, excessive algorithmic complexity, unmanageable scope, and high risk of desk rejection at VIS.

---

# PROJECT 3: BiasVis — Bias Discovery Visual Analytics for ML Pipelines

## PART 1: Research Novelty

**Claimed novelty:** Integrated bias visualization across data, label, and model stages; intersectional bias heatmap; bias propagation Sankey.

**Is the claim actually novel?** The gap (Chatzimparmpas et al., 2024: "user bias absent from VA systems") is real. However, the market and literature have moved fast since 2024. By mid-2026, fairness toolkits have proliferated: IBM AIF360, Google What-If Tool, Microsoft Fairlearn, FATE (Fairness, Accountability, Transparency in ML). Many already include visualization dashboards.

**Closest existing systems:**
- **IBM AIF360** — comprehensive fairness metrics with visualization
- **Google What-If Tool** — interactive fairness analysis with counterfactual editing
- **Microsoft Fairlearn** — fairness dashboard with subgroup performance visualization
- **Aequitas** — bias audit toolkit with visualization
- **SHAP/LIME** — model explanation with bias indicators
- **Chatzimparmpas et al. (2024) FairVis** — fairness visualization specifically

**Which papers already solve part of the problem?**
- Chatzimparmpas et al. (2024) — comprehensive fairness visualization survey
- Cabrera et al. (2019) — FairVis: fairness visualization
- Richardson et al. (2021) — bias in ML pipelines
- AIF360 (Bellamy et al., 2019) — fairness metric computation

**Incremental parts:**
- Data bias panel — simple bar charts of subgroup distributions
- Model bias panel — performance difference bar charts (trivial)
- Fairness metrics dashboard — direct output from AIF360/fairmodels
- Counterfactual what-if — similar to Google What-If Tool
- Bias propagation Sankey — same concern as UAVA-R (standard Sankey)

**Genuinely new parts:**
- **Intersectional bias heatmap** — performance across pairs of protected attributes is genuinely useful and novel for R
- **Label bias alluvial diagram** — inter-annotator agreement visualization is under-explored
- **Combining data + label + model bias in single coordinated view** — novel integration

**Novelty assessment:** MODERATE. The individual components exist in separate tools. The integration is novel, as is the intersectional bias heatmap. However, the project is playing catch-up with industry tools (Google What-If Tool already does most of this).

## PART 2: Research Risk

| Risk | Severity | Explanation |
|------|----------|-------------|
| Competition from industry | HIGH | Google What-If Tool, IBM AIF360, and Microsoft Fairlearn already provide polished fairness visualization. An R student project cannot compete with Google's UX team. |
| Evaluation difficulty | HIGH | "Does bias visualization improve fairness?" is a loaded question. Evaluations risk being either trivial (yes, showing bias helps) or impossible (measuring real-world fairness improvement). |
| Fairness definition disagreement | MEDIUM | The student must navigate contested definitions of fairness (demographic parity vs. equal opportunity vs. predictive parity). Each definition changes the visualization. |
| Controversial datasets | MEDIUM | COMPAS, Adult Income, German Credit are standard but ethically loaded. The student must handle them responsibly. |
| ML infrastructure | MEDIUM | Requires training ML models, computing fairness metrics. Manageable but time-consuming. |
| Scope | MEDIUM | Six panels + Sankey + counterfactuals = substantial UI work. |

**Overall risk:** MEDIUM. Feasible but the competition from Google/IBM/Microsoft tools makes the contribution feel small.

## PART 3: Implementation Review (16 Weeks)

| Weeks | Tasks | Effort |
|-------|-------|--------|
| 1 | Literature review: bias types, fairness definitions, existing tools | Low |
| 2–3 | Data bias panel (distribution plots, imbalance metrics) | Medium |
| 4–5 | Label bias panel (alluvial diagram, error heatmap) | Medium |
| 6–7 | Model bias panel (performance delta, subgroup comparison) | Medium |
| 8–9 | Intersectional bias heatmap | Medium |
| 10 | Fairness metrics dashboard | Medium |
| 11 | Bias propagation Sankey | Low |
| 12 | Counterfactual what-if | HIGH — bottleneck |
| 13 | Integration + Shiny coordination | Medium |
| 14–15 | Case studies (3 datasets) | Medium |
| 16 | Writing | Medium |

**Bottlenecks:**
1. **Counterfactual what-if** — requires the student to reweight data, retrain models, and recompute metrics on the fly. In Shiny, retraining models causes UI freezes. Async computing (`future`, `promises`) is complex.
2. **Integration** — coordinating 6+ panels in Shiny with reactive cross-filtering is challenging for a student.
3. **Fairness metric correctness** — subtle bugs in fairness computation can produce misleading visualizations that look correct.

**Feasibility:** MODERATE. The project is doable but the counterfactual feature may need to be cut.

## PART 4: Visualization Contribution

**Is the visualization actually the contribution?** NO — this is primarily an **analytics/ethics** project.

The core contribution is: "a tool that surfaces bias in ML pipelines." The visualizations (bar charts, heatmaps, Sankey, alluvial diagrams) are **standard chart types**. There is no new visual encoding, no new interaction technique, and no visualization theory contribution.

The intersectional bias heatmap is the closest thing to a novel visualization, but it is a straightforward 2D heatmap — a standard chart type applied to a non-standard data pairing.

**This project belongs at FAccT or AIES, not at VIS.** The committee would reject this as "not a visualization paper."

## PART 5: R Suitability

**Can R implement this?** 85%

**What works in R:**
- `fairmodels`, `fairness` — fairness metrics
- `DALEX`, `iml` — model explanation
- `ggplot2`, `plotly` — bar charts, heatmaps
- `networkD3` — Sankey
- `alluvial`, `ggalluvial` — label bias
- `shiny` — integration
- `tidymodels`, `caret` — ML pipeline

**Where R becomes limiting:**
- **Counterfactual simulation** — Python's AIF360 has better counterfactual support than R's `fairmodels`
- **Deep learning bias** — R lacks PyTorch/TensorFlow integration for deep learning bias analysis
- **Performance** — retraining models interactively in Shiny is slow
- **Model types** — R's ML ecosystem (caret/tidymodels) covers fewer model types than Python

**Required packages:** fairmodels, DALEX, iml, ggplot2, plotly, networkD3, ggalluvial, shiny, tidymodels, recipes, workflows.

## PART 6: Publication Review

**Target:** IEEE VIS, EuroVis, TVCG

**Reviewer verdict:** *"Not a visualization contribution. Reject. This belongs at FAccT."*

**Reviewer comments would likely include:**
- "The visual encodings are all standard. The contribution is the integration, which is a software engineering contribution, not a visualization one."
- "No new visualization techniques are introduced. Every chart type in this paper is off-the-shelf."
- "The paper would be a better fit at FAccT, AIES, or CHI, where the contribution of an integrated fairness toolkit would be appreciated."
- "The evaluation shows that visualization helps discover bias — a result that is not surprising and does not advance visualization science."
- "The counterfactual what-if feature is computationally expensive and not well-integrated."

**Best outcome:** Reject from VIS. Acc
eptable at FAccT or AIES as a demo/tool paper. But the committee is evaluating for VIS, and **BiasVis is not a VIS paper**.

## PART 7: Minimum Publishable Unit

Cut to:
1. Intersectional bias heatmap only
2. One dataset (COMPAS)
3. Remove label bias panel
4. Remove counterfactuals
5. Remove bias propagation Sankey

The MPU is: "A heatmap-based visualization for intersectional bias in ML models." This is still a standard heatmap. The novelty is the **application domain** (intersectional fairness), not the visualization. This is not a VIS contribution.

## PART 8: Evaluation Plan

**Design:** Participants use BiasVis vs. baseline (AIF360 dashboard) to identify bias sources.

**Tasks:**
1. Identify which subgroup is most disadvantaged
2. Find which stage (data/label/model) contributes most to bias
3. Propose a fairness intervention

**Metrics:** Accuracy, time, comprehensiveness, satisfaction.

**Committee note:** The evaluation will likely show that BiasVis is "easier to use" than AIF360's interface. This is a usability finding, not a visualization finding.

## PART 9: Learning Value

- Algorithmic fairness — HIGH
- Fairness metrics — HIGH
- ML bias types — HIGH
- ML pipeline — MEDIUM
- Standard visualization types — LOW (already known)
- Shiny dashboard development — MEDIUM

## PART 10: Commercial Potential

- Open source — YES (highly visible area)
- R package — YES
- GitHub — YES
- Research paper — YES (at FAccT/AIES, not VIS)
- Startup — UNLIKELY (too many competitors)
- Consulting — POSSIBLE (bias audit services)

**Committee verdict on BiasVis: REJECT for VIS.** Not a visualization contribution. The visualizations are all standard types. The contribution is a software tool for fairness analysis. The student should submit this to FAccT, not VIS.

---

# PROJECT 4: ggdistinct — Uncertainty Grammar Extension for ggplot2

## PART 1: Research Novelty

**Claimed novelty:** First-class uncertainty aesthetic mappings in ggplot2 grammar; `geom_uncertainty()` as unified geometry; `stat_uncertainty()` for automatic uncertainty computation.

**Is the claim actually novel?** The idea is theoretically grounded and the literature explicitly calls for it ("Uncertainty needs to be formalised within the grammar of graphics" — The Noisy Work, 2024). However, a careful reading of the literature reveals that **Vega-Lite already has rudimentary error encoding** (error bars, error bands) as first-class marks. The proposed grammar extension is **novel for ggplot2** but not novel for visualization grammars in general.

**Closest existing systems:**
- **ggdist** (Kay, 2023) — provides distribution geoms (stat_slab, stat_dotinterval, stat_interval) but does not integrate uncertainty as a grammar-level aesthetic
- **tidybayes** (Kay, 2023) — Bayesian posterior visualization, paired with ggdist
- **Vega-Lite** — has error marks (errorbar, errorband) as first-class encodings
- **ggplot2** — no native uncertainty aesthetic
- **Plotly** — has error bars as trace attribute

**Which papers already solve part of the problem?**
- Wilkinson's "Grammar of Graphics" (2005) — foundation
- Wickham's "ggplot2" (2016) — Layered Grammar of Graphics
- Kay et al. — ggdist, distribution visualization
- The Noisy Work (2024) — calls for uncertainty in grammar
- Vega-Lite (Satyanarayan et al., 2017) — declarative grammar with some error encoding

**Incremental parts:**
- `geom_uncertainty()` — combines existing ggdist geoms under a unified interface
- `stat_uncertainty()` — convenience wrapper for existing uncertainty computation
- Theme elements for uncertainty legends — standard ggplot2 theme extension
- Automatic visual encoding selection — simple decision tree based on uncertainty_type

**Genuinely new parts:**
- **Uncertainty as a first-class aesthetic** — `aes(uncertainty = var, uncertainty_type = "confidence")` is a grammar-level innovation that changes how users think about uncertainty in ggplot2
- **Grammar-level mapping of uncertainty types to visual channels** — a lookup table that maps uncertainty_type (confidence, prediction, fuzziness, ambiguity) to appropriate encodings (gradient transparency, waviness, animation)

**Novelty assessment:** MODERATE-HIGH. The grammar-level innovation is genuine, and the R community would benefit. However, the theoretical novelty is limited: Vega-Lite already has some of this, and the uncertainty-to-encoding mapping is a design decision, not a fundamental contribution.

## PART 2: Research Risk

| Risk | Severity | Explanation |
|------|----------|-------------|
| ggdist overlap | HIGH | ggdist already provides excellent uncertainty visualization. Users may not see the value of a grammar-level abstraction. Many will say "just use ggdist." |
| Grammar design quality | HIGH | A poorly designed grammar extension will be ignored by the R community. The aesthetic mappings must be intuitive, composable, and backward-compatible. |
| ggplot2 extension complexity | HIGH | ggplot2's ggproto system is notoriously complex. Building a correct, robust extension requires deep understanding of ggplot2 internals. |
| Adoption barrier | MEDIUM | Even if technically sound, the package may not gain adoption if it conflicts with established workflows (ggdist). |
| Uncertainty type mapping | MEDIUM | The mapping from uncertainty type to visual encoding must be principled, not arbitrary. Requires literature grounding. |
| Performance | MEDIUM | Computing uncertainty on the fly (stat_uncertainty) for large datasets may be slow. |

**Overall risk:** MEDIUM. The main risk is that the project fails to provide sufficient added value over ggdist, resulting in a package that nobody uses.

## PART 3: Implementation Review (16 Weeks)

| Weeks | Tasks | Effort |
|-------|-------|--------|
| 1 | Literature review: grammar of graphics, uncertainty types, existing packages | Low |
| 2–3 | Design the grammar extension (which aesthetics, which encodings, API) | HIGH — design is critical |
| 4–6 | Implement ggproto extension: new aesthetics, default encoding mappings | HIGH — bottleneck |
| 7–8 | Implement geom_uncertainty() with multiple encoding types | HIGH — bottleneck |
| 9–10 | Implement stat_uncertainty() for automatic computation | Medium |
| 11 | Implement theme elements, legends | Medium |
| 12 | Write vignettes, examples, package infrastructure | Medium |
| 13–14 | Test with 3+ datasets, compare with ggdist | Medium |
| 15 | User feedback / expert review | Medium |
| 16 | Writing + CRAN submission preparation | Medium |

**Bottlenecks:**
1. **ggproto internals** — extending ggplot2 at the aesthetic and geom level requires understanding ggproto, the training scale system, and the rendering pipeline. This is genuinely difficult and poorly documented. Expect 2–3 weeks of debugging.
2. **API design** — bad API decisions at week 2 will haunt the entire project. The uncertainty grammar must be composable with existing ggplot2 syntax.
3. **Encoder mapping** — for each uncertainty type, the visual encoding must be perceptually appropriate. This requires literature grounding (MacEachren, 1995; Kinkeldey et al., 2017).

**Feasibility:** MODERATE. Doable but the ggproto learning curve is steep. The student should already be proficient with ggplot2.

## PART 4: Visualization Contribution

**Is the visualization actually the contribution?** YES — this is the **purest visualization contribution** among the top 5.

The contribution is:
- A **grammar-level abstraction** for uncertainty — this is a visualization theory contribution
- A **systematic mapping** from uncertainty types to visual channels — this is a visualization design contribution
- A **working implementation** that makes uncertainty visualization accessible — this is a tools contribution

Unlike the other projects, the visualization (not the data processing, not the ML, not the ethics) is central. The student is contributing to the *grammar of graphics* and *visual encoding design*, which are core visualization research topics.

## PART 5: R Suitability

**Can R implement this?** 100%

**What works in R:**
- Everything. This is an R-first project by design. ggplot2 is an R package.
- ggdist, tidybayes — reference implementations
- scales, grid — low-level graphics
- testthat, devtools, roxygen2 — package infrastructure

**Where R becomes limiting:**
- Nowhere significant. The project is designed for R.
- The grid graphics system is flexible enough for uncertainty-themed geoms.
- Performance is adequate for the target use cases (10K–100K observations).

**Required packages:** ggplot2, ggdist (reference), scales, grid, testthat, devtools, roxygen2, vdiffr (visual regression testing).

## PART 6: Publication Review

**Target:** IEEE VIS, EuroVis, TVCG

**Reviewer verdict:** *"Interesting contribution. The grammar-level innovation is genuine. Accept as a short paper."*

**Reviewer comments would likely include:**
- "The uncertainty aesthetic abstraction is well-motivated and the mapping from uncertainty types to visual channels is grounded in the perception literature."
- "The package fills a clear gap in the R ecosystem and is technically well-implemented."
- "However, I am concerned that the added value over ggdist is modest. The paper should demonstrate that the grammar-level abstraction enables uncertainty visualizations that are not possible or not easy with ggdist alone."
- "The visualization theory contribution is limited: the grammar extension is an engineering contribution, not a perceptual discovery."
- "The paper should position itself as a 'design study' or 'tool paper' rather than a fundamental visualization research contribution."

**Best outcome:** EuroVis Short Paper or VIS Poster. **R Journal** is also a strong venue. A VIS Full Paper is unlikely due to the limited theoretical novelty.

## PART 7: Minimum Publishable Unit

The MPU is straightforward:
1. **One uncertainty aesthetic** (uncertainty + uncertainty_type)
2. **Three encoding types** (gradient transparency, waviness, animated HOPs)
3. **One dataset** for demonstration
4. **Expert review** (not full user study)
5. **No stat_uncertainty** (users provide uncertainty directly)

This reduces the project to 6–8 weeks and preserves the core grammar contribution.

## PART 8: Evaluation Plan

**Design:** Expert review + comparative vignettes.

**Tasks:**
1. Implement the same uncertainty visualization using ggdist and ggdistinct
2. Compare code length, readability, and flexibility
3. Expert review by 3–5 R visualization experts (not a formal user study)

**Metrics:**
- Lines of code to produce equivalent visualizations
- Number of different uncertainty visualizations achievable
- Expert ratings of API quality (Likert: intuitive, composable, discoverable)

**Statistical tests:** None. Qualitative analysis only.

**Success criteria:** ggdistinct enables uncertainty visualizations in fewer lines and more flexibility than ggdist + manual encoding.

**Committee note:** This evaluation plan is appropriate for a tool/design paper. No IRB needed for expert review.

## PART 9: Learning Value

- Grammar of Graphics theory — VERY HIGH
- ggplot2 internals (ggproto) — VERY HIGH
- R package development — VERY HIGH
- Uncertainty visualization taxonomy — HIGH
- Visual encoding theory — HIGH
- Visual perception of uncertainty — MEDIUM
- API design — HIGH

This is the **best learning project**. The student learns visualization theory, R internals, and package development simultaneously.

## PART 10: Commercial Potential

- R package on CRAN — VERY HIGH (ggdistinct could become a standard ggplot2 extension)
- GitHub project — VERY HIGH
- Research paper — GOOD (R Journal, EuroVis Short)
- Patent — NO
- Startup — NO
- Commercial software — NO (but widely used in academia/industry)

**Committee verdict on ggdistinct: CONSIDER.** Strong visualization contribution, feasible timeline, genuine novelty. The main concern is whether the added value over ggdist is sufficient.

---

# PROJECT 5: CogNet — Cognitive Load-Adaptive Dynamic Network Animation

## PART 1: Research Novelty

**Claimed novelty:** Cognitive load estimation via interaction proxies; adaptive animation speed based on cognitive load; adaptive transition complexity; cognitive load heatmap.

**Is the claim actually novel?** The gap is explicit (Filipov et al., 2023: "investigating cognitive load when watching animations is an open challenge"). The concept of adapting visualization to user cognitive state is genuinely new and has not been implemented for dynamic networks.

**Closest existing systems:**
- **Gephi** — dynamic network animation but no adaptation
- **visNetwork** — R interactive network visualization, no adaptation
- **networkD3** — D3-based network, no adaptation
- **GGanimate** — animation but no cognitive load awareness
- **Adaptive interfaces in HCI** — general concept (Gajos et al., 2006) but not for network visualization

**Which papers already solve part of the problem?**
- Filipov et al. (2023) — identifies the gap
- Chen (2017) — cognitive load in visualization
- Gajos et al. (2006) — adaptive interfaces, but not for visualization
- NeuroAdapt (VIS 2024) — EEG-based adaptation for visualization (niche, not interaction proxy based)

**Incremental parts:**
- Mouse speed, zoom frequency, pause duration tracking — trivial Shiny/JavaScript events
- Animation speed control — gganimate already supports variable speed
- Opacity fades for high load — standard visual transition
- Highlight only changed nodes — standard network visualization technique

**Genuinely new parts:**
- **Cognitive load estimation from interaction proxies in network visualization** — never been done
- **Adaptive animation that slows down under high load** — novel application
- **Split attention mode that simplifies during high load** — novel adaptation strategy
- **Cognitive load heatmap timeline** — novel meta-visualization

**Novelty assessment:** HIGH. This is the most original idea among the top 5. The committee recognizes genuine novelty in the adaptive loop: interaction proxies → cognitive load estimation → animation parameter adaptation.

## PART 2: Research Risk

| Risk | Severity | Explanation |
|------|----------|-------------|
| Cognitive load proxy validity | VERY HIGH | Mouse speed, zoom frequency, and pause duration are **unvalidated proxies** for cognitive load. There is no evidence they correlate with actual cognitive load (measured by EEG, pupil dilation, or NASA-TLX). If the proxies are invalid, the entire system is built on a false premise. |
| Adaptive system evaluation | HIGH | "Does adaptation help?" requires comparing adaptive vs. non-adaptive animation. If adaptation does not improve performance, the project fails. If it does, the effect could be due to the proxy validity or the adaptation strategy. |
| Adaptation interference | HIGH | If the animation adapts (slows down) exactly when the user is struggling, the user may experience frustration ("the system is lagging"). The adaptation must feel natural, not obstructive. |
| Network animation complexity | MEDIUM | Dynamic network animation with smooth transitions is technically challenging. gganimate handles simple cases; complex graph transitions may not work smoothly. |
| Confounding variables | HIGH | User performance in dynamic network tasks depends on network density, change magnitude, prior knowledge, and task type. Isolating the cognitive load adaptation effect is extremely difficult. |
| R limitations for interaction | MEDIUM | Interaction proxy tracking requires JavaScript event listeners. Shiny + JavaScript bridges are possible but fragile. |
| No existing benchmark | HIGH | There is no baseline system for comparison. The student must build the non-adaptive version as the baseline, doubling the implementation effort. |

**Overall risk:** VERY HIGH. The cognitive load proxy validity is a fundamental scientific risk that cannot be mitigated within a 16-week student project.

## PART 3: Implementation Review (16 Weeks)

| Weeks | Tasks | Effort |
|-------|-------|--------|
| 1 | Literature review: cognitive load theory, adaptive interfaces, network animation | Low |
| 2–3 | Build dynamic network animation system (baseline, no adaptation) | HIGH — bottleneck |
| 4–5 | Implement interaction proxy tracking in Shiny/JS | Medium |
| 6–7 | Implement cognitive load estimation model (from proxy data) | VERY HIGH — bottleneck |
| 8–9 | Implement adaptive animation (speed, complexity, split attention) | HIGH |
| 10 | Implement cognitive load heatmap | Medium |
| 11–12 | Build non-adaptive baseline version (control condition) | Medium |
| 13–14 | User study design + IRB + recruitment + data collection | VERY HIGH — bottleneck |
| 15–16 | Analysis, writing | HIGH |

**Bottlenecks:**
1. **Cognitive load estimation model** — without a calibration study (comparing proxy data to ground-truth cognitive load), the estimation model is a guess. A calibration study requires simultaneously recording interaction proxies and validated cognitive load (NASA-TLX, eye tracking) — impossible in 16 weeks.
2. **Dynamic network animation** — building smooth, perceptually valid animated transitions for dynamic graphs in R is extremely difficult. gganimate was not designed for graph layout transitions. The student may need to implement custom animation code.
3. **User study** — 2 weeks for a within-subjects study with 20+ participants is unrealistic. Recruitment alone takes 1–2 weeks.
4. **Study design complexity** — factorial design (adaptive × non-adaptive) × (low × high cognitive load condition) requires careful task design.

**Feasibility:** NOT FEASIBLE in 16 weeks. The cognitive load proxy validation alone is a full research project.

## PART 4: Visualization Contribution

**Is the visualization actually the contribution?** PARTIALLY.

The visualization contribution is the adaptive animation system. However:
- The underlying network visualization (node-link diagram with animation) is standard
- The cognitive load heatmap is a simple timeline visualization
- The split attention mode is a filtering/emphasis technique

The **HCI/adaptive systems** contribution dominates: the novel part is *how the system adapts*, not *what the visualization looks like*. This is a **mixed-initiative interaction** project more than a visualization project.

**VIS venues may reject this** as "better suited for CHI or IUI." The visualization techniques themselves are standard; the adaptation algorithm is the contribution.

## PART 5: R Suitability

**Can R implement this?** 60%

**What works in R:**
- `igraph`, `tidygraph` — network analysis
- `ggraph` — network visualization
- `gganimate` — basic animation
- `shiny` + `shinyjs` — interaction platform
- `future`, `promises` — async (if needed)

**Where R becomes limiting:**
- **Real-time interaction proxy tracking** — requires JavaScript event listeners. Shiny's reactive system adds latency that may break real-time tracking.
- **Smooth graph layout animation** — gganimate interpolates between discrete states but graph layout interpolation (nodes moving smoothly between positions) requires custom implementation. R is not designed for this.
- **Cognitive load estimation** — R has no packages for real-time cognitive load modeling. The student must implement from scratch.
- **Performance** — animating graphs with >100 nodes in R is slow. Real-time adaptation at 30+ fps is impossible in R/Shiny.
- **EEG/eye-tracking integration** — if the student wants to validate the proxies, R cannot interface with these devices directly.

**Required packages:** igraph, tidygraph, ggraph, gganimate, shiny, shinyjs, future, promises, dplyr, tidyr.

## PART 6: Publication Review

**Target:** IEEE VIS, EuroVis, TVCG

**Reviewer verdict:** *"Interesting idea but the cognitive load proxy validity is not established. Major revision or reject."*

**Reviewer comments would likely include:**
- "The paper makes a strong assumption that mouse speed, zoom frequency, and pause duration correlate with cognitive load. No evidence is provided for this correlation."
- "Without a calibration study, the cognitive load estimation is a black box with unknown reliability."
- "The adaptive system evaluation does not control for novelty effects. Users may perform better simply because the system is interactive, not because adaptation is effective."
- "The visualization techniques are standard. The contribution is in the adaptive interaction, which is better suited for CHI or IUI."
- "The implementation in R is slow and does not achieve the frame rates needed for smooth adaptation."

**Best outcome:** CHI Late-Breaking Work or IUI Demo. Unlikely at VIS without significant cognitive load validation.

## PART 7: Minimum Publishable Unit

Cut to:
1. **No cognitive load estimation** — replace with explicit user control ("choose animation speed")
2. **No adaptive system** — focus on the interaction proxy tracking as a visualization analytics tool
3. **Cognitive load heatmap only** — show mouse activity as a timeline overlay
4. **One network dataset** (ENRON)

The MPU becomes: "Visualizing interaction proxies during dynamic network exploration." This is a different project — an **analytics tool for understanding how users explore dynamic networks**. This is feasible and novel, but it is not the original project.

## PART 8: Evaluation Plan

**Design:** Within-subjects: adaptive vs. non-adaptive animation.

**Tasks:**
1. For each task, identify changes in the network (node additions, deletions, edge changes)
2. Answer comprehension questions about network structure

**Metrics:** Task accuracy, completion time, NASA-TLX, preference.

**Committee note:** The evaluation will likely show:
- If the proxies are invalid: no difference between conditions → project fails
- If the proxies are valid: adaptation helps → but the effect is confounded with the interaction itself
- The most likely outcome: mixed results that are difficult to interpret

## PART 9: Learning Value

- Cognitive load theory — VERY HIGH
- Dynamic network visualization — HIGH
- Animation design — HIGH
- User modeling — VERY HIGH
- Adaptive systems — HIGH
- Shiny/JavaScript integration — MEDIUM
- User study design — HIGH (but rushed)

## PART 10: Commercial Potential

- R package — UNLIKELY (too specialized)
- GitHub — YES (as research prototype)
- Research paper — MARGINAL (depends on validation)
- Patent — POSSIBLE (adaptive animation concept)
- Startup — NO
- Commercial — NO

**Committee verdict on CogNet: REJECT.** High risk of cognitive load proxy invalidity. Insufficient visualization contribution (more HCI than VIS). Not feasible in 16 weeks. The idea is interesting but requires years of validation, not 16 weeks.

---

# FINAL COMPARISON TABLE

| Dimension | TrustDR (P7) | UAVA-R (P3) | BiasVis (P12) | ggdistinct (P1) | CogNet (P4) |
|-----------|:---:|:---:|:---:|:---:|:---:|
| **Novelty** | Mod | Low | Mod-High | Mod-High | High |
| **Research Strength** | Mod | Low | Mod | Mod | Low |
| **Visualization Contribution** | Mod | None | None | **High** | Low-High |
| **Difficulty** | Mod | V.High | Mod | Mod-High | V.High |
| **Risk** | Mod-High | V.High | Mod | Med | **V.High** |
| **R Compatibility** | 90% | 50% | 85% | **100%** | 60% |
| **Publication Chance (VIS)** | Low | None | None | **Moderate** | None |
| **Portfolio Value** | High | High | High | **Very High** | Very High |
| **Commercial Value** | Low | None | Low | **Moderate** | Low |
| **Learning Value** | High | V.High | High | **V.High** | V.High |
| **Impl. Time (weeks)** | 12–14 | **Not feasible** | 10–12 | **8–10** | **Not feasible** |
| **Feasible in 16 weeks?** | Marginal | **No** | Yes | **Yes** | **No** |

---

# FINAL DECISION

## Recommended Project: ggdistinct — Uncertainty Grammar Extension for ggplot2

### Rationale

After rigorous evaluation, the committee selects **ggdistinct** (Project 1) as the only project that satisfies all critical requirements:

1. **Visualization Contribution (CORE):** ggdistinct is the **only project** where the visualization is the primary contribution. The grammar-level uncertainty abstraction, the systematic mapping of uncertainty types to visual channels, and the R package implementation are all visualization research. In contrast:
   - TrustDR: visualization is secondary to quality metrics
   - UAVA-R: visualization is secondary to error propagation math
   - BiasVis: visualization is secondary to ethics/analytics
   - CogNet: visualization is secondary to adaptive HCI

2. **Feasibility:** At 8–10 weeks, ggdistinct is the **most feasible** project. TrustDR (12–14) is marginal. UAVA-R and CogNet are **not feasible** in 16 weeks.

3. **R Compatibility:** 100%. This is an R-native project. Other projects require Python integration (UAVA-R), JavaScript proxies (CogNet), or heavy ML infrastructure (BiasVis).

4. **Academic Strength:** The grammar of graphics extension is a **legitimate visualization theory contribution**. It contributes to a research conversation (grammar of graphics, uncertainty formalization) rather than building a one-off dashboard.

5. **Learning Value:** The student learns ggplot2 internals, R package development, grammar of graphics theory, and uncertainty visualization — all transferable skills.

6. **Future Extensibility:** ggdistinct can grow into a widely-used R package with CRAN publication, community contributions, and integration with the R ecosystem (brms, rstanarm, tidybayes).

### Why Every Other Project Lost

**TrustDR (P7) — Lost because:**
- The per-point glyphs may not outperform simple color encoding. A VIS reviewer will ask: "Is this better than coloring by quality?" Without a user study (which the timeline does not allow), we cannot answer.
- The project is a "visual design study" with a weak theoretical contribution. The quality metrics are pre-existing.
- Publication ceiling is EuroVis Short / VIS Poster — not a strong PhD output.

**UAVA-R (P3) — Lost because:**
- The visualization contribution is nearly zero. Sankey diagrams, distribution plots, and what-if sliders are standard.
- The uncertainty propagation engine is a full research project on its own — impossible in 16 weeks.
- Mathematical complexity is beyond a typical final-year student.
- Rejected at VIS as "already exists."

**BiasVis (P12) — Lost because:**
- Not a visualization project. All visualizations are standard chart types.
- Belongs at FAccT/AIES, not VIS. The committee is evaluating for VIS publication.
- Google What-If Tool and IBM AIF360 already provide similar functionality with better UX.
- The student would learn more about fairness metrics than visualization design.

**CogNet (P4) — Lost because:**
- The cognitive load proxy validity is untestable in 16 weeks. If the proxies are invalid, the entire system fails.
- More HCI/adaptive systems than visualization. CHI/IUI would be more appropriate venues.
- Not feasible in R. Real-time adaptation with interaction proxy tracking requires JavaScript/TypeScript.
- The project is too ambitious and underspecified. The "how" of cognitive load estimation is not answered.

### Committee Statement

The committee emphasizes that the purpose of a PhD thesis in visualization is to **advance visualization knowledge** — not to build dashboards, not to compute fairness metrics, and not to validate HCI adaptation theories. ggdistinct advances visualization knowledge by formalizing uncertainty within the grammar of graphics, contributing a new R package, and providing a systematic encoding of uncertainty types to visual channels. It is the only project that a VIS review committee would accept.

**The other projects are not bad — they are simply not VIS projects.** They would be appropriate for other venues (FAccT, CHI, IUI, statistics journals) but do not meet the visualization contribution threshold for a VIS thesis.

## Final Verdict

**Accept: ggdistinct (P1)**

**Reject: TrustDR (P7), UAVA-R (P3), BiasVis (P12), CogNet (P4)**

---

*Committee deliberation complete. Report prepared July 29, 2026.*
