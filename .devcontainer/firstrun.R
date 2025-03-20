# First run setup script for the EpiNow2 Pipeline project
# This script will be executed after the container is created

# Initialize renv
renv::init(bare = TRUE)

# Install required packages
renv::install(c(
  "EpiNow2",
  "dplyr",
  "tidyr",
  "ggplot2",
  "lubridate",
  "yaml",
  "jsonlite",
  "optparse",
  "future",
  "furrr",
  "data.table",
  "here",
  "readr",
  "purrr",
  "testthat",
  "roxygen2",
  "devtools",
  "usethis",
  "knitr",
  "rmarkdown"
))

# Take a snapshot of the environment
renv::snapshot()

# Create package structure if it doesn't exist
if (!file.exists("DESCRIPTION")) {
  usethis::create_package(".", open = FALSE)
  
  # Set up package metadata
  usethis::use_description(
    fields = list(
      Title = "EpiNow2 Pipeline",
      Description = "A streamlined pipeline for estimating time-varying reproduction numbers using the EpiNow2 package.",
      `Authors@R` = 'person("Your", "Name", email = "your.email@example.com", role = c("aut", "cre"))',
      License = "MIT",
      Version = "0.1.0"
    )
  )
  
  # Set up package infrastructure
  usethis::use_namespace()
  usethis::use_testthat()
  usethis::use_readme_md()
  
  # Create directory structure
  dir.create("R/data", recursive = TRUE, showWarnings = FALSE)
  dir.create("R/models", recursive = TRUE, showWarnings = FALSE)
  dir.create("R/visualization", recursive = TRUE, showWarnings = FALSE)
  dir.create("R/utils", recursive = TRUE, showWarnings = FALSE)
  dir.create("R/cloud", recursive = TRUE, showWarnings = FALSE)
  dir.create("config", recursive = TRUE, showWarnings = FALSE)
  dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
  dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
  dir.create("data/results", recursive = TRUE, showWarnings = FALSE)
  dir.create("vignettes", recursive = TRUE, showWarnings = FALSE)
  
  # Create default configuration file
  cat('# Default configuration for EpiNow2 Pipeline
data:
  source: "jhu"
  start_offset_days: 60
  
model:
  generation_time:
    mean: 3.6
    sd: 3.1
  incubation_period:
    mean: 5.2
    sd: 1.72
  reporting_delay:
    mean: 2.0
    sd: 1.5
  
runtime:
  cores: 4
  samples: 2000
  warmup: 1000
  chains: 4
', file = "config/default.yaml")
  
  # Create main run script
  cat('#!/usr/bin/env Rscript

#\' EpiNow2 Pipeline
#\' 
#\' Main execution script for the EpiNow2 pipeline

library(optparse)
library(yaml)

# Parse command line arguments
option_list <- list(
  make_option("--config", type="character", default="config/default.yaml",
              help="Configuration file path"),
  make_option("--local", action="store_true", default=TRUE,
              help="Run locally (default)"),
  make_option("--cloud", action="store_true", default=FALSE,
              help="Run on cloud infrastructure")
)
opts <- parse_args(OptionParser(option_list=option_list))

# Load configuration
config <- yaml::read_yaml(opts$config)

# TODO: Implement pipeline execution
cat("Pipeline configuration loaded. Implementation pending.\n")
', file = "run.R")
  
  # Make run.R executable
  system("chmod +x run.R")
}

cat("EpiNow2 Pipeline development environment is ready!\n")
