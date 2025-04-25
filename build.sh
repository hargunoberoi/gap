#!/bin/bash

# Exit on error
set -e

echo "Building Generative AI for Professionals website..."

# Setup virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    echo "Installing dependencies..."
    pip install -r requirements.txt
else
    source .venv/bin/activate
fi

# Build the site
echo "Building static site with Pelican..."
pelican content -o docs -s pelicanconf.py

echo "Site built successfully! Output is in the 'docs' directory."
echo "To view the site locally, run: cd docs && python -m http.server"

# Deactivate virtual environment
deactivate



