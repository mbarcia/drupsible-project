#!/bin/sh
#
# Drupsible app profile.
#
# Contains the basic config values for your Drupal application.
#
APP_NAME="d8"

# This is your primary web domain, like 'drupal.org'
DOMAIN="drupsible.org"
# This is your _local_ hostname, without the domain, so the Ansible inventory
# can be generated automatically.
# In all the other upper environments, inventories need to be created manually
# by the user.
HOSTNAME="local"
#
DRUPAL_VERSION="8"
#
MULTILINGUAL="no"
# Enumerate the languages after commas, starting with the default language
# Ie. es,en
LANGUAGES=""
#
USE_INSTALL_PROFILE="yes"
# This can be a core profile (ie. standard, or minimal) or a contrib profile (ie. bear, or thunder)
D_O_INSTALL_PROFILE="standard"
CUSTOM_INSTALL_PROFILE=""
#
USE_DRUSH_MAKE=""
# Ie. build-bear.make
DRUSH_MAKEFILE=""
USE_COMPOSER=""
#
USE_SITE_INSTALL="yes"
#
USE_UPSTREAM_SITE=""
REMOTE_UPSTREAM_HOST=""
REMOTE_UPSTREAM_PORT=""
REMOTE_UPSTREAM_USER=""
REMOTE_UPSTREAM_DOCROOT=""
SYNC_FILES=""
REMOTE_UPSTREAM_FILES_PATH="sites/default/files"
REMOTE_UPSTREAM_PROXY_CREDENTIALS=""
REMOTE_UPSTREAM_PROXY_PORT=""
REMOTE_UPSTREAM_SSH_OPTIONS=""
SYNC_DB=""
#
# This tarball should contain the codebase of your drupal site.
# It can be a tar, a gzip, a bzip2 or a xz.
CODEBASE_TARBALL=""
#
# This is the DB dump of your drupal site to import into your local.
# It is a SQL file, and can be in plain text format, or gzipped
DBDUMP=""
#
# This is the sites/default/files tarball of your drupal site to
# import into your local.
# It can be a tar, a gzip, a bzip2 or a xz.
FILES_TARBALL=""
#
KEY_FILENAME="~/.ssh/id_rsa"
#
# This is usually ssh
GIT_PROTOCOL=""
#
# Ie. bitbucket.org
GIT_SERVER=""
#
# Ie. git
GIT_USER=""
#
GIT_PATH=""
#
GIT_BRANCH="master"
#
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="mariano.barcia"
#
APP_HTTPS_ENABLED="yes"
APP_VARNISH_ENABLED=""
#
APP_TIMEZONE="Europe/London"
#
IP_ADDR="192.168.57.171"
# Last reconfigured on: Wed 15 Feb 04:10:24 2017 GMT
