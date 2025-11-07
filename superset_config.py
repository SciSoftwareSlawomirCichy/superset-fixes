# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

"""
Apache Superset Configuration File
===================================

This file contains the main configuration for Apache Superset.
Customize these settings according to your environment.
"""

import os
from datetime import timedelta
from typing import Optional

# ---------------------------------------------------------
# Superset specific config
# ---------------------------------------------------------
ROW_LIMIT = 5000

# Flask App Builder configuration
# Your App secret key - used for securely signing the session cookie
# and encrypting sensitive information on the database
# Make sure you are changing this key for your deployment with a strong key.
# You can generate a strong key using: openssl rand -base64 42
SECRET_KEY = os.environ.get("SECRET_KEY", "CHANGE_ME_TO_A_COMPLEX_RANDOM_SECRET")

# The SQLAlchemy connection string to your database backend
# This connection defines where your metadata database is stored
# Examples:
# - SQLite: sqlite:////path/to/superset.db
# - PostgreSQL: postgresql://user:password@localhost/dbname
# - MySQL: mysql://user:password@localhost/dbname
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL", "sqlite:////app/superset.db"
)

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True

# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = []

# A CSRF token that expires in 1 year
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365

# Set this API key to enable Mapbox visualizations
MAPBOX_API_KEY = os.environ.get("MAPBOX_API_KEY", "")

# ---------------------------------------------------------
# Cache Configuration
# ---------------------------------------------------------
# Flask-Caching configuration
CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_URL": os.environ.get("REDIS_URL", "redis://localhost:6379/0"),
}

# Cache for datasource metadata
DATA_CACHE_CONFIG = CACHE_CONFIG.copy()

# ---------------------------------------------------------
# Security Configuration
# ---------------------------------------------------------
# The allowed origins for CORS
ENABLE_CORS = True
CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["*"],
    "origins": os.environ.get("CORS_ORIGINS", "*").split(","),
}

# ---------------------------------------------------------
# Authentication Configuration
# ---------------------------------------------------------
# Setup authentication type
# AUTH_USER_REGISTRATION = True
# AUTH_USER_REGISTRATION_ROLE = "Public"

# Uncomment to setup OpenID provider example
# OPENID_PROVIDERS = [
#     {
#         "name": "google",
#         "icon": "fa-google",
#         "token_key": "access_token",
#         "remote_app": {
#             "client_id": os.environ.get("GOOGLE_KEY"),
#             "client_secret": os.environ.get("GOOGLE_SECRET"),
#             "api_base_url": "https://www.googleapis.com/oauth2/v2/",
#             "client_kwargs": {"scope": "email profile"},
#             "request_token_url": None,
#             "access_token_url": "https://accounts.google.com/o/oauth2/token",
#             "authorize_url": "https://accounts.google.com/o/oauth2/auth",
#         },
#     }
# ]

# ---------------------------------------------------------
# Feature Flags
# ---------------------------------------------------------
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True,
    "DASHBOARD_NATIVE_FILTERS_SET": True,
    "EMBEDDABLE_CHARTS": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
}

# ---------------------------------------------------------
# Email Configuration
# ---------------------------------------------------------
# Email server configuration for alerts and reports
SMTP_HOST = os.environ.get("SMTP_HOST", "localhost")
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = os.environ.get("SMTP_USER", "")
SMTP_PORT = int(os.environ.get("SMTP_PORT", 25))
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD", "")
SMTP_MAIL_FROM = os.environ.get("SMTP_MAIL_FROM", "superset@example.com")

# ---------------------------------------------------------
# Webdriver Configuration (for chart screenshots)
# ---------------------------------------------------------
# For taking screenshots of charts for alerts/reports
WEBDRIVER_TYPE = os.environ.get("WEBDRIVER_TYPE", "chrome")
WEBDRIVER_OPTION_ARGS = [
    "--force-device-scale-factor=2.0",
    "--high-dpi-support=2.0",
    "--headless",
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-extensions",
]

# ---------------------------------------------------------
# Async Queries Configuration
# ---------------------------------------------------------
# Configuration for async query execution using Celery
RESULTS_BACKEND = None

# Optionally import Celery config
# from celery.schedules import crontab
# CELERY_CONFIG = {
#     "broker_url": os.environ.get("CELERY_BROKER_URL", "redis://localhost:6379/0"),
#     "imports": ("superset.sql_lab", "superset.tasks"),
#     "result_backend": os.environ.get("CELERY_RESULT_BACKEND", "redis://localhost:6379/0"),
#     "worker_prefetch_multiplier": 1,
#     "task_acks_late": False,
#     "beat_schedule": {
#         "reports.scheduler": {
#             "task": "reports.scheduler",
#             "schedule": crontab(minute="*", hour="*"),
#         },
#         "reports.prune_log": {
#             "task": "reports.prune_log",
#             "schedule": crontab(minute=10, hour=0),
#         },
#     },
# }

# ---------------------------------------------------------
# SQL Lab Configuration
# ---------------------------------------------------------
# SQL Lab timeout
SQLLAB_TIMEOUT = int(os.environ.get("SQLLAB_TIMEOUT", 300))

# Async selenium thumbnail task will use the following user
THUMBNAIL_SELENIUM_USER = "admin"

# ---------------------------------------------------------
# Logging Configuration
# ---------------------------------------------------------
# Configure your logging level
# LOG_LEVEL = "DEBUG"
LOG_FORMAT = "%(asctime)s:%(levelname)s:%(name)s:%(message)s"
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

# ---------------------------------------------------------
# Additional Configuration
# ---------------------------------------------------------
# The default language
BABEL_DEFAULT_LOCALE = os.environ.get("BABEL_DEFAULT_LOCALE", "en")

# Allowed languages
LANGUAGES = {
    "en": {"flag": "us", "name": "English"},
    "pl": {"flag": "pl", "name": "Polish"},
    "es": {"flag": "es", "name": "Spanish"},
    "it": {"flag": "it", "name": "Italian"},
    "fr": {"flag": "fr", "name": "French"},
    "de": {"flag": "de", "name": "German"},
    "pt": {"flag": "pt", "name": "Portuguese"},
    "pt_BR": {"flag": "br", "name": "Brazilian Portuguese"},
    "zh": {"flag": "cn", "name": "Chinese"},
    "ja": {"flag": "jp", "name": "Japanese"},
    "ru": {"flag": "ru", "name": "Russian"},
}

# Allow for javascript controls components
# This enables programmers to customize certain charts
# (like the table visualization) with javascript code
ENABLE_JAVASCRIPT_CONTROLS = False

# App name and icon
APP_NAME = "Superset"
APP_ICON = "/static/assets/images/superset-logo-horiz.png"

# Specify the App icon width
APP_ICON_WIDTH = 126

# Druid query timezone
# DRUID_TZ = "UTC"
# DRUID_ANALYSIS_TYPES = ["cardinality"]

# Time grain configurations
# Uncomment and customize the following as needed
# TIME_GRAIN_ADDONS = {"PT1S": "1 second"}
# TIME_GRAIN_ADDON_EXPRESSIONS = {
#     "mysql": {
#         "PT1S": "DATE_ADD(DATE_ADD(hour, INTERVAL HOUR(%(col)s) HOUR), "
#         "INTERVAL SECOND(%(col)s) SECOND)"
#     }
# }

# Additional middleware
# ADDITIONAL_MIDDLEWARE = []

# Health check endpoint
# HEALTH_CHECK_ENDPOINT = "/health"
