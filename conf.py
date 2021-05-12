# -*- coding: utf-8 -*-
#
# sheffield_hpc documentation build configuration file, created by
# sphinx-quickstart on Tue Mar 31 11:40:21 2015.
#

import sys
import os
import shlex

import glob
import shutil

# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
]

# Add any paths that contain templates here, relative to this directory.
# templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'Sheffield HPC Documentation'
copyright = u'2021, The University of Sheffield'
author = u'The University of Sheffield'

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = ''
# The full version, including alpha/beta/rc tags.
release = ''

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = ['_build', 'themes', 'README.rst','global.rst']

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False


# -- Options for HTML output ----------------------------------------------

import sphinx_rtd_theme
html_theme = 'sheffieldhpc'
html_theme_path = ['themes'] + [sphinx_rtd_theme.get_html_theme_path()]
html_theme_options = {
    'style_external_links': True,
    'canonical_url': 'https://docs.hpc.sheffield.ac.uk',
}

# html_theme_options = {'navbar_sidebarrel':False,
#                       'navbar_pagenav': False,
#                       'source_link_position': False,
#                       'bootswatch_theme': 'flatly',
#                       'navbar_site_name': "Sheffield HPC Documentation",
#                       'navbar_title': ' ',
#                       'navbar_links': [
#                           ("Home", "index"),
#                           ("Research Computing @ IT Services", "https://www.shef.ac.uk/it-services/research", True),
#                           ("Research Software Engineering @ TUOS", "https://rse.shef.ac.uk", True)
#                       ],
#                       'globaltoc_depth': 1}

#html_sidebars = {'software/**': ['softwaretoc.html'],
#                 'gpu/**': ['softwaretoc.html'],
#                 'using-iceberg/**': ['softwaretoc.html'],
#                 'index': []}

#html_sidebars = {'**': ['softwaretoc.html']}

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
html_title = 'Sheffield HPC Documentation'

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
html_logo = 'themes/sheffieldhpc/static/img/crest-l.gif'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['./_static']
html_css_files = [
    'css/custom.css',
]

# Output file base name for HTML help builder.
htmlhelp_basename = 'hpcdoc'

# Hide 'view page source' link
html_show_sourcelink = False

# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, 'iceberg', u'Sheffield HPC Documentation',
     [author], 1)
]


# Add the global rst to make substitutions available
rst_prolog = open('global.rst', 'r').read()