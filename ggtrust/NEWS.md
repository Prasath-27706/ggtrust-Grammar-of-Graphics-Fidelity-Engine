# ggtrust 0.1.0

* Initial development version.

## Geoms

* `geom_trust_halo()`: per-point concentric Gaussian halos. Extent `(1 - reliability)`, opacity `reliability`. Halos are drawn **behind** the points.
* `geom_trust_landscape()`: smoothed fidelity surface as a raster + contours, with points on top.
* `geom_trust_point()`: dispatcher that auto-selects halo or landscape by point count.

## Stats

* `stat_trust_dr()`: computes per-point trustworthiness and continuity from original data and maps them to a `[0,1]` reliability aesthetic.
* `stat_trust_manual()`: validated pass-through for externally computed reliability.

## Scales, guides, theme

* `scale_reliability_continuous()` / `scale_reliability_binned()` with `ScaleReliability` ggproto (domain clamped to `[0,1]`).
* `guide_reliability()` legend glyphs showing the halo/landscape encoding.
* `theme_trust()`: opinionated theme tuned for the halo/landscape marks.

## Known limitations (v0.1)

* `coord_polar` halos are approximate (documented coordinate distortion).
* `stat_trust_confidence()` deferred to v1.1; concept is restricted to DR-derived positions.
* n > 5000 default to the landscape encoding (halo overplotting).