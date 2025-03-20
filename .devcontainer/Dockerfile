FROM rocker/verse:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libcairo2-dev \
    cmake \
    pandoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install EpiNow2 system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libudunits2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install R packages needed for development
RUN install2.r --error --skipinstalled \
    devtools \
    usethis \
    roxygen2 \
    testthat \
    knitr \
    rmarkdown \
    yaml \
    jsonlite \
    optparse \
    future \
    furrr \
    dplyr \
    tidyr \
    ggplot2 \
    lubridate \
    readr \
    purrr \
    data.table \
    here \
    httpgd \
    remotes

# Install EpiNow2 and its dependencies
RUN Rscript -e 'remotes::install_github("epiforecasts/EpiNow2", dependencies = TRUE)'

# Create a non-root user with sudo access
RUN useradd -m rstudio \
    && echo "rstudio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/rstudio \
    && chmod 0440 /etc/sudoers.d/rstudio

# Set up working directory
WORKDIR /workspaces/epinow2-pipeline

# Set up renv cache directory and permissions
RUN mkdir -p /renv-cache \
    && chown -R rstudio:rstudio /renv-cache

# Set environment variables
ENV RENV_PATHS_CACHE=/renv-cache
ENV RENV_PATHS_LIBRARY=/workspaces/epinow2-pipeline/renv/library

# Switch to non-root user
USER rstudio

# Set up R profile with renv configuration
RUN echo 'options(renv.config.auto.snapshot = FALSE)' >> ~/.Rprofile
