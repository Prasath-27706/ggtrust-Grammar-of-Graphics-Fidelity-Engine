# ── ggtrust: Grammar of Graphics Spatialization Fidelity Explorer ──────────────
# Advanced Visual Analytics Platform for Dimensionality Reduction Diagnostics

library(shiny)
library(bslib)
library(ggplot2)
library(DT)

# Load package if installed or source R files directly
if (requireNamespace("ggtrust", quietly = TRUE)) {
  library(ggtrust)
} else {
  r_files <- list.files(file.path("..", "..", "R"), full.names = TRUE)
  if (length(r_files) == 0) {
    r_files <- list.files("R", full.names = TRUE)
  }
  sapply(r_files, source)
}

source("utils.R")

# ── Custom CSS Styles ───────────────────────────────────────────────────────
custom_css <- "
  .kpi-card {
    background: #1e222d;
    border-radius: 8px;
    padding: 16px;
    border-left: 4px solid #3b82f6;
    margin-bottom: 15px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
  }
  .kpi-title {
    font-size: 0.85rem;
    color: #9ca3af;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 4px;
  }
  .kpi-value {
    font-size: 1.8rem;
    font-weight: 700;
    color: #f3f4f6;
  }
  .dossier-card {
    background: #111827;
    border: 1px solid #374151;
    border-radius: 8px;
    padding: 18px;
    margin-top: 10px;
  }
  .dossier-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 9999px;
    font-weight: 600;
    font-size: 0.85rem;
    margin-bottom: 12px;
  }
  .code-box {
    background: #0f172a;
    color: #e2e8f0;
    padding: 15px;
    border-radius: 6px;
    font-family: 'Fira Code', 'Consolas', monospace;
    font-size: 0.88rem;
    border: 1px solid #334155;
    white-space: pre-wrap;
  }
"

# ── UI ──────────────────────────────────────────────────────────────────────
ui <- page_navbar(
  title = span(
    tags$strong("ggtrust"),
    tags$span(style = "font-weight: 300; opacity: 0.8; margin-left: 6px;", "Spatialization Fidelity Analytics")
  ),
  theme = bs_theme(
    bootswatch = "darkly",
    primary = "#3b82f6",
    base_font = font_google("Inter")
  ),
  header = tags$head(tags$style(custom_css)),

  # ── TAB 1: Visual Encoding Explorer ──────────────────────────────────────
  nav_panel(
    title = "🎨 Visual Encoding Explorer",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        titlePanel(h4("Data & Projection")),
        selectInput("dataset_choice", "Select Dataset:",
                    choices = c(
                      "Single-Cell RNA-seq (PBMC 500 Cells - 20 Genes)" = "scrna_pbmc",
                      "Iris Benchmark (t-SNE)" = "iris",
                      "Wine Quality (PCA)" = "wine",
                      "MNIST-400 Digits (t-SNE Distortions)" = "mnist",
                      "Synthetic Cluster Artifacts" = "synthetic"
                    )),

        h4("Fidelity Math (k-NN)"),
        sliderInput("k_neighbors", "Neighborhood size (k):", min = 3, max = 30, value = 10, step = 1),
        selectInput("aggregation", "Fidelity Combination:",
                    choices = c("Minimum / Pessimistic (min)" = "min",
                                "Product / Joint Prob (prod)" = "prod",
                                "Average (avg)" = "avg")),

        hr(),
        h4("Visual Encoding Mode"),
        radioButtons("encoding_mode", "Select Technique:",
                     choices = c(
                       "Technique 1: Gaussian Halos (Concentric Rings)" = "halo",
                       "Technique 1B: Continuous Fidelity Surface" = "landscape",
                       "Technique 1C: Topological Neighbor Tethers" = "tether",
                       "Technique 1D: Geometric Error Crosshairs" = "crosshair",
                       "Technique 1E: Point-Intrinsic Alpha Saliency" = "alpha",
                       "Technique 1F: Stacked Hybrid (Halos + Surface)" = "stacked",
                       "Baseline (Unannotated DR Scatterplot)" = "baseline"
                     ),
                     selected = "halo"),

        selectInput("color_by", "Point Color Channel:",
                    choices = c("Ground Truth Class / Cell Lineage" = "label",
                                "Distortion Typology (Anchor/Impostor/Exile)" = "typology",
                                "Continuous Fidelity Score" = "reliability")),

        accordion(
          open = FALSE,
          accordion_panel(
            "Halo Mode Tuning",
            sliderInput("halo_max_radius", "Max Radius (NPC):", min = 0.005, max = 0.06, value = 0.02, step = 0.005),
            sliderInput("halo_n_layers", "Concentric Rings:", min = 3, max = 15, value = 10, step = 1),
            sliderInput("halo_falloff", "Gaussian Falloff (σ):", min = 0.1, max = 0.8, value = 0.3, step = 0.05)
          ),
          accordion_panel(
            "Tether & Surface Tuning",
            sliderInput("tether_threshold", "Tether Fidelity Cutoff:", min = 0.50, max = 0.98, value = 0.90, step = 0.02),
            sliderInput("tether_k", "Tether Connections (k):", min = 1, max = 8, value = 3, step = 1),
            sliderInput("landscape_alpha", "Surface Heatmap Alpha:", min = 0.1, max = 0.9, value = 0.5, step = 0.05)
          ),
          accordion_panel(
            "Point Mark Styling",
            sliderInput("point_size", "Point Size:", min = 1, max = 8, value = 2.5, step = 0.5),
            sliderInput("point_alpha", "Point Opacity:", min = 0.1, max = 1.0, value = 0.85, step = 0.05)
          )
        )
      ),

      mainPanel(
        width = 9,
        fluidRow(
          column(3, div(class = "kpi-card",
                        div(class = "kpi-title", "Total Points / Cells"),
                        div(class = "kpi-value", textOutput("kpi_n_points")))),
          column(3, div(class = "kpi-card", style = "border-left-color: #10b981;",
                        div(class = "kpi-title", "Mean Fidelity"),
                        div(class = "kpi-value", textOutput("kpi_mean_fidelity")))),
          column(3, div(class = "kpi-card", style = "border-left-color: #ef4444;",
                        div(class = "kpi-title", "Impostor Intrusions"),
                        div(class = "kpi-value", textOutput("kpi_n_impostors")))),
          column(3, div(class = "kpi-card", style = "border-left-color: #f59e0b;",
                        div(class = "kpi-title", "Torn Cluster Exiles"),
                        div(class = "kpi-value", textOutput("kpi_n_exiles"))))
        ),

        card(
          card_header(
            class = "d-flex justify-content-between align-items-center",
            span(h5("ggtrust 2D Canvas", class = "mb-0"))
          ),
          card_body(
            plotOutput("main_ggtrust_plot", height = "560px")
          )
        )
      )
    )
  ),

  # ── TAB 2: Interactive Neighborhood Inspector Lens ────────────────────────
  nav_panel(
    title = "🧭 Neighborhood Inspector Lens",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h4("Inspect Individual Cell / Point"),
        p("Select a specific observation to trace its true high-dimensional neighbors and detect false 2D intruders:"),
        sliderInput("inspector_point_id", "Point / Cell Index:", min = 1, max = 500, value = 105, step = 1),
        actionButton("select_torn_example", "Inspect Torn Cell (#105)", class = "btn-warning btn-sm w-100 mb-2"),
        actionButton("select_intruder_example", "Inspect Intruder Cell (#130)", class = "btn-danger btn-sm w-100 mb-2"),
        actionButton("select_anchor_example", "Inspect Faithful Cell (#20)", class = "btn-success btn-sm w-100 mb-3"),
        hr(),
        div(class = "dossier-card",
            h5("Diagnostic Dossier"),
            uiOutput("dossier_content")
        )
      ),
      mainPanel(
        width = 9,
        card(
          card_header(h5("Interactive Topological Inspector (Tethers to True Neighbors & Impostor Warning Rings)")),
          card_body(
            plotOutput("inspector_plot", height = "600px")
          ),
          card_footer(
            p(class = "text-muted small mb-0",
              "🟢 Green segments = Elastic tethers connecting the selected point to its true high-D neighbors. ",
              "🔴 Red rings = False 2D impostors (points appearing nearby in 2D despite being distant in feature space).")
          )
        )
      )
    )
  ),

  # ── TAB 3: Distortion Typology Phase Plane ────────────────────────────────
  nav_panel(
    title = "📊 Distortion Typology & Phase Plane",
    fluidRow(
      column(8,
        card(
          card_header(h5("Technique 3: Distortion Typology Phase Plane (T vs C 4-Quadrant Matrix)")),
          card_body(
            plotOutput("typology_plot", height = "560px")
          ),
          card_footer(
            p(class = "text-muted small mb-0",
              "Decomposes quality into two orthogonal distortion modes: ",
              "Intrusions (False Neighbors: low T) vs Extrusions (Torn Clusters: low C).")
          )
        )
      ),
      column(4,
        card(
          card_header(h5("Typology Distribution by Cell Lineage")),
          card_body(
            plotOutput("typology_bar_plot", height = "560px")
          )
        )
      )
    )
  ),

  # ── TAB 4: Multi-Scale Scale-Space Horizon ─────────────────────────────────
  nav_panel(
    title = "📈 Multi-Scale Scale-Space Horizon",
    card(
      card_header(h5("Technique 4: Multi-Scale Scale-Space Horizon (k-Spectrum Stability)")),
      card_body(
        plotOutput("scale_spectrum_plot", height = "560px")
      ),
      card_footer(
        p(class = "text-muted small mb-0",
          "Tracks how cluster fidelity behaves as neighborhood scale expands from micro (k = 3) to macro (k = 45). ",
          "Shows at what scale manifold structure is preserved vs. broken.")
      )
    )
  ),

  # ── TAB 5: High-Dimensional Feature Geometry ──────────────────────────────
  nav_panel(
    title = "🎻 High-Dimensional Multi-Axis Geometry",
    fluidRow(
      column(12,
        card(
          card_header(h5("Technique 5: Parallel Coordinates Plot (PCP) with Fidelity-Viridis Tracing")),
          card_body(
            plotOutput("pcp_plot", height = "420px")
          ),
          card_footer(
            p(class = "text-muted small mb-0",
              "Each polyline represents a complete high-D feature profile colored by 2D projection fidelity (purple = distorted, yellow = faithful).")
          )
        )
      )
    ),
    fluidRow(
      column(6,
        card(
          card_header(h5("Technique 6: Co-Ranking Distortion Matrix Heatmap")),
          card_body(
            plotOutput("coranking_plot", height = "400px")
          )
        )
      ),
      column(6,
        card(
          card_header(h5("Technique 7: Shepard Distance Distortion Diagram")),
          card_body(
            plotOutput("shepard_plot", height = "400px")
          )
        )
      )
    )
  ),

  # ── TAB 6: Side-by-Side Validation & Code ──────────────────────────────────
  nav_panel(
    title = "⚖️ Side-by-Side Comparison & Code",
    fluidRow(
      column(6,
        card(
          card_header(h5("Baseline Unannotated Scatterplot (Standard Practice)")),
          card_body(
            plotOutput("comparison_baseline_plot", height = "480px")
          )
        )
      ),
      column(6,
        card(
          card_header(h5("ggtrust Fidelity-Augmented Scatterplot")),
          card_body(
            plotOutput("comparison_ggtrust_plot", height = "480px")
          )
        )
      )
    ),
    fluidRow(
      column(12,
        card(
          card_header(h5("Reproducible R Code Snippet")),
          card_body(
            div(class = "code-box", textOutput("generated_r_code"))
          )
        )
      )
    )
  ),

  # ── TAB 7: Per-Point Data Table ───────────────────────────────────────────
  nav_panel(
    title = "📋 Per-Point Data Table",
    card(
      card_header(h5("Raw Data & Computed Neighborhood Quality Metrics")),
      card_body(
        DT::dataTableOutput("fidelity_table")
      )
    )
  )
)

# ── SERVER ──────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  processed_dataset <- reactive({
    ds <- get_preset_dataset(input$dataset_choice)
    compute_dataset_fidelity(ds, k = input$k_neighbors, aggregation = input$aggregation)
  })

  # Dynamic update of point slider max based on dataset size
  observe({
    n_pts <- nrow(processed_dataset()$emb)
    updateSliderInput(session, "inspector_point_id", max = n_pts)
  })

  # Quick selection buttons
  observeEvent(input$select_torn_example, {
    updateSliderInput(session, "inspector_point_id", value = min(105, nrow(processed_dataset()$emb)))
  })
  observeEvent(input$select_intruder_example, {
    updateSliderInput(session, "inspector_point_id", value = min(130, nrow(processed_dataset()$emb)))
  })
  observeEvent(input$select_anchor_example, {
    updateSliderInput(session, "inspector_point_id", value = min(20, nrow(processed_dataset()$emb)))
  })

  # KPI Outputs
  output$kpi_n_points <- renderText({
    nrow(processed_dataset()$emb_annotated)
  })

  output$kpi_mean_fidelity <- renderText({
    df <- processed_dataset()$emb_annotated
    sprintf("%.1f%%", mean(df$reliability) * 100)
  })

  output$kpi_n_impostors <- renderText({
    df <- processed_dataset()$emb_annotated
    sum(df$typology == "False Impostor (Intrusion)")
  })

  output$kpi_n_exiles <- renderText({
    df <- processed_dataset()$emb_annotated
    sum(df$typology == "Torn Exile (Extrusion)")
  })

  # Tab 1: Main Plot Output
  output$main_ggtrust_plot <- renderPlot({
    ds <- processed_dataset()
    render_ggtrust_plot(
      dataset_obj = ds,
      encoding = input$encoding_mode,
      halo_max_radius = input$halo_max_radius,
      halo_n_layers = input$halo_n_layers,
      halo_falloff = input$halo_falloff,
      landscape_raster_alpha = input$landscape_alpha,
      tether_threshold = input$tether_threshold,
      tether_k = input$tether_k,
      point_size = input$point_size,
      point_alpha = input$point_alpha,
      color_by = input$color_by
    )
  }, res = 110)

  # Tab 2: Inspector Plot & Dossier
  output$inspector_plot <- renderPlot({
    ds <- processed_dataset()
    render_neighborhood_inspector_plot(ds, selected_id = input$inspector_point_id)
  }, res = 110)

  output$dossier_content <- renderUI({
    ds <- processed_dataset()
    df <- ds$emb_annotated
    pid <- input$inspector_point_id
    if (pid < 1 || pid > nrow(df)) pid <- 1
    pt <- df[pid, ]

    badge_col <- switch(as.character(pt$typology),
      "Faithful Anchor"            = "#065f46; color: #a7f3d0;",
      "False Impostor (Intrusion)" = "#991b1b; color: #fecaca;",
      "Torn Exile (Extrusion)"     = "#92400e; color: #fde68a;",
      "Critical Artifact (Void)"   = "#581c87; color: #e9d5ff;"
    )

    tagList(
      div(class = "dossier-badge", style = paste0("background:", badge_col), as.character(pt$typology)),
      p(tags$b("Identifier: "), pt$Cell_ID),
      p(tags$b("Ground Truth Class: "), pt$label),
      p(tags$b("Fidelity Score (S_i): "), round(pt$reliability, 4)),
      p(tags$b("Trustworthiness T(k,i): "), round(pt$trustworthiness, 4)),
      p(tags$b("Continuity C(k,i): "), round(pt$continuity, 4)),
      p(tags$b("2D Coordinates: "), sprintf("(%.2f, %.2f)", pt$x, pt$y))
    )
  })

  # Tab 3: Typology Plots
  output$typology_plot <- renderPlot({
    ds <- processed_dataset()
    render_distortion_typology_plot(ds)
  }, res = 110)

  output$typology_bar_plot <- renderPlot({
    ds <- processed_dataset()
    df <- ds$emb_annotated

    ggplot(df, aes(x = label, fill = typology)) +
      geom_bar(position = "fill") +
      scale_y_continuous(labels = scales::percent) +
      scale_fill_manual(
        name = "Typology",
        values = c(
          "Faithful Anchor"            = "#10b981",
          "False Impostor (Intrusion)" = "#ef4444",
          "Torn Exile (Extrusion)"     = "#f59e0b",
          "Critical Artifact (Void)"   = "#8b5cf6"
        )
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 30, hjust = 1, face = "bold"),
        legend.position = "bottom"
      ) +
      labs(
        title = "Error Breakdown per Lineage",
        x = "Cell Lineage / Class", y = "Proportion of Points"
      )
  }, res = 110)

  # Tab 4: Multi-Scale Horizon Plot
  output$scale_spectrum_plot <- renderPlot({
    ds <- processed_dataset()
    render_scale_spectrum_plot(ds)
  }, res = 110)

  # Tab 5: Feature Geometry Plots
  output$pcp_plot <- renderPlot({
    ds <- processed_dataset()
    render_pcp_plot(ds)
  }, res = 110)

  output$coranking_plot <- renderPlot({
    ds <- processed_dataset()
    render_coranking_matrix_plot(ds)
  }, res = 110)

  output$shepard_plot <- renderPlot({
    ds <- processed_dataset()
    render_shepard_plot(ds)
  }, res = 110)

  # Tab 6: Comparison Plots & Code
  output$comparison_baseline_plot <- renderPlot({
    ds <- processed_dataset()
    render_ggtrust_plot(ds, encoding = "baseline", point_size = input$point_size, color_by = input$color_by)
  }, res = 110)

  output$comparison_ggtrust_plot <- renderPlot({
    ds <- processed_dataset()
    render_ggtrust_plot(
      ds,
      encoding = input$encoding_mode,
      halo_max_radius = input$halo_max_radius,
      halo_n_layers = input$halo_n_layers,
      halo_falloff = input$halo_falloff,
      point_size = input$point_size,
      color_by = input$color_by
    )
  }, res = 110)

  output$generated_r_code <- renderText({
    enc <- input$encoding_mode
    geom_str <- switch(enc,
      halo = sprintf("  geom_trust_halo(max_radius = %.3f, n_layers = %d, falloff = %.2f) +\n",
                     input$halo_max_radius, input$halo_n_layers, input$halo_falloff),
      landscape = sprintf("  geom_trust_landscape(raster_alpha = %.2f) +\n", input$landscape_alpha),
      tether = sprintf("  geom_trust_tether(k_tether = %d, fidelity_threshold = %.2f) +\n",
                       input$tether_k, input$tether_threshold),
      crosshair = "  geom_trust_crosshair() +\n",
      alpha = "  aes(alpha = reliability) +\n",
      stacked = "  geom_trust_landscape() +\n  geom_trust_halo() +\n",
      baseline = ""
    )

    sprintf(
"library(ggplot2)
library(ggtrust)

# 1. Compute per-point neighborhood fidelity
fidelity_data <- compute_fidelity(high_d_matrix, embedding_matrix, k = %d)

# 2. Grammar of Graphics visualization
ggplot(fidelity_data, aes(x = x, y = y, reliability = reliability)) +
%s  geom_point(aes(color = label), size = %.1f) +
  scale_reliability_continuous() +
  theme_trust()",
      input$k_neighbors, geom_str, input$point_size
    )
  })

  # Tab 7: Data Table Output
  output$fidelity_table <- DT::renderDataTable({
    df <- processed_dataset()$emb_annotated
    df_show <- df
    df_show$x <- round(df_show$x, 3)
    df_show$y <- round(df_show$y, 3)
    df_show$trustworthiness <- round(df_show$trustworthiness, 4)
    df_show$continuity <- round(df_show$continuity, 4)
    df_show$reliability <- round(df_show$reliability, 4)

    cols_order <- c("Cell_ID", "label", "typology", "reliability", "trustworthiness", "continuity", "x", "y")
    cols_order <- intersect(cols_order, names(df_show))
    df_show <- df_show[, cols_order]

    DT::datatable(
      df_show,
      options = list(pageLength = 15, scrollX = TRUE),
      rownames = FALSE,
      colnames = c("Identifier", "Class/Lineage", "Distortion Typology", "Fidelity S_i", "Trustworthiness T", "Continuity C", "2D X", "2D Y")
    )
  })
}

shinyApp(ui, server)
