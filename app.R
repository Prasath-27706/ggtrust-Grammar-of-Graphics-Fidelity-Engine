# Entry point for running the ggtrust Data Visualization Explorer App
# Launch via: shiny::runApp() or Rscript app.R

setwd(file.path(getwd(), "ggtrust", "inst", "shiny"))
source("app.R")
