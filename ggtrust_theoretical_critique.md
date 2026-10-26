# Critical Theoretical Evaluation of ggtrust

---

## 1. Is "positional reliability" genuinely different from statistical uncertainty?

**Short answer: No, as originally defined.**

"Positional reliability" as a phrase describes uncertainty about whether a point's plotted position is "correct." But uncertainty about position *is* a form of statistical uncertainty — specifically, uncertainty about the value of the derived coordinate variables (x', y') after a transformation. The distinction between "the value is uncertain" and "the position is uncertain" is ontologically empty: position *is* a value when plotted.

The attempt to distinguish them relies on a category error:

| Concept | What is uncertain | Example |
|---------|------------------|---------|
| Statistical uncertainty (standard) | The value of a variable | "Temperature = 22°C ± 2°C" |
| Positional reliability (claimed) | The position of a point | "Point at (x,y) may not belong here" |

But in a scatterplot, position *is* the mapping of (var1, var2) to (x, y). If var1 or var2 is uncertain, the position is uncertain. If the transformation from data to coordinates is approximate (as in DR), the position carries a *different kind* of uncertainty — one about the mapping itself, not about the source variables.

This distinction *is* real, but the terminology "positional reliability" obscures it. The correct term is **spatialization fidelity**: the degree to which a 2D position faithfully preserves the structural relationships of the original data.

**Spatialization fidelity ≠ statistical uncertainty** because:

| Dimension | Statistical uncertainty | Spatialization fidelity |
|-----------|------------------------|------------------------|
| **What is uncertain** | The value of a variable | The appropriateness of a mapping |
| **Source** | Measurement error, sampling, prediction | Nonlinear transformation, information loss, optimization artifacts |
| **Scale** | Per-variable or per-observation | Per-point in the projected space only |
| **Remedy** | More/better data, better measurement | Better parameters, different algorithm, higher dimensions |
| **Formalizable as** | Variance, quantiles, intervals | Trustworthiness, continuity, stress, neighborhood preservation |

This distinction holds strongly for DR-derived scatterplots. It weakens for prediction scatterplots and measurement data — there, the uncertainty about position collapses back into standard prediction/measurement uncertainty. So the concept genuinely applies to only one domain.

**Verdict:** The concept is real but misnamed. It is not "positional reliability" (which implies a general property) but **spatialization fidelity** (a specific property of data-transformation-driven visualizations). And it does not generalize to all scatterplots — only those where position is *derived* from a higher-dimensional space.

---

## 2. Is positional reliability a new visual variable or simply another uncertainty encoding?

**It is not a new visual variable.**

Bertin's visual variables (1967): position, size, shape, value, color hue, orientation, texture.
Cleveland & McGill's ranking (1984): position, length, angle, slope, area, volume, color hue, color density, color saturation.
Mackinlay's APT (1986): quantitative, ordinal, nominal channels.

None of these lists includes "reliability" as a primary visual variable. The encodings proposed for ggtrust (halo radius, halo opacity, gradient blur, background landscape) all use *existing* variables:

- **Halo radius** → uses **size** (area from center)
- **Halo opacity** → uses **value/grey scale** (intensity or alpha)
- **Gradient blur** → uses **texture** (spatial frequency)
- **Landscape** → uses **position** and **color saturation**

Every encoding is a repurposing of existing variables. There is no new channel.

**But this is also true of uncertainty visualization generally.** Error bars use length. Violin plots use area. HOPs use animation (time). Quantile dotplots use position. Uncertainty visualization is not about inventing new visual variables — it is about developing conventions for *which* existing variables to use and how to combine them for a specific cognitive task.

The real question is: **Does spatialization fidelity justify a dedicated encoding convention that differs from how we encode statistical uncertainty?**

The answer is **yes, tentatively** — because the cognitive task differs:

- **Statistical uncertainty** → Task: "What range of values is plausible for this variable?" → Encoding: interval, distribution shape
- **Spatialization fidelity** → Task: "How much should I trust this point's position relative to others?" → Encoding: per-point positional precision signal

The argument is that a dedicated convention (halos, opacity gradients) would be more effective for the *trust* task than reusing error bars (which communicate a different cognitive concept — range, not fidelity).

But this is an empirical claim, not a theoretical one. The theoretical innovation is not a new variable but a **new convention for applying existing variables to a specific and previously unaddressed cognitive task.**

---

## 3. Can positional reliability be formally defined?

**Not as a single, domain-general concept.**

The phrase "positional reliability" is pre-formal — a communicative metaphor, not a mathematical construct. To be formally defined, it would need a clear operationalization:

### For DR projections (the only clean case):
Let X ∈ ℝ^(n×d) be the original data and Y ∈ ℝ^(n×2) be the projection. For each point i, define its *neighborhood preservation fidelity* as:

- **Trustworthiness** T(k, i) = 1 - (2/(n·k·(2n-3k-1))) · Σⱼ(r(i,j) - k) where r(i,j) are points that are k-NN in 2D but not in high-D
- **Continuity** C(k, i) = same metric for the converse (k-NN in high-D but not in 2D)

These are mathematically well-defined per-point metrics. They measure a specific aspect of spatialization fidelity: how well local neighborhood structure is preserved.

### For prediction scatterplots (weaker case):
For a prediction vs. actual plot, the "reliability" of point i is a function of the prediction error or confidence interval width. But this is not a new concept — it is standard prediction uncertainty expressed as a function of the predicted value.

### For measurement data (weakest case):
Measurement precision is standard statistical uncertainty. There is no concept of "positional reliability" here — the point's position is exactly determined by the (x, y) measurements.

**Conclusion:** Only DR projection quality admits a non-circular formal definition. Prediction and measurement collapse back to standard uncertainty.

### Formal definition for the project's scope:

> **Spatialization fidelity** is a property of a point i in a 2D projection Y derived from high-dimensional data X, quantified by the preservation of distance-based or order-based relationships between i and its neighbors when comparing neighborhoods in ℝ^d and ℝ^2.

This is expressible as a vector s ∈ [0,1]^n where s_i combines T(k,i) and C(k,i) into a single fidelity score. The scalarization function is a design parameter (minimum, product, or weighted combination of the two metrics).

---

## 4. Should it be treated as an aesthetic, a scale, a stat, a geom, or some combination?

The original ggtrust design proposed it as an aesthetic. This is **theoretically problematic** for three reasons:

### Problem 1: Aesthetics are direct, not meta-level
In the Grammar of Graphics, an aesthetic is a direct mapping from a data variable to a visual channel: `color = Species` maps the *variable* Species to the *channel* color hue. Spatialization fidelity is not a data variable — it is a *meta-property of the visualization itself*. It says nothing about the data being plotted; it says something about the *plot's relationship to the data*.

Wilkinson (2005, p. 38): "An aesthetic attribute is a visual property of a graph that is controlled by data." Fidelity is not controlled by data — it is controlled by the *interaction* between data, transformation, and parameter choices. This makes it categorically different from standard aesthetics.

### Problem 2: Aesthetics are atomic; fidelity is composite
A single aesthetic (`color`) maps to a single channel (hue). Fidelity can't: the appropriate encoding depends on context (point density, display size, task). A fixed aesthetic-to-channel mapping violates the principle that aesthetics have a consistent visual interpretation.

### Problem 3: Circular dependency
If we say `aes(reliability = trust_score)`, the trust_score is *derived from* the positions (x, y) in the same layer. The aesthetic would be a function of other aesthetics in the same layer. This creates a circular dependency in the grammar. (In ggplot2 terms: you cannot compute `reliability` from `x` and `y` within the same layer because layers assume aesthetics are independent data bindings.)

### The correct theoretical treatment:

**Spatialization fidelity is a layer-level specification, not an aesthetic.**

It belongs at the same level as the choice of coordinate system, statistical transformation, or position adjustment. Specifically:

| Component | Role | What it does |
|-----------|------|-------------|
| **Stat** | Computation | Takes a high-D matrix and 2D projection → per-point fidelity scores |
| **Scale** | Mapping | Defines the [0,1] fidelity range → visual channel range (e.g., halo radius range 0–5mm, opacity range 0.1–1.0) |
| **Geom** | Rendering | Accepts a point position + a fidelity score → renders the point with appropriate halo/gradient/landscape |
| **Aesthetic** | (none) | Fidelity is NOT an aesthetic because it's not a data variable; it's a property of the spatialization |

The API should reflect this:

```r
# Correct: fidelity as a layer specification
ggplot(data, aes(x = V1, y = V2)) +
  layer_fidelity(original_data = high_dim_matrix) +
  geom_point()

# Or as a dedicated geom that internally computes fidelity
geom_faithful_point(aes(x, y), original_data = high_dim_matrix)
```

This is closer to how `geom_smooth` works — it's a geom that internally computes a statistical transformation (the LOESS/GAM fit), not a new aesthetic.

---

## 5. Comparison against existing systems

### Grammar of Graphics (Wilkinson, 2005)

The Grammar treats data → variable → aesthetic as a deterministic pipeline. There is no concept of "this mapping might be wrong for some points." Wilkinson discusses *error* in the sense of statistical fitting (pp. 188–195), but this is about uncertainty in regression, not uncertainty in the position mapping itself.

The GoG page coordinates are defined as functions of variables:
- x = position(f(attribute1))
- y = position(f(attribute2))

In DR-derived plots, this becomes:
- x = position(DR1(X)), where DR1 is a nonlinear function of *all* variables
- y = position(DR2(X)), where DR2 is another nonlinear function of *all* variables

The GoG formalism can represent this — it allows arbitrary algebraic expressions for coordinates. But it provides no mechanism for expressing the *fidelity* of this expression. The GoG assumes that once the expression is evaluated, the result is the final position. There is no meta-level for "how good is this expression?"

**Gap:** The GoG lacks a meta-level. It describes *what* is shown but not *how well* it corresponds to the original data.

### Vega-Lite

Vega-Lite introduces error bars and error bands as specific mark types (`errorbar`, `errorband`). These take `yErr` values that define the uncertainty range around a point estimate. Importantly, Vega-Lite treats error as a *visual property of the mark*, not as a coordinate transformation.

Vega-Lite also has `opacity`, `fillOpacity`, and `strokeOpacity` as channels that could theoretically carry fidelity information. But they are general-purpose — there is no semantic commitment to what they mean.

**Gap:** Vega-Lite allows encoding uncertainty about *mark values* (through error bars) but not about *mark positions* (whether the (x, y) position itself is trustworthy). Its opacity channels could carry this information, but without semantic typing, the interpretation depends on the reader.

### ggplot2

ggplot2 has no fidelity concept. The closest existing pattern is:

```r
ggplot(aes(x, y)) + geom_point(aes(alpha = trust_score))
```

This maps trust to opacity, which *could* be interpreted as reliability. But:
1. The semantic interpretion is ad-hoc (the reader must guess that opacity means reliability)
2. There is no automatic computation of trust scores from the data/DR pipeline
3. There is no principled encoding selection (why opacity and not size?)
4. The perceptual consequences are unstudied

**Gap:** ggplot2 has the infrastructure to encode fidelity (through existing aesthetics) but lacks the theory, convention, and computation to do so in a principled way.

### ggdist

ggdist provides distribution visualization: `stat_slab` shows probability density, `stat_dotinterval` shows quantiles, `stat_halfeye` shows combined density+interval. These are fundamentally about *distribution of a variable* — showing the full posterior or bootstrap distribution of a single quantity.

The theoretical assumption: a variable (or derived quantity like a regression coefficient) has a probability distribution, and the task is to show this distribution visually.

**Distinction from fidelity:** ggdist shows distributions of *variable values*. The ggtrust concept shows fidelity of *point positions*. These are orthogonal: a point could have a well-estimated value but be poorly placed in a DR projection, or vice versa. They cross-cut:

| | High fidelity position | Low fidelity position |
|---|---|---|
| Certain value | Point correctly placed, confident value | Point incorrectly placed, but value is known |
| Uncertain value | Point correctly placed, but value is imprecise | Both problems |

ggdist addresses the vertical axis of this table. ggtrust would address the horizontal axis. The concepts are complementary, not overlapping.

### tidybayes

tidybayes is a grammar for Bayesian visualization built on ggdist. It extracts posterior draws into tidy formats and visualizes them using ggdist geoms. Its theoretical contribution: making Bayesian posterior computation compatible with the grammar of graphics through tidy data principles.

**Distinction from fidelity:** tidybayes inherits ggdist's focus on variable-value distributions. It adds Bayesian-specific uncertainty (posterior intervals, predictive intervals) but all within the distribution-of-variables paradigm.

**Comparison summary:**

| System | Uncertainty type | What is uncertain | Theoretical contribution |
|--------|-----------------|-------------------|------------------------|
| GoG (base) | (none) | (none) | Deterministic position mapping |
| Vega-Lite | Error bar | Mark value (y) | Composite mark for value uncertainty |
| ggplot2 | (ad-hoc) | (user-defined) | Infrastructure without theory |
| ggdist | Distribution | Variable value | Distribution-first geoms → stats |
| tidybayes | Bayesian posterior | Parameter/prediction | Tidy data + distribution geoms |
| **ggtrust (proposed)** | **Spatialization fidelity** | **Point position in projected space** | **Meta-level for mapping quality** |

---

## 6. Conceptual weaknesses

### Weakness 1: The concept is defined negatively rather than positively.

"Positional reliability" means "not unreliable." It defines itself by what it lacks — the absence of distortion. This negative definition makes it theoretically weak: it doesn't specify what it IS, only what it isn't.

Compare with ggdist's concepts: "distribution" is positively defined (a function over values). "Halfeye" is positively defined (density + interval). The theoretical constructs have positive content.

**Fix:** Reframe from "reliability" (absence of distortion) to "**neighborhood fidelity**" (presence of structural preservation). The concept should be defined by what it measures (distance/order preservation), not by the absence of something.

### Weakness 2: It conflates multiple distinct metrics under one label.

"A reliable point" could mean any of:
- Its k-nearest neighbors in 2D match those in high-D (trustworthiness)
- Its k-nearest neighbors in high-D appear in 2D (continuity)
- Its pairwise distances are preserved (stress)
- It is not sensitive to parameter changes (stability)
- Its local region is not an artifact (cluster separation maintenance)

These are different mathematical properties that often disagree. Collapsing them into a single "reliability" score discards information and creates a false unitary concept.

**Fix:** The theoretical framework should not claim a unitary "reliability" concept. It should acknowledge multiple *dimensions of spatialization fidelity* and treat the scalarization as a design parameter, not a theoretical primitive.

### Weakness 3: The visual encoding of fidelity creates an interpretation paradox.

A point with low fidelity should be visually de-emphasized (faded, blurred) because its position cannot be trusted. But low-fidelity points are precisely those that users should pay *most* attention to, because they are the most misleading. Visually de-emphasizing them may cause users to ignore the very points that require critical scrutiny.

This is not just a design problem — it is a **theoretical paradox**: the optimal encoding for "this point is unreliable" is opposite to the optimal encoding for "this point deserves attention."

**Fix:** The theory must distinguish between two tasks:
- *Assessment* task: "How reliable is the overall projection?"
- *Flagging* task: "Which points require caution?"

Visual de-emphasis (fading, blurring) supports the assessment task but undermines the flagging task. The theory should acknowledge this and propose task-dependent encodings, not a one-size-fits-all approach.

### Weakness 4: The grammar-level claim is too strong.

Claiming that "spatialization fidelity is a first-class aesthetic in the grammar of graphics" is overreaching. A legitimate aesthetic:
1. Maps one data variable to one visual channel (atomic)
2. Has a consistent perceptual interpretation across contexts
3. Is orthogonal to other aesthetics

Fidelity fails all three: it is composite, context-dependent, and non-orthogonal to position (it is a meta-property of position itself).

**Fix:** The theory should position fidelity as a *computation+display layer*, not an aesthetic. A fair comparison: `geom_smooth` is not an aesthetic — it is a stat+geom that displays a derived property of the data. Fidelity visualization is analogous: a dedicated layer for displaying a derived property (transformation quality) of the spatialization.

### Weakness 5: The domain generality claim is unsupported.

The original ggtrust claimed to work for DR projections, prediction scatterplots, and measurement data. Only DR admits a non-circular formal definition. The other two are better described by existing uncertainty visualization approaches.

**Fix:** Scrape the domain generality claim. The concept applies cleanly to one domain: dimensionality reduction. Attempting generality dilutes the theoretical rigor.

### Weakness 6: No perceptual theory grounds the encoding choices.

Why halos? Why opacity gradients? Why landscapes? The original proposal described these as design choices but provided no perceptual theory explaining why they should work. Without a theory, the visual encodings are arbitrary.

A perceptual theory would specify:
- The visual hierarchy: which channel dominates perception
- The discriminability: whether users can distinguish fidelity levels
- The interference: whether fidelity encoding interferes with other visual tasks
- The naturalness: whether the encoding is intuitive or requires training

**Fix:** Ground the encoding selection in established perceptual theory — specifically, the principle of *natural mapping* (Norman, 1988) and *conceptual metaphor* (Lakoff & Johnson, 1980). The metaphor "fidelity is precision-of-form" (precise → sharp, solid; imprecise → fuzzy, diffuse) is a natural mapping that should be intuitive without training. This is testable.

---

## 7. Rewritten theoretical framework

The following is the corrected, defensible theoretical framework.

---

### 7.1 Core construct: Spatialization Fidelity

**Definition:** Let X ∈ ℝ^(n×d) be data embedded in a d-dimensional space, and Y ∈ ℝ^(n×2) be a 2D scatterplot derived from X through a (possibly nonlinear) transformation T: ℝ^d → ℝ^2. The spatialization fidelity of a point i ∈ {1..n} is a function f(i, T, X) → [0,1] that quantifies the degree to which the positional relationships of i in Y preserve its structural relationships in X.

**Formalization:** For a chosen neighborhood size k, define:

- T_i(k) = trustworthiness of point i (neighbors in Y that are not neighbors in X)
- C_i(k) = continuity of point i (neighbors in X that are not neighbors in Y)

These are mathematically well-defined and can be combined:

f_i = 1 - max(w_t·(1 - T_i(k)), w_c·(1 - C_i(k)))  [worst-case preservation]

or

f_i = w_t·T_i(k) + w_c·C_i(k)                       [weighted average]

The aggregation method and weights are design parameters, not theoretical primitives. Different aggregation methods serve different analysis tasks.

### 7.2 Position in the Grammar of Graphics

Spatialization fidelity is **not an aesthetic**. It is a **layer-level annotation** — a secondary visual channel that runs parallel to the primary data-to-visualization mapping.

In Wilkinson's Grammar of Graphics (2005), the pipeline is:

DATA → TRANS → SCALE → COORD → ELEMENT → AESTHETIC

Spatialization fidelity inserts a *meta-layer* after TRANS:

DATA → TRANS → SCALE → COORD → ELEMENT → AESTHETIC
                                  ↓
                        FIDELITY COMPUTATION →
                                  ↓
                        FIDELITY ENCODING → VISUAL MODIFIER

The fidelity layer:
1. **Computes** f_i from the original data and the transformation
2. **Encodes** f_i using a perceptual channel (not an aesthetic binding)
3. **Modifies** the visual appearance of existing elements (points) based on their fidelity scores

This is theoretically parallel to how `geom_smooth` works: it computes a derived property (LOESS fit) and displays it as a modifier layer on top of the data. The key difference: fidelity modifies *existing* marks rather than adding *new* marks.

### 7.3 Relationship to established uncertainty types

The proposed framework categorizes uncertainty types along two dimensions:

| Dimension | Type A: Value uncertainty | Type B: Spatialization fidelity |
|-----------|---------------------------|-------------------------------|
| What is uncertain | Observable variable value | Point position in derived space |
| Source | Measurement, prediction, sampling | Transformation, information loss, optimization |
| Formalization | Variance, CI width, distribution | Trustworthiness, continuity, stress |
| Visual encoding convention | Error bars, intervals, distributions | Positional precision signals |
| Existing frameworks | ggdist, tidybayes, Vega-Lite error bars | (none — this project) |

Value uncertainty and spatialization fidelity are orthogonal:
- A point can have certain position + certain value → ideal case
- A point can have certain position + uncertain value → standard uncertainty visualization
- A point can have uncertain position + certain value → low spatialization fidelity
- A point can have uncertain position + uncertain value → compounded problem

### 7.4 Perceptual grounding

The visual encoding of spatialization fidelity follows the **principle of conceptual alignment** (based on Norman's natural mapping and Lakoff & Johnson's conceptual metaphor):

| Fidelity level | Perceptual metaphor | Visual realization | Predicted cognitive effect |
|---------------|-------------------|-------------------|---------------------------|
| High | Precision, certainty | Sharp, opaque, compact | Point appears "placed" — trusted |
| Medium | Approximation | Slight softness, partial opacity | Point appears "approximate" — use with caution |
| Low | Fuzziness, unreliability | Blurred, transparent, diffuse | Point appears "untrustworthy" — require verification |

The metaphor is **precision-of-form**: fidelity is understood through the visual precision of the mark. This is a natural, cross-cultural conceptual mapping that does not require training to interpret.

**Testable hypothesis (H1):** Viewers will rate points with blurry/transparent halos as less trustworthy than points with sharp/solid halos, independent of training.

**Testable hypothesis (H2):** Viewers shown a reliability-augmented scatterplot will make fewer incorrect inferences about cluster structure than viewers shown the same scatterplot without augmentation.

### 7.5 The interpretation paradox (acknowledged)

Low-fidelity points require *both* visual de-emphasis (communicating their untrustworthiness) and visual emphasis (flagging them for investigation). This paradox is not resolvable through a single encoding strategy. The framework addresses it by providing two complementary modes:

- **Assessment mode** (default): Fidelity is encoded as precision-of-form. This supports the gestalt task of assessing overall projection quality.
- **Flagging mode** (toggle): Low-fidelity points are highlighted (through borders, animation, or list view). This supports the analytic task of identifying problematic points.

The two modes serve different tasks. No single encoding can serve both simultaneously. The framework makes this explicit rather than pretending a single encoding solves all problems.

### 7.6 Scope and limitations

The theoretical framework applies **only to derived-position scatterplots** — plots where (x, y) are not directly measured but are computed from higher-dimensional data (DR projections, MDS/PCA biplots, embedding visualizations). It does *not* apply to:
- Direct measurement scatterplots (x, y measured directly)
- Prediction vs. actual plots (uncertainty here is standard prediction uncertainty)
- Any plot where position is not derived from a transformation

This scope limitation is a feature, not a bug. Narrowing the domain allows formal precision that domain-generality would preclude.

### 7.7 Summary of theoretical contributions

1. **Concept:** Spatialization fidelity — a formally definable property of derived-position scatterplots that quantifies per-point structural preservation.

2. **Grammar position:** A layer-level annotation (not an aesthetic) that modifies existing point marks based on transformation quality, analogous to how `geom_smooth` adds derived information.

3. **Perceptual theory:** The natural mapping of precision-of-form — where visual precision of marks communicates the precision of their position — grounded in cognitive metaphor theory.

4. **Paradox acknowledgment:** Low-fidelity points create competing visual needs (de-emphasis for assessment, emphasis for flagging), addressed through task-dependent modes rather than a single encoding.

5. **Scope delimitation:** The framework applies only to data-transformation-driven scatterplots, not to directly measured data.

---

### Table of differences: Original ggtrust vs. Revised theory

| Dimension | Original ggtrust | Revised theoretical framework |
|-----------|-----------------|------------------------------|
| Core concept | Positional reliability (metaphor) | Spatialization fidelity (measurable) |
| Domain | All scatterplots | Only derived-position scatterplots |
| Grammar role | Aesthetic | Layer-level annotation |
| Formalization | None (intuitive) | Trustworthiness + continuity (mathematical) |
| Unitarity | Single "reliability" concept | Multiple fidelity dimensions, scalarization as design choice |
| Perceptual theory | None (design-based) | Precision-of-form (metaphor theory) |
| Paradox | Ignored | Acknowledged and addressed (assessment/flagging modes) |
| Distinctiveness from uncertainty | Claimed but not argued | Explicit orthogonal framework |
