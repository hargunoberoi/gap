# Generative AI for Professionals

Welcome to the "Generative AI for Professionals" course repository. This repository contains course materials and the website source code.

## Course Website

Visit the course website: [https://hargunoberoi.github.io/gap](https://hargunoberoi.github.io/gap)

## Course Contents

This repository serves as the central location for all course materials. For the best experience, use the website linked above to navigate through the course content.

## For Contributors

If you'd like to contribute to the course materials or report issues, please follow standard GitHub procedures for pull requests and issue reporting.

## Deployment

This project is automatically deployed to GitHub Pages using GitHub Actions. When changes are pushed to the `pages` branch, a workflow will:

1. Build the Pelican site
2. Deploy it to the `gh-pages` branch
3. GitHub Pages will serve the content from this branch

This means you don't need to manually build or commit the generated HTML files. Just push your content changes to the `pages` branch, and the site will be updated automatically.

## Local Development

If you want to build and preview the site locally:

1. Make sure you have Python installed
2. Run the build script:
   ```bash
   ./build.sh
   ```
3. To view the site locally:
   ```bash
   cd docs && python -m http.server
   ```
   Then open http://localhost:8000 in your browser

## Project Structure

- `/content`: Contains all site content (chapters, pages, images)
- `/themes`: Contains the theme for the website
- `/docs`: Generated site files (created by the build script)
- `pelicanconf.py`: Pelican configuration file
- `build.sh`: Simple script to build the site
