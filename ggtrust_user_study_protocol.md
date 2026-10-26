# User Study Protocol: Visualizing Point Reliability in Dimensionality Reduction Scatterplots

**Target encodings:** Halos vs. Landscape vs. Stacked (Halos + Landscape combined)
**Baseline:** Standard scatterplot (no fidelity encoding)
**Study type:** Controlled within-subjects experiment
**IRB requirement:** Exempt (no vulnerable populations, no deception, anonymous data)
**Preregistration:** OSF (before data collection)

---

## 1. Research Questions (from the project proposal)

| RQ | Question | How addressed |
|----|----------|---------------|
| RQ1 | What visual encoding optimally communicates per-point spatialization fidelity in DR scatterplots, resolving the paradox that low-fidelity points require both visual de-emphasis (to signal untrustworthiness) and visual emphasis (to flag them for attention)? | Compare Halo vs. Landscape vs. Stacked on region assessment, point flagging, and cluster reality judgment; the Halo mark resolves the paradox via extent ∝ 1 − fidelity (flagging) and opacity ∝ fidelity (assessment) |
| RQ2 | Can spatialization fidelity be formalized in the Grammar of Graphics (as `aes(reliability = ...)` in v1)? | Implemented in the ggtrust R package; the study evaluates the resulting visual outcomes, not the grammar API itself |
| RQ3 | Does explicit visual encoding of spatialization fidelity improve users' ability to correctly interpret cluster structure, identify unreliable points, and assess projection quality compared to standard scatterplots? | Within-subjects comparison of all four conditions (Baseline, Halo, Landscape, Stacked) across three task types |

**Secondary RQs:**
- RQ-a: Which encoding best supports assessment of overall projection quality? (Landscape vs. Halo vs. Stacked)
- RQ-b: Which encoding best supports flagging individual unreliable points? (Halo vs. Stacked; Landscape expected to fail)
- RQ-c: Does combining the two encodings (Stacked) preserve the strengths of both without unacceptable visual clutter or response-time cost?
- RQ-d: Do the encodings improve trust calibration (agreement between confidence and accuracy)?

---

## 2. Study Design

### 2.1 Design Summary

| Factor | Levels | Type |
|--------|--------|------|
| Encoding (within) | Baseline, Halo, Landscape, Stacked | Fixed |
| Task type (within) | Assessment, Flagging, Interpretation | Fixed |
| Dataset (within) | Iris-tSNE, MNIST-UMAP, Wine-PCA | Random |
| Trial repetition | 4 trials per (encoding × task × dataset) | Fixed |

**Total trials per participant:** 4 encodings × 3 tasks × 3 datasets × 4 repetitions = **144 trials**

**Expected duration:** 45-60 minutes (including training, breaks, post-study questionnaire)

### 2.2 Condition Counterbalancing

Latin square across 4 encoding conditions to control for learning effects:

| Group | Order |
|-------|-------|
| G1 | Baseline → Halo → Landscape → Stacked |
| G2 | Halo → Landscape → Stacked → Baseline |
| G3 | Landscape → Stacked → Baseline → Halo |
| G4 | Stacked → Baseline → Halo → Landscape |

24 participants → 6 per group, ensuring each encoding appears equally often in each position.

### 2.3 Stimuli Construction

Each stimulus is a scatterplot of a DR projection with known per-point fidelity scores. The ground-truth fidelity is computed from trustworthiness T(k,i) and continuity C(k,i) combined as f_i = min(T_i, C_i) (worst-case preservation, per the ggtrust theoretical framework; `stat_trust_dr` computes this directly).

**Dataset characteristics:**

| Dataset | n | DR method | Known structure | Fidelity range |
|---------|---|-----------|-----------------|----------------|
| Iris | 150 | t-SNE (perp=30) | 3 ground-truth clusters, one separable | 0.55-0.98 |
| MNIST-500 | 500 | UMAP (n_neighbors=15) | 10 digit classes; some confusable pairs | 0.30-0.95 |
| Wine Quality | 200 | PCA (2 components) | Continuous quality score; no natural clusters | 0.60-0.92 |

Fidelity values are categorized into three ground-truth levels for scoring: **Low** (<0.6), **Medium** (0.6-0.85), **High** (>0.85).

**Encoding definitions (all rendered from the ggtrust R package to PNG):**

| Condition | Definition |
|-----------|------------|
| Baseline | Plain scatterplot: points at DR coordinates, single blue hue, no fidelity encoding |
| Halo | `geom_trust_halo()`: concentric Gaussian rings per point; extent ∝ 1 − fidelity (flagging), opacity ∝ fidelity (assessment) |
| Landscape | `geom_trust_landscape()`: GAM-smoothed reliability surface as semitransparent raster with contour lines; region-level gist |
| Stacked | `geom_trust_halo()` + `geom_trust_landscape()` overlaid: landscape provides region gist; halos provide per-point flagging |

**Stimuli parameters (held constant):**
- Plot dimensions: 800 × 600 px
- Point size: 5px radius (baseline)
- Color: Single hue (blue) for points; viridis colormap for the landscape surface
- Background: White
- Axis labels: None (participants only see point positions)
- Halo max radius: 15px (R_max)
- Landscape: `grid_size = 100`, `smoothing = "gam"`, viridis colormap, 5 contour bins
- Stacked: both halos and landscape, using the same parameterization as the single encodings

---

## 3. Hypotheses

### 3.1 Primary Hypotheses (accuracy)

| H | Statement | Derived from |
|---|-----------|--------------|
| **H1** | All fidelity encodings (Halo, Landscape, Stacked) yield higher accuracy than Baseline on Assessment and Interpretation tasks. | Munzner idiom suitability; the defining claim of the project (RQ3) |
| **H2** | Halo yields higher accuracy than Landscape on Flagging tasks. | Paradox resolution: halos provide per-point flagging via extent; landscape lacks per-point specificity |
| **H3** | Landscape yields higher accuracy than Halo on region-level Assessment tasks. | Position is the highest-ranked channel; landscape supports gestalt region perception |
| **H4** | Stacked yields accuracy ≥ the best single encoding on both Assessment and Flagging tasks. | Combining encodings should capture the strengths of each (region gist + per-point flagging) |
| **H5** | Stacked does not incur a meaningful response-time cost relative to the better single encoding per task. | Overplotting risk from combining halos + landscape is controlled at n ≤ 500 |

### 3.2 Secondary Hypotheses (time, calibration, preference)

| H | Statement |
|---|-----------|
| **H6** | Response time differs across encodings such that Landscape is fastest on Assessment and Halo/Stacked are fastest on Flagging; Baseline is slowest overall. |
| **H7** | Trust calibration (|confidence − accuracy|) is better for all fidelity encodings than Baseline. |
| **H8** | Participants rank Landscape/Stacked most preferred for Assessment tasks and Halo/Stacked most preferred for Flagging tasks. |
| **H9** | SUS scores for all three fidelity encodings exceed the industry average of 68. |

---

## 4. Tasks

### 4.1 Task Type A: Region Assessment (assessing overall fidelity)

**Stimulus:** Scatterplot with a marked circular region (highlighted boundary, ~15% of plot area).

**Trial structure:**
1. Fixation cross (500ms)
2. Stimulus visible (until response)
3. Question: "Rate the overall reliability of points in the highlighted region."
4. Response: 5-point Likert (Very Low / Low / Medium / High / Very High)
5. Confidence: "How confident are you?" (1-5)
6. Inter-trial interval (1000ms)

**Ground truth:** Mean fidelity of points within the region, categorized into the same 5 levels.

**Justification:** Tests assessment-mode perception — can the user extract gist fidelity from a region? Primary task for Landscape (H3) but also tests Halo and Stacked.

**Number of trials:** 4 encodings × 3 datasets × 4 regions × 1 repetition = 48 trials

### 4.2 Task Type B: Point Flagging (identifying unreliable points)

**Stimulus:** Scatterplot with three points marked (A, B, C labels).

**Trial structure:**
1. Fixation (500ms)
2. Stimulus (until response)
3. Question: "Which point (A, B, or C) has the LEAST reliable position?"
4. Response: forced-choice (A/B/C)
5. Confidence: 1-5
6. ITI: 1000ms

**Ground truth:** The point with the lowest computed fidelity score.

**Justification:** Tests per-point discrimination — can the user identify the single least reliable point? Halo's flagging mechanism (H2) and Stacked should excel; Landscape should fail (no per-point information).

**Number of trials:** 4 encodings × 3 datasets × 4 triples × 1 repetition = 48 trials

### 4.3 Task Type C: Structural Interpretation (cluster reality judgment)

**Stimulus:** Scatterplot with two clusters highlighted (A and B).

**Trial structure:**
1. Fixation (500ms)
2. Stimulus (until response)
3. Question: "Cluster A appears separated from the main cloud. Is this separation real (reflects actual data structure) or an artifact (a projection distortion)?"
4. Response: 2AFC (Real / Artifact)
5. Confidence: 1-5
6. ITI: 1000ms

**Ground truth:** Determined by examining whether the corresponding high-D points form a genuine cluster (via silhouette score on original data) or are a projection artifact.

**Justification:** Tests the most ecologically valid use case — the "Stop Misusing t-SNE" scenario where users must judge whether a visual cluster is real.

**Number of trials:** 4 encodings × 3 datasets × 4 cluster pairs × 1 repetition = 48 trials

**Total per participant:** 144 trials

---

## 5. Procedure

### Phase 1: Consent & Demographics (5 min)
- Informed consent
- Demographics (age, education, visualization experience, DR familiarity, color blindness screen via Ishihara)
- Training vignette reads: "DR projections can distort distances. Some points reliably preserve their true relationships; others do not. The fidelity encoding tells you which points you can trust."

### Phase 2: Encoding Training (3 min per encoding = 12 min)
For each encoding condition, participants see:
1. A static legend explaining the encoding (e.g., "Small, opaque halo = high reliability; large, transparent halo = low reliability")
2. An annotated example with 5 points spanning the fidelity range
3. 3 practice trials with feedback

Order matches the participant's assigned Latin square group.

### Phase 3: Main Task Blocks (4 encodings × 3 blocks × 4 min ≈ 36 min)
Each encoding block contains 36 trials (3 datasets × 3 task types × 4 repetitions), interleaved by task type in randomized order within block. A 30-second break between blocks.

### Phase 4: Post-Study Questionnaire (5 min)
- For each encoding: "Rate how intuitive the encoding was" (1-5)
- For each encoding: "Rate how much you trusted the encoding" (1-5)
- Rank the encodings: "Which would you prefer for [assessment/flagging/interpretation]?"
- SUS questionnaire (10 items)
- Free-text: "What did you find confusing? Any strategies you used?"

### Phase 5: Debrief (2 min)
- Explanation of study purpose
- Opportunity to withdraw data

**Total:** ~60 min

---

## 6. Measures

### 6.1 Dependent Variables

| Variable | Type | Scale | Collection |
|----------|------|-------|------------|
| Accuracy | Binary per trial | 0/1 (correct/incorrect) | Automated logging |
| Response time | Continuous | ms (from stimulus onset to response) | Automated logging |
| Confidence | Ordinal per trial | 1-5 Likert | Per-trial prompt |
| Trust calibration | Continuous | abs(confidence_z − accuracy_z) | Computed post-hoc |
| Encoding intuition | Ordinal | 1-5 Likert | Post-study |
| Encoding trust | Ordinal | 1-5 Likert | Post-study |
| Encoding ranking | Ordinal | 1/2/3/4 per task type | Post-study |
| SUS score | Continuous | 0-100 | Post-study |

### 6.2 Controlled Variables (held constant)

| Variable | Value | Rationale |
|----------|-------|-----------|
| Point count | 150-500 | Within scalable range for all encodings (ggtrust renders Halo ≤500 fast; benchmarks: halo 1.7s @ n=500, landscape 0.65s) |
| Screen size | Min 13" | Standard laptop/tablet |
| Viewing distance | Self-regulated (online) | Ecological validity |
| Color scheme | Blue points, viridis colormap | Perceptually uniform, colorblind-safe |
| Max halo radius | 15px | Prevents excessive overlap at 500 points |
| Trial timeout | 15s | Prevents excessive deliberation |

---

## 7. Statistical Analysis Plan

### 7.1 Primary Analysis

**Model:** Repeated-measures ANOVA with factors: Encoding (4) × Task Type (3) × Dataset (3).

**Response variable:** Accuracy (arcsine-transformed proportion correct per participant per condition).

**Rationale:** Within-subjects design, fully crossed, balanced. Repeated-measures ANOVA accounts for participant-level variance.

**Assumption checks:** Mauchly's test of sphericity. If violated, use Greenhouse-Geisser correction.

### 7.2 Post-hoc Comparisons

For significant main effects (α = 0.05), perform Holm-corrected pairwise t-tests:

| Comparison | Motivation |
|------------|------------|
| Each encoding vs. Baseline | Does encoding help? (H1) |
| Halo vs. Landscape on Flagging tasks | Paradox resolution (H2) |
| Landscape vs. Halo on Assessment tasks | Region gist (H3) |
| Stacked vs. Halo on Flagging; Stacked vs. Landscape on Assessment | Does combining help? (H4) |

### 7.3 Effect Sizes

Report for each pairwise comparison:
- Cohen's d (within-subjects, adjusted for correlation: d_z)
- Partial η² for ANOVA effects
- 95% confidence intervals for all estimates

### 7.4 Secondary Analyses

**Response time:** Log-transformed RT analyzed with same RM-ANOVA model. Exclude incorrect trials and trials > 3 SD from participant mean. H5/H6 tested here.

**Trust calibration:** For each encoding, compute Pearson r between confidence and accuracy across trials per participant. Compare r values across encodings via Fisher's z-transformed RM-ANOVA (H7).

**Subjective ratings:** Friedman test (non-parametric, ordinal data) for preference rankings across encodings, with post-hoc Wilcoxon signed-rank tests (H8).

**Learning effects:** For each encoding, compare first 6 trials vs. last 6 trials via paired t-test within each encoding.

### 7.5 Sample Size Justification

**Power analysis:** For a within-subjects RM-ANOVA with 4 conditions, α = 0.05, power = 0.80, and a medium effect (f = 0.25, partial η² = 0.06):
- Required n = 24 (calculated via G*Power, correlation among repeated measures = 0.5)

24 participants × 4 groups = 6 per Latin square order.

### 7.6 Handling Missing Data

- Trials exceeding 15s timeout: excluded (<2% expected)
- Entire participants excluded if accuracy < 50% on baseline condition (suggesting non-compliance or misunderstanding)
- Target: n=24 after exclusions; recruit n=28 to allow for 15% attrition

---

## 8. Participant Recruitment

| Parameter | Specification |
|-----------|---------------|
| Population | Graduate students and researchers in data science, HCI, or visualization |
| n | 24 (recruit 28) |
| Recruitment | University mailing lists, Prolific Academic (filtered: data science background), Slack communities |
| Compensation | $15 (Prolific) or course credit (university) |
| Inclusion criteria | Normal or corrected-to-normal vision; passed Ishihara color blindness screen; no prior exposure to the ggtrust package |
| Exclusion criteria | Self-reported color blindness; prior participation in pilot |
| Location | Online (Prolific or custom web app) with screen size validation |
| Language | English (all materials in English) |

**Pilot phase:** 3 participants from the target population to validate:
- Trial timing (is 15s timeout appropriate?)
- Task difficulty (is baseline accuracy > chance but < ceiling?)
- Instruction clarity (are the encodings understandable?)
- Technical setup (does the rendering work in browsers?)

---

## 9. Implementation: Trial Web App

A lightweight HTML/JS experiment framework (not Shiny — too slow for trial-by-trial logging). All stimuli are **pre-rendered to PNG from the ggtrust R package** to ensure consistent appearance across browsers and eliminate rendering latency.

```
/experiment
├── index.html             # Experiment entry, consent
├── js/
│   ├── experiment.js      # Trial controller, randomization, logging
│   ├── stimuli.js         # Stimulus display (pre-rendered PNGs)
│   └── utils.js           # Data loading, CSV export
├── stimuli/               # Pre-rendered PNG files + metadata
│   ├── iris_tsne/
│   │   ├── baseline/*.png
│   │   ├── halo/*.png
│   │   ├── landscape/*.png
│   │   └── stacked/*.png
│   ├── mnist_umap/...
│   └── wine_pca/...
└── data/                  # Output directory for trial logs (.csv)
```

**Rendering approach:** `stimuli/generate_stimuli.R` (in the ggtrust repo) renders every stimulus PNG using ggplot2 + ggtrust, with fidelity computed via `stat_trust_dr(original_data = ...)`. The four conditions differ only in the geom/layer composition:

| Condition | ggtrust layers |
|-----------|----------------|
| Baseline | `geom_point()` only |
| Halo | `geom_trust_halo()` |
| Landscape | `geom_trust_landscape()` + `geom_point()` |
| Stacked | `geom_trust_landscape()` + `geom_trust_halo()` + `geom_point()` |

**Data logged per trial:**
- participant_id, group, encoding, task_type, dataset, trial_index
- stimulus_filename, correct_answer, participant_response
- accuracy (0/1), response_time_ms, confidence
- timestamp, screen_width, screen_height

---

## 10. Expected Results (Simulated Predictions)

### 10.1 Predicted Accuracy Patterns

| Encoding | Assessment | Flagging | Interpretation | Overall |
|----------|:----------:|:--------:|:--------------:|:-------:|
| Baseline | 62% | 55% | 58% | 58% |
| Halo | 78% | **82%** | 76% | 79% |
| Landscape | **82%** | 58% | **78%** | 73% |
| Stacked | **84%** | **80%** | **80%** | **81%** |

**Predicted patterns:**
- H1 ✓: All fidelity encodings > Baseline on Assessment (min 78% vs. 62%) and Interpretation (min 76% vs. 58%)
- H2 ✓: Halo (82%) >> Landscape (58%) on Flagging
- H3 ✓: Landscape (82%) > Halo (78%) on Assessment
- H4 ✓: Stacked ≥ best single encoding on both Assessment (84% ≥ 82%) and Flagging (80% ≈ 82%)
- H5 ✓: Stacked response time within one SD of the better single encoding per task (no substantial clutter penalty)

### 10.2 Predicted Response Times

| Encoding | Assessment RT (ms) | Flagging RT (ms) |
|----------|:------------------:|:----------------:|
| Baseline | 4200 | 4800 |
| Halo | 3800 | 3900 |
| Landscape | 3500 | 4500 |
| Stacked | 3700 | 4000 |

### 10.3 Predicted Preference Rankings

| Task | Top-ranked encoding |
|------|:-------------------:|
| Assessment | Landscape/Stacked |
| Flagging | Halo/Stacked |
| Overall | Stacked (high overall) |

---

## 11. Threats to Validity

### 11.1 Internal Validity

| Threat | Severity | Mitigation |
|--------|----------|------------|
| **Learning effects** (participants improve across blocks) | Medium | Latin square counterbalancing; analyze first-block accuracy separately |
| **Carryover effects** (seeing one encoding biases perception of next) | Medium | Latin square; include washout trials (5 baseline trials) at block transitions; debrief to check for strategies |
| **Task learning** (participants learn the task, not the encoding) | High | Randomize dataset and trial order within blocks; use 3 different datasets to prevent memorization |
| **Demand characteristics** (participants guess the hypothesis) | Low | Cover story: "evaluating visual designs for high-dimensional data"; no mention of which encoding is predicted to be best |
| **Technical failures** (browser rendering inconsistencies) | Medium | Pre-render all stimuli to PNG — identical appearance across all systems |
| **Fatigue** (144 trials is demanding) | Medium | 30s breaks between each block; total time 60 min; monitor RT increase in last quartile |
| **Ceiling/floor effects** | Medium | Pilot data will calibrate task difficulty |

### 11.2 External Validity

| Threat | Severity | Mitigation |
|--------|----------|------------|
| **Artificial tasks** (region rating ≠ real DR analysis) | High | Task C (cluster reality judgment) is ecologically valid; include realistic DR scenarios in debrief |
| **Student sample** (not professional analysts) | Medium | Recruit data science graduate students — closest feasible proxy; note limitation in paper |
| **Single hue, no labels** (not realistic scatterplots) | Medium | Controlled experimental confound; limits generalization but necessary for internal validity |
| **Static images vs. interactive tool** | Medium | The experiment tests only static perception; interactive benefits (hover, threshold slider) are not evaluated |

### 11.3 Construct Validity

| Threat | Severity | Mitigation |
|--------|----------|------------|
| **Accuracy conflates encoding effectiveness with task difficulty** | Low | Each participant sees the same trials across all encodings (within-subjects) |
| **Response time may reflect encoding complexity, not comprehension** | Medium | Include accuracy as primary DV; RT is secondary |
| **Confidence ratings may not reflect true calibration** | Medium | Use incentive-compatible confidence elicitation (e.g., Brier score bonus) |

### 11.4 Statistical Validity

| Threat | Severity | Mitigation |
|--------|----------|------------|
| **Multiple comparisons** | Medium | Holm correction for post-hoc tests; report effect sizes |
| **Violation of sphericity** | Low | Greenhouse-Geisser correction for RM-ANOVA |
| **Low power for interaction effects** | Medium | n=24 powered for main effects; report effect sizes with CIs |
| **Non-normal residuals (accuracy is binary)** | Medium | Use arcsine transformation; confirm with logistic mixed-effects model as sensitivity analysis |

---

## 12. Analysis Pipeline (Pre-Registered)

```
analysis/
├── 01_preprocess.R          # Load trial logs, filter exclusions, compute derived variables
├── 02_descriptives.R        # Descriptive statistics (means, SDs, plots)
├── 03_accuracy_anova.R      # RM-ANOVA for accuracy
├── 04_pairwise_tests.R      # Holm-corrected post-hoc comparisons
├── 05_response_times.R      # Log-RT RM-ANOVA
├── 06_calibration.R         # Trust calibration analysis
├── 07_subjective.R          # Friedman test on rankings, SUS analysis
├── 08_learning_effects.R    # First vs. last trial comparison
├── 09_sensitivity.R         # Logistic mixed-effects model (validation)
├── 10_figures.R             # Publication-quality figures
└── materials/
    ├── consent_form.pdf
    ├── training_materials.pdf
    ├── stimuli/              # Pre-rendered PNGs
    └── trial_data/           # Raw CSV logs
```

### Sensitivity Analysis

In addition to the primary RM-ANOVA, run a logistic mixed-effects model:
```
accuracy ~ encoding * task_type + (1 + dataset | participant)
```

This model:
- Does not require arcsin transformation (binary DV handled natively)
- Accounts for participant-level random slopes
- Models dataset as random effect
- Handles missing trials without listwise deletion

Report both RM-ANOVA and logistic mixed-effects results.

---

## 13. Timeline

| Week | Activity |
|------|----------|
| 1 | Implement stimulus rendering pipeline in R (ggtrust-based PNG generator) |
| 2 | Build experiment web app; pre-render all stimuli |
| 3 | Pilot (3 participants); refine instructions, timing, difficulty |
| 4 | Recruitment; main data collection (28 participants) |
| 5 | Data analysis; pre-registration of analysis plan on OSF |
| 6 | Write results section; produce figures |

---

## 14. Preregistration

Before data collection, preregister at OSF or AsPredicted:

- Hypotheses (H1-H9)
- Design (within-subjects, 4 × 3, Latin square)
- Sample size (n=24, recruit 28)
- Primary DV (accuracy), secondary DV (RT, calibration, subjective)
- Statistical tests (RM-ANOVA, Holm-corrected post-hoc, logistic mixed-effects)
- Exclusion criteria (baseline accuracy < 50%, non-compliance)
- Any planned covariates (visualization experience, DR familiarity)
- Confirmatory vs. exploratory: H1-H5 are confirmatory; H6-H9 are exploratory

---

## 15. Materials Checklist

- [x] Consent form (IRB-exempt)
- [ ] Training documents (4 encoding legends + annotated examples)
- [ ] Demographics questionnaire
- [ ] Pre-rendered stimulus PNGs (4 encodings × 3 datasets × 3 task types × 4 repetitions ≈ 144 unique stimuli)
- [ ] Experiment web app (HTML/JS)
- [ ] Debrief document
- [ ] Post-study questionnaire (encoding ratings + SUS + free-text)
- [ ] Analysis scripts (R)
- [ ] Preregistration document
- [ ] Pilot data collection plan

---

## Appendix: Trial Timing Validation (Pilot Phase)

Pilot objectives (n=3):

1. **Baseline accuracy should be 55-65%** — not at chance (50% for 2AFC, 33% for 3AFC) and not at ceiling (>85%). If outside this range, adjust task difficulty (region size, fidelity range, cluster separation).

2. **Variability across participants** — SD of accuracy should be <15%. If higher, the task instructions are unclear or the stimuli are too ambiguous.

3. **No encoding should cause systematic confusion** — qualitatively check that participants can correctly map the encoding legend to test trials.

4. **Total timing should be <60 min** — if longer, reduce trial repetitions from 4 to 3 (108 trials total).

5. **Stacked overplotting check** — verify that the combined halo + landscape rendering remains legible at n=500 (halo rendering at n=500 takes ~1.7s in the benchmark; acceptable for pre-rendered static stimuli).