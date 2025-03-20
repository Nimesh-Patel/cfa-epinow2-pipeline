# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set non-interactive installation mode
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies for R
RUN apt-get update && apt-get install -y \
    software-properties-common \
    dirmngr \
    gnupg \
    apt-transport-https \
    ca-certificates

# Add the CRAN repository and its key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 95C0FAF38D3A6E4E
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

# Install R
RUN apt-get update && apt-get install -y r-base

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
