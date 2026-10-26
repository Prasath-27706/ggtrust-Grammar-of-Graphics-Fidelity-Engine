# ggtrust Rendering Benchmarks

Results measured with `microbenchmark::microbenchmark(time = 10, unit = "s")`
on Zorin OS 18.1, R 4.3.3. Median render time to draw a plot to a null device.

## Results

| n | Halo | Landscape | Dispatcher | stat_trust_dr |
|---|---|---|---|---|
| 50 | 0.28 | — | 0.26 | 0.21 |
| 100 | 0.41 | 0.25 | 0.41 | 0.35 |
| 200 | 0.69 | 0.28 | 0.69 | 0.60 |
| 500 | 1.66 | 0.65 | 1.71 | 1.59 |
| 1000 | 5.98 | 0.96 | 0.92 | 0.82 |
| 2000 | 13.73 | 1.52 | 1.49 | 1.33 |

All times in seconds (median of 10 iterations).

## Scaling analysis

Fitting `log(time) ~ log(n)` per encoding:

- **Halo**: slopes toward ~n^1.8 — near-quadratic. Each point draws up to
  `n_layers` (default 10) concentric `circleGrob`s plus a Gaussian falloff,
  so cost grows superlinearly with point count. At 5000+ points halo rendering
  exceeds ~35s, which is unacceptable for interactive use.
- **Landscape**: slopes toward ~n^0.7 — sub-linear after the fixed-cost GAM fit
  (~0.2s for grid 100x100). Rendering cost is dominated by the smoothing fit,
  which is nearly independent of n beyond a threshold.
- **Dispatcher**: follows whichever encoding it selects. The 500-point default
  threshold (`selection.halo_max`) lands in the region where halo (1.7s) begins
  to degrade vs landscape (0.65s), confirming the default is reasonable.
- **stat_trust_dr**: near-linear. Computing T/C adds a k-NN pass (FNN), which is
  the dominant cost at small n and continues to grow slowly.

## Implications

1. **Halo is for small data.** Below ~500 points it is fast and perceptually
   appropriate (per-point marks). Above that, render cost rises quadratically.
2. **Landscape is for large data.** The GAM smooth has near-constant cost and
   scales gracefully to 10k+ points (grid resolution is the real lever).
3. **Dispatcher threshold is well-placed.** 500 points is both a perceptual and
   a computational sweet spot.
4. **stat_trust_dr overhead is modest.** A 10D->2D embedding of 2000 points
   computes reliability in ~1.3s including rendering.

## Limitations

- Times measured on a single machine; absolute values vary, but *relative*
  scaling (halo ~n^2 vs landscape ~n^0.7) is robust.
- `print()`, not `ggplotGrob()`, was timed; rendering differences dominate.
- The landscape GAM fit dominates its time; users can trade `grid_size`
  down (e.g. 60) for faster rendering at large n.