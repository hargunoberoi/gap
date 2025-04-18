#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = 'Hargun Singh Oberoi'
SITENAME = 'Generative AI for Professionals'
SITEURL = 'https://hargunoberoi.github.io/gap'

PATH = 'content'
OUTPUT_PATH = 'output'

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
RELATIVE_URLS = False

# Theme settings
THEME = 'themes/simple'
COURSE_NAME = 'Generative AI for Professionals'
COLOR = '#89CFF0'
YEAR = '2025'
TIPUE_SEARCH = False

# Menu Items
MENUITEMS = [
    ('Home', './'),
    ('Chapters', 'pages/chapters.html'),
    ('Materials', 'pages/materials.html'),
    ('Tools', 'pages/tools.html')
]

# Static paths
STATIC_PATHS = ['images']

# Plugins
PLUGIN_PATHS = ['plugins']
PLUGINS = []

# Ignore jupyter notebooks to avoid errors
IGNORE_FILES = ['.ipynb_checkpoints', 'README.md', '*.html', '*.ipynb']

# Article URL structure - organize by category
ARTICLE_URL = '{category}/{slug}.html'
ARTICLE_SAVE_AS = '{category}/{slug}.html'

# Category URL structure
CATEGORY_URL = 'category/{slug}.html'
CATEGORY_SAVE_AS = 'category/{slug}.html'
