#!/bin/bash

# Enable verbose output
set -x

# Exit on error
set -e

echo "Building Generative AI for Professionals website..."

# Check if virtual environment exists, if not create it
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    echo "Installing dependencies..."
    ./.venv/bin/pip install -r requirements.txt
fi

# Activate virtual environment
source .venv/bin/activate

# Set up themes properly
echo "Setting up theme structure..."
mkdir -p themes/simple/templates
mkdir -p themes/simple/static/css
mkdir -p themes/simple/static/tipuesearch

# Create necessary template files only if they don't exist
if [ ! -f "themes/simple/templates/base.html" ]; then
    echo "Creating base.html template..."
    cat > themes/simple/templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>{% block title %}{{ SITENAME }}{% endblock %}</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    
    {% if TIPUE_SEARCH %}
    <link rel="stylesheet" href="{{ SITEURL }}/{{ THEME_STATIC_DIR }}/tipuesearch/tipuesearch.css">
    {% endif %}
    
    <link rel="stylesheet" href="{{ SITEURL }}/{{ THEME_STATIC_DIR }}/css/style.css">
    
    {% if COLOR %}
    <style>
        .navbar { background-color: {{ COLOR }} }
    </style>
    {% endif %}
</head>
<body>
    <nav class="navbar navbar-expand-md navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="{{ SITEURL }}/">
                <h3 class="course-title">{{ COURSE_NAME }}</h3>
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarDefault">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarDefault">
                <ul class="navbar-nav ml-auto">
                    {% for title, link in MENUITEMS %}
                    <li class="nav-item">
                        <a class="nav-link" href="{{ SITEURL }}/{{ link }}">{{ title }}</a>
                    </li>
                    {% endfor %}
                    {% if TIPUE_SEARCH %}
                    <form class="form-inline my-2" action="{{ SITEURL }}/search.html">
                        <div class="input-group input-group-sm">
                            <input class="form-control" type="text" name="q" id="tipue_search_input" placeholder="Search">
                            <div class="input-group-append">
                                <button class="btn btn-secondary" type="submit">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                    {% endif %}
                </ul>
            </div>
        </div>
    </nav>
    
    <main id="content" class="container mt-4">
        {% block content %}{% endblock %}
    </main>
    
    <footer class="footer mt-5 py-3 bg-light">
        <div class="container">
            <span class="text-muted">© {{ YEAR }} {{ AUTHOR }}</span>
        </div>
    </footer>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    
    {% if TIPUE_SEARCH %}
    <script src="{{ SITEURL }}/{{ THEME_STATIC_DIR }}/tipuesearch/tipuesearch_set.js"></script>
    <script src="{{ SITEURL }}/{{ THEME_STATIC_DIR }}/tipuesearch/tipuesearch.min.js"></script>
    <script>
    $(document).ready(function() {
        $('#tipue_search_input').tipuesearch({
            'mode': 'json',
            'contentLocation': '{{ SITEURL }}/tipuesearch_content.js'
        });
    });
    </script>
    {% endif %}
    
    {% block scripts %}{% endblock %}
</body>
</html>
EOF
fi

if [ ! -f "themes/simple/templates/search.html" ]; then
    echo "Creating search.html template..."
    cat > themes/simple/templates/search.html << 'EOF'
{% extends "base.html" %}
{% block title %}Search - {{ SITENAME }}{% endblock %}

{% block content %}
<h1>Search</h1>
<div id="tipue_search_content"></div>
{% endblock %}
EOF
fi

if [ ! -f "themes/simple/templates/article.html" ]; then
    echo "Creating article.html template..."
    cat > themes/simple/templates/article.html << 'EOF'
{% extends "base.html" %}
{% block title %}{{ article.title|striptags }} - {{ SITENAME }}{% endblock %}

{% block content %}
<article>
    <header>
        <h1>{{ article.title }}</h1>
        <div class="post-info">
            <time class="published" datetime="{{ article.date.isoformat() }}">
                {{ article.locale_date }}
            </time>
        </div>
    </header>
    
    <div class="entry-content">
        {{ article.content }}
    </div>
</article>
{% endblock %}
EOF
fi

if [ ! -f "themes/simple/templates/page.html" ]; then
    echo "Creating page.html template..."
    cat > themes/simple/templates/page.html << 'EOF'
{% extends "base.html" %}
{% block title %}{{ page.title|striptags }} - {{ SITENAME }}{% endblock %}

{% block content %}
<article>
    <header>
        <h1>{{ page.title }}</h1>
    </header>
    
    <div class="entry-content">
        {{ page.content }}
    </div>
</article>
{% endblock %}
EOF
fi

if [ ! -f "themes/simple/templates/index.html" ]; then
    echo "Creating index.html template..."
    cat > themes/simple/templates/index.html << 'EOF'
{% extends "base.html" %}
{% block content %}
{% block content_title %}{% endblock %}

{% for article in articles_page.object_list %}
<article>
    <h2><a href="{{ SITEURL }}/{{ article.url }}">{{ article.title }}</a></h2>
    <div class="summary">{{ article.summary }}</div>
</article>
{% endfor %}

{% include 'pagination.html' %}
{% endblock content %}
EOF
fi

if [ ! -f "themes/simple/templates/pagination.html" ]; then
    echo "Creating pagination.html template..."
    cat > themes/simple/templates/pagination.html << 'EOF'
{% if articles_page and articles_paginator.num_pages > 1 %}
<div class="pagination">
    {% if articles_page.has_previous() %}
        <a class="prev" href="{{ SITEURL }}/{{ articles_previous_page.url }}">Prev</a>
    {% endif %}
    Page {{ articles_page.number }} / {{ articles_paginator.num_pages }}
    {% if articles_page.has_next() %}
        <a class="next" href="{{ SITEURL }}/{{ articles_next_page.url }}">Next</a>
    {% endif %}
</div>
{% endif %}
EOF
fi

# Create a basic CSS file if it doesn't exist
if [ ! -f "themes/simple/static/css/style.css" ]; then
    echo "Creating CSS file..."
    cat > themes/simple/static/css/style.css << 'EOF'
body {
    font-family: 'Roboto', sans-serif;
    line-height: 1.6;
    color: #333;
}
h1, h2, h3, h4, h5, h6 {
    margin-top: 1.5rem;
    margin-bottom: 1rem;
}
pre {
    background-color: #f5f5f5;
    padding: 15px;
    border-radius: 5px;
    overflow-x: auto;
}
code {
    background-color: #f5f5f5;
    padding: 2px 4px;
    border-radius: 3px;
}
.navbar {
    margin-bottom: 20px;
}
.navbar-brand .course-title {
    color: white;
    margin: 0;
    font-size: 1.5rem;
}
footer {
    margin-top: 30px;
    padding: 20px 0;
    text-align: center;
}
EOF
fi

# Create empty tipuesearch files if they don't exist
echo "Setting up tipuesearch files..."
[ ! -f "themes/simple/static/tipuesearch/tipuesearch.css" ] && echo "/* Tipue Search CSS */" > themes/simple/static/tipuesearch/tipuesearch.css
[ ! -f "themes/simple/static/tipuesearch/tipuesearch_set.js" ] && echo "/* Tipue Search JS Set */" > themes/simple/static/tipuesearch/tipuesearch_set.js
[ ! -f "themes/simple/static/tipuesearch/tipuesearch.min.js" ] && echo "/* Tipue Search JS */" > themes/simple/static/tipuesearch/tipuesearch.min.js

# Create a minimal pelicanconf.py only if it doesn't exist
if [ ! -f "pelicanconf.py" ]; then
    echo "Creating a minimal pelicanconf.py for our build..."
    cat > pelicanconf.py << 'EOF'
#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = 'Hargun Singh Oberoi'
SITENAME = 'Generative AI for Professionals'
SITEURL = ''

PATH = 'content'
OUTPUT_PATH = 'docs'

TIMEZONE = 'America/New_York'
DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = ()

# Social widget
SOCIAL = ()

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

# Theme settings
THEME = 'themes/simple'
COURSE_NAME = 'Generative AI for Professionals'
COLOR = '#89CFF0'
YEAR = '2023'
TIPUE_SEARCH = True

# Menu Items
MENUITEMS = [
    ('Syllabus', 'pages/syllabus.html'),
    ('Schedule', 'pages/schedule.html'),
    ('Materials', 'pages/materials.html'),
    ('Chapters', 'pages/chapters.html'),
    ('GitHub', 'pages/github.html')
]

# Static paths
STATIC_PATHS = ['images']

# Plugins
PLUGIN_PATHS = ['plugins']
PLUGINS = ['tipue_search']

# Ignore jupyter notebooks to avoid errors
IGNORE_FILES = ['.ipynb_checkpoints', 'README.md', '*.html', '*.ipynb']
EOF
fi

# Try to build the site with the existing config
echo "Building static site with Pelican..."
if ! pelican content -o docs -s pelicanconf.py; then
    echo "Error building the site with Pelican. Check the error messages above."
    exit 1
fi

echo "Site built successfully! Output is in the 'docs' directory."
echo "To view the site locally, run: cd docs && python -m http.server"

# Deactivate virtual environment
deactivate

# start a dev server with docs
echo "Starting development server..."
http-server docs



