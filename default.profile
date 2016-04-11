#!/bin/sh
#
# Set all the needed config values for your webapp.
# Your app name will be the basename of this file.
#
APP_NAME="default"

# This is your web domain, like example.com
DOMAIN=""
# This is your local hostname without the domain, like "local"
HOSTNAME=""
#
DRUPAL_VERSION="8"
#
MULTILINGUAL=""
LANGUAGES=""
#
USE_INSTALL_PROFILE=""
D_O_INSTALL_PROFILE=""
CUSTOM_INSTALL_PROFILE=""
#
# Some install profiles already have all the code
USE_DRUSH_MAKE=""
DRUSH_MAKEFILE=""
#
USE_SITE_INSTALL=""
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
# This is the codebase tarball of your drupal site.
CODEBASE_TARBALL=""
#
# This is the DB dump of your drupal site to import into your local.
DBDUMP=""
#
# This is the sites/default/files tarball of your drupal site to
# import into your local.
FILES_TARBALL=""
#
KEY_FILENAME="~/.ssh/id_rsa"
#
GIT_PROTOCOL=""
#
GIT_SERVER=""
#
GIT_USER=""
#
GIT_PATH=""
#
GIT_PASS=""
#
GIT_BRANCH="master"
#
APP_HTTPS_ENABLED=""
APP_VARNISH_ENABLED=""

# Last reconfigured on:
