Release Notes - Drupsible - Version 1.0

## Task

*   [[DRUPSIBLE-138](https://drupsible.atlassian.net/browse/DRUPSIBLE-138)] - Move Twig's C extension to its own role
*   [[DRUPSIBLE-164](https://drupsible.atlassian.net/browse/DRUPSIBLE-164)] - Prefix some more vars
*   [[DRUPSIBLE-174](https://drupsible.atlassian.net/browse/DRUPSIBLE-174)] - Enable memcache_storage also for D8
*   [[DRUPSIBLE-175](https://drupsible.atlassian.net/browse/DRUPSIBLE-175)] - Add no_log to tasks/templates with secrets
*   [[DRUPSIBLE-178](https://drupsible.atlassian.net/browse/DRUPSIBLE-178)] - Fix warning
*   [[DRUPSIBLE-184](https://drupsible.atlassian.net/browse/DRUPSIBLE-184)] - Rename webdomain to app_webdomain
*   [[DRUPSIBLE-193](https://drupsible.atlassian.net/browse/DRUPSIBLE-193)] - update settings.php to D8.1
*   [[DRUPSIBLE-203](https://drupsible.atlassian.net/browse/DRUPSIBLE-203)] - Upgrade drupsible-vm (normal and large) to Debian Jessie 8.4 and Ansible 2.0.2.0
*   [[DRUPSIBLE-204](https://drupsible.atlassian.net/browse/DRUPSIBLE-204)] - Upgrade to latest version of debops.php5
*   [[DRUPSIBLE-207](https://drupsible.atlassian.net/browse/DRUPSIBLE-207)] - Remove previous workaround
*   [[DRUPSIBLE-218](https://drupsible.atlassian.net/browse/DRUPSIBLE-218)] - Replace admin for user 1, as admin is not always the user 1 name
*   [[DRUPSIBLE-221](https://drupsible.atlassian.net/browse/DRUPSIBLE-221)] - Improve messages and don't ask for SSH key if doing tarballs
*   [[DRUPSIBLE-222](https://drupsible.atlassian.net/browse/DRUPSIBLE-222)] - Update README for 1.0 release
*   [[DRUPSIBLE-225](https://drupsible.atlassian.net/browse/DRUPSIBLE-225)] - Remove MySQL dependencies (secret/ferm/tcpwrappers)
*   [[DRUPSIBLE-254](https://drupsible.atlassian.net/browse/DRUPSIBLE-254)] - Decouple Drush role variables
*   [[DRUPSIBLE-256](https://drupsible.atlassian.net/browse/DRUPSIBLE-256)] - Upgrade drupsible vm (-large) to Debian Jessie to 8.7.1 and latest vbox guest additions
*   [[DRUPSIBLE-259](https://drupsible.atlassian.net/browse/DRUPSIBLE-259)] - Get the Samba share back (reloaded)
*   [[DRUPSIBLE-260](https://drupsible.atlassian.net/browse/DRUPSIBLE-260)] - Better structure dependencies with tags
*   [[DRUPSIBLE-261](https://drupsible.atlassian.net/browse/DRUPSIBLE-261)] - Provision Drupsible VM
*   [[DRUPSIBLE-266](https://drupsible.atlassian.net/browse/DRUPSIBLE-266)] - Optimize mysql
*   [[DRUPSIBLE-267](https://drupsible.atlassian.net/browse/DRUPSIBLE-267)] - Make skipping tcpwrappers and ferm roles the default playbook behavior in local
*   [[DRUPSIBLE-269](https://drupsible.atlassian.net/browse/DRUPSIBLE-269)] - Support BigPipe
*   [[DRUPSIBLE-273](https://drupsible.atlassian.net/browse/DRUPSIBLE-273)] - Upgrade to Ansible Container 0.3.0
*   [[DRUPSIBLE-274](https://drupsible.atlassian.net/browse/DRUPSIBLE-274)] - I want smtp settings to be generated automatically from configure.sh
*   [[DRUPSIBLE-275](https://drupsible.atlassian.net/browse/DRUPSIBLE-275)] - Upgrade Drupsible to Ansible 2.3

## Bug

*   [[DRUPSIBLE-167](https://drupsible.atlassian.net/browse/DRUPSIBLE-167)] - Varnish control key must be stored per host, not per app
*   [[DRUPSIBLE-170](https://drupsible.atlassian.net/browse/DRUPSIBLE-170)] - DOMAIN is not regex-replaced correctly after the first time
*   [[DRUPSIBLE-183](https://drupsible.atlassian.net/browse/DRUPSIBLE-183)] - Fix firewall issues with the Samba access
*   [[DRUPSIBLE-189](https://drupsible.atlassian.net/browse/DRUPSIBLE-189)] - Fix memcache config for D8
*   [[DRUPSIBLE-220](https://drupsible.atlassian.net/browse/DRUPSIBLE-220)] - vagrant up fails when box_url not given (which is not the default)
*   [[DRUPSIBLE-226](https://drupsible.atlassian.net/browse/DRUPSIBLE-226)] - Fix and improve ssh-agent.ssh
*   [[DRUPSIBLE-230](https://drupsible.atlassian.net/browse/DRUPSIBLE-230)] - Fix reverse proxy headers
*   [[DRUPSIBLE-231](https://drupsible.atlassian.net/browse/DRUPSIBLE-231)] - tcpwrappers locked me out of the VM
*   [[DRUPSIBLE-239](https://drupsible.atlassian.net/browse/DRUPSIBLE-239)] - Fix sed in OSX
*   [[DRUPSIBLE-241](https://drupsible.atlassian.net/browse/DRUPSIBLE-241)] - Fatal error due to undefined vars deploy_modules_present_app and deploy_modules_absent_app
*   [[DRUPSIBLE-245](https://drupsible.atlassian.net/browse/DRUPSIBLE-245)] - Random IP generation broken
*   [[DRUPSIBLE-246](https://drupsible.atlassian.net/browse/DRUPSIBLE-246)] - Fix timezone detection in OSX
*   [[DRUPSIBLE-249](https://drupsible.atlassian.net/browse/DRUPSIBLE-249)] - composer install runs out of memory
*   [[DRUPSIBLE-250](https://drupsible.atlassian.net/browse/DRUPSIBLE-250)] - Keep up with varnishlog being removed from Debian pkg in 4.1
*   [[DRUPSIBLE-251](https://drupsible.atlassian.net/browse/DRUPSIBLE-251)] - varnish_app_name cannot contain hyphens
*   [[DRUPSIBLE-264](https://drupsible.atlassian.net/browse/DRUPSIBLE-264)] - Config sync directory
*   [[DRUPSIBLE-265](https://drupsible.atlassian.net/browse/DRUPSIBLE-265)] - Error on pki role while provisioning
*   [[DRUPSIBLE-283](https://drupsible.atlassian.net/browse/DRUPSIBLE-283)] - Deploy disrupted by securepages
*   [[DRUPSIBLE-284](https://drupsible.atlassian.net/browse/DRUPSIBLE-284)] - Postfix fails when /etc/postifx/sasl does not exist
*   [[DRUPSIBLE-285](https://drupsible.atlassian.net/browse/DRUPSIBLE-285)] - pyopenssl needs upgrade
*   [[DRUPSIBLE-286](https://drupsible.atlassian.net/browse/DRUPSIBLE-286)] - missing square brackets

## Story

*   [[DRUPSIBLE-37](https://drupsible.atlassian.net/browse/DRUPSIBLE-37)] - I want Varnish to cache and serve disencrypted HTTPS requests
*   [[DRUPSIBLE-53](https://drupsible.atlassian.net/browse/DRUPSIBLE-53)] - Support D8 caching
*   [[DRUPSIBLE-139](https://drupsible.atlassian.net/browse/DRUPSIBLE-139)] - Add source/upstream configuration to be entered from the beginning with configure.sh
*   [[DRUPSIBLE-141](https://drupsible.atlassian.net/browse/DRUPSIBLE-141)] - Make homepage redirection not be the default in case of i18n sites
*   [[DRUPSIBLE-157](https://drupsible.atlassian.net/browse/DRUPSIBLE-157)] - I want to decide whether or not to change the admin password once deployed
*   [[DRUPSIBLE-158](https://drupsible.atlassian.net/browse/DRUPSIBLE-158)] - I want to tell deploy_xdebug_enabled (per target environment) instead of having an app_xdebug_targets list
*   [[DRUPSIBLE-159](https://drupsible.atlassian.net/browse/DRUPSIBLE-159)] - I want more in-line help when configuring the app for the first time.
*   [[DRUPSIBLE-160](https://drupsible.atlassian.net/browse/DRUPSIBLE-160)] - I want to decide whether translations are updated, per environment
*   [[DRUPSIBLE-161](https://drupsible.atlassian.net/browse/DRUPSIBLE-161)] - I want to make my D8 website accessible through HTTPS, like I do with my D7 sites
*   [[DRUPSIBLE-163](https://drupsible.atlassian.net/browse/DRUPSIBLE-163)] - I want to build my D8 project using composer
*   [[DRUPSIBLE-166](https://drupsible.atlassian.net/browse/DRUPSIBLE-166)] - I want an alias for the playbooks so my life is easier
*   [[DRUPSIBLE-168](https://drupsible.atlassian.net/browse/DRUPSIBLE-168)] - I need to update Composer's checksum
*   [[DRUPSIBLE-169](https://drupsible.atlassian.net/browse/DRUPSIBLE-169)] - Remove vagrant-cachier plugin from Vagrantfile
*   [[DRUPSIBLE-171](https://drupsible.atlassian.net/browse/DRUPSIBLE-171)] - I want improvements to the wizard bin/configure.sh
*   [[DRUPSIBLE-172](https://drupsible.atlassian.net/browse/DRUPSIBLE-172)] - I want to specify the local hostname
*   [[DRUPSIBLE-173](https://drupsible.atlassian.net/browse/DRUPSIBLE-173)] - I want to improve the injection of config into settings.php
*   [[DRUPSIBLE-176](https://drupsible.atlassian.net/browse/DRUPSIBLE-176)] - I want to use varnishlog and varnishncsa too
*   [[DRUPSIBLE-177](https://drupsible.atlassian.net/browse/DRUPSIBLE-177)] - I want to use Varnish latest version 4.1 (has xhkey for D8 caching and 8.1's big pipe)
*   [[DRUPSIBLE-179](https://drupsible.atlassian.net/browse/DRUPSIBLE-179)] - As a new user, I want to easily enable SMTP from the beginning, so that my Drupal app can send out emails
*   [[DRUPSIBLE-180](https://drupsible.atlassian.net/browse/DRUPSIBLE-180)] - I want to install the new Drupal 8.1
*   [[DRUPSIBLE-181](https://drupsible.atlassian.net/browse/DRUPSIBLE-181)] - I want my git password stored outside main app.profile and YAML config files
*   [[DRUPSIBLE-182](https://drupsible.atlassian.net/browse/DRUPSIBLE-182)] - Fine-tune Varnish probe parameters
*   [[DRUPSIBLE-185](https://drupsible.atlassian.net/browse/DRUPSIBLE-185)] - I don't want composer version to change, unless I want it to be a specific one
*   [[DRUPSIBLE-186](https://drupsible.atlassian.net/browse/DRUPSIBLE-186)] - I want to be asked about the VM's IP (static or dynamic)
*   [[DRUPSIBLE-187](https://drupsible.atlassian.net/browse/DRUPSIBLE-187)] - I want to specify guest param in vagrant.yml for all providers (and some guidance) (was: I want to be asked about the VM box (normal or large or custom)
*   [[DRUPSIBLE-197](https://drupsible.atlassian.net/browse/DRUPSIBLE-197)] - Inform real client IP in access log
*   [[DRUPSIBLE-198](https://drupsible.atlassian.net/browse/DRUPSIBLE-198)] - I want feedback of the defaults when running configure.sh
*   [[DRUPSIBLE-199](https://drupsible.atlassian.net/browse/DRUPSIBLE-199)] - Add shallow-clone option to drush make
*   [[DRUPSIBLE-208](https://drupsible.atlassian.net/browse/DRUPSIBLE-208)] - Support PHP7 and PHP5 in debops.php
*   [[DRUPSIBLE-209](https://drupsible.atlassian.net/browse/DRUPSIBLE-209)] - Support PHP7 and PHP5 in drupsible.apache2 in Xenial
*   [[DRUPSIBLE-210](https://drupsible.atlassian.net/browse/DRUPSIBLE-210)] - Support PHP7 and PHP5 in drupsible.deploy in Xenial
*   [[DRUPSIBLE-211](https://drupsible.atlassian.net/browse/DRUPSIBLE-211)] - Support PHP7 and PHP5 in drupsible.memcached in Xenial
*   [[DRUPSIBLE-212](https://drupsible.atlassian.net/browse/DRUPSIBLE-212)] - Support drupsible.mysql in Xenial
*   [[DRUPSIBLE-213](https://drupsible.atlassian.net/browse/DRUPSIBLE-213)] - Support PHP7 and PHP5 in drupsible.newrelic in Xenial
*   [[DRUPSIBLE-214](https://drupsible.atlassian.net/browse/DRUPSIBLE-214)] - Support PHP7 and PHP5 in drupsible.project in Xenial
*   [[DRUPSIBLE-215](https://drupsible.atlassian.net/browse/DRUPSIBLE-215)] - Support PHP7 and PHP5 in drupsible.twigc in Xenial
*   [[DRUPSIBLE-216](https://drupsible.atlassian.net/browse/DRUPSIBLE-216)] - Support PHP7 and PHP5 in drupsible.uploadprogress in Xenial
*   [[DRUPSIBLE-217](https://drupsible.atlassian.net/browse/DRUPSIBLE-217)] - Support PHP7 and PHP5 in drupsible.xdebug in Xenial
*   [[DRUPSIBLE-219](https://drupsible.atlassian.net/browse/DRUPSIBLE-219)] - I want to have drupal console available in Drupal 8 (as it happens with drush)
*   [[DRUPSIBLE-223](https://drupsible.atlassian.net/browse/DRUPSIBLE-223)] - As a first-time user, I want to have /etc/host automatically edited for me
*   [[DRUPSIBLE-228](https://drupsible.atlassian.net/browse/DRUPSIBLE-228)] - Upon vagrant up, I want a 3-tier architecture, with one host per tier
*   [[DRUPSIBLE-229](https://drupsible.atlassian.net/browse/DRUPSIBLE-229)] - Configure "Logging and errors" to use syslog
*   [[DRUPSIBLE-233](https://drupsible.atlassian.net/browse/DRUPSIBLE-233)] - Enable Varnish to be run inside a docker container
*   [[DRUPSIBLE-234](https://drupsible.atlassian.net/browse/DRUPSIBLE-234)] - Prevent httpoxy
*   [[DRUPSIBLE-235](https://drupsible.atlassian.net/browse/DRUPSIBLE-235)] - Enable Apache2 and the other deploy roles to be run inside a docker container
*   [[DRUPSIBLE-236](https://drupsible.atlassian.net/browse/DRUPSIBLE-236)] - Enable MySQL to be run inside a docker container
*   [[DRUPSIBLE-238](https://drupsible.atlassian.net/browse/DRUPSIBLE-238)] - Enable memcache_storage default
*   [[DRUPSIBLE-240](https://drupsible.atlassian.net/browse/DRUPSIBLE-240)] - Provide a variable for root folder inside the codebase repo
*   [[DRUPSIBLE-242](https://drupsible.atlassian.net/browse/DRUPSIBLE-242)] - Add variable to customize drush contrib dir
*   [[DRUPSIBLE-244](https://drupsible.atlassian.net/browse/DRUPSIBLE-244)] - Improved management of SSH
*   [[DRUPSIBLE-247](https://drupsible.atlassian.net/browse/DRUPSIBLE-247)] - Remove Pageant req
*   [[DRUPSIBLE-248](https://drupsible.atlassian.net/browse/DRUPSIBLE-248)] - Replace external samba share by Vagrant's sync'ed folder
*   [[DRUPSIBLE-252](https://drupsible.atlassian.net/browse/DRUPSIBLE-252)] - Configurable drupal log rotation
*   [[DRUPSIBLE-253](https://drupsible.atlassian.net/browse/DRUPSIBLE-253)] - Allow to opt-out of features requiring fixed IPs in Varnish and Apache
*   [[DRUPSIBLE-255](https://drupsible.atlassian.net/browse/DRUPSIBLE-255)] - I want to be able to opt-out of creating a hotfix branch
*   [[DRUPSIBLE-268](https://drupsible.atlassian.net/browse/DRUPSIBLE-268)] - Enable deployment to work inside a docker container
*   [[DRUPSIBLE-270](https://drupsible.atlassian.net/browse/DRUPSIBLE-270)] - I want to export and import D8 configuration as part of the deployments to different environments.
*   [[DRUPSIBLE-271](https://drupsible.atlassian.net/browse/DRUPSIBLE-271)] - As a sysadmin, I want to ensure CHANGELOG.txt isn't readable by the public
*   [[DRUPSIBLE-272](https://drupsible.atlassian.net/browse/DRUPSIBLE-272)] - I want latest version of drupal-console installed by default
*   [[DRUPSIBLE-276](https://drupsible.atlassian.net/browse/DRUPSIBLE-276)] - As a sysadmin I want to easily configure and deploy any drupal module and its requirements
*   [[DRUPSIBLE-282](https://drupsible.atlassian.net/browse/DRUPSIBLE-282)] - As a developer, I want to specify a prefix for my database tables

Release Notes - Drupsible - Version 0.9.9

## Tasks

* [[DRUPSIBLE-106](https://drupsible.atlassian.net/browse/DRUPSIBLE-106)] - Check compatibility
* [[DRUPSIBLE-112](https://drupsible.atlassian.net/browse/DRUPSIBLE-112)] - Upgrade PKI role to its newest release
* [[DRUPSIBLE-120](https://drupsible.atlassian.net/browse/DRUPSIBLE-120)] - Release memcached role to Ansible Galaxy
* [[DRUPSIBLE-121](https://drupsible.atlassian.net/browse/DRUPSIBLE-121)] - Release composer role to Ansible Galaxy
* [[DRUPSIBLE-122](https://drupsible.atlassian.net/browse/DRUPSIBLE-122)] - Reorganize playbooks and groups of hosts in the inventory. Remove hard deps of Varnish and release it on Ansible Galaxy.
* [[DRUPSIBLE-123](https://drupsible.atlassian.net/browse/DRUPSIBLE-123)] - Release newrelic role to Ansible Galaxy
* [[DRUPSIBLE-124](https://drupsible.atlassian.net/browse/DRUPSIBLE-124)] - Update drush versions for D7 and D8
* [[DRUPSIBLE-133](https://drupsible.atlassian.net/browse/DRUPSIBLE-133)] - Improve drupsible's "enable/disable modules"
* [[DRUPSIBLE-134](https://drupsible.atlassian.net/browse/DRUPSIBLE-134)] - Provide ability to ignore errors of drush make
* [[DRUPSIBLE-136](https://drupsible.atlassian.net/browse/DRUPSIBLE-136)] - Improved handling of Drupal versions
* [[DRUPSIBLE-143](https://drupsible.atlassian.net/browse/DRUPSIBLE-143)] - Normalize passwords location under secret folder
* [[DRUPSIBLE-144](https://drupsible.atlassian.net/browse/DRUPSIBLE-144)] - Skip copy of vagrant.yml and ansible.cfg if exists
* [[DRUPSIBLE-147](https://drupsible.atlassian.net/browse/DRUPSIBLE-147)] - Make app_env values all scalar, to simplify the configuration needed
* [[DRUPSIBLE-154](https://drupsible.atlassian.net/browse/DRUPSIBLE-154)] - Tidy up apache2 role
* [[DRUPSIBLE-155](https://drupsible.atlassian.net/browse/DRUPSIBLE-155)] - Replace sudo by become

## Bugs

* [[DRUPSIBLE-30](https://drupsible.atlassian.net/browse/DRUPSIBLE-30)] - Ansible bug in unarchive module for non-ASCII chars in filenames
* [[DRUPSIBLE-111](https://drupsible.atlassian.net/browse/DRUPSIBLE-111)] - deploy.yml playbook fails on apt dependency of newrelic role (with_items receives an empty var)
* [[DRUPSIBLE-114](https://drupsible.atlassian.net/browse/DRUPSIBLE-114)] - On Ansible 2, debops.pki role fails restart ferm
* [[DRUPSIBLE-115](https://drupsible.atlassian.net/browse/DRUPSIBLE-115)] - Varnish fail to start due to port in use by apache2
* [[DRUPSIBLE-127](https://drupsible.atlassian.net/browse/DRUPSIBLE-127)] - A few minor bugs in D8
* [[DRUPSIBLE-135](https://drupsible.atlassian.net/browse/DRUPSIBLE-135)] - Varnish virtual hosts task do not work well
* [[DRUPSIBLE-145](https://drupsible.atlassian.net/browse/DRUPSIBLE-145)] - Logrotate (daily): duplicate log entry for drupal.log
* [[DRUPSIBLE-146](https://drupsible.atlassian.net/browse/DRUPSIBLE-146)] - Fix db clone
* [[DRUPSIBLE-152](https://drupsible.atlassian.net/browse/DRUPSIBLE-152)] - New Relic sysmond not started after Drupsible playbooks ran

## Stories

* [[DRUPSIBLE-52](https://drupsible.atlassian.net/browse/DRUPSIBLE-52)] - Support drush make in custom profiles
* [[DRUPSIBLE-72](https://drupsible.atlassian.net/browse/DRUPSIBLE-72)] - Install xdebug
* [[DRUPSIBLE-73](https://drupsible.atlassian.net/browse/DRUPSIBLE-73)] - Install uploadprogress
* [[DRUPSIBLE-83](https://drupsible.atlassian.net/browse/DRUPSIBLE-83)] - get_url instead of curl
* [[DRUPSIBLE-102](https://drupsible.atlassian.net/browse/DRUPSIBLE-102)] - Configure full backups per target environment
* [[DRUPSIBLE-103](https://drupsible.atlassian.net/browse/DRUPSIBLE-103)] - Upgrade to users v0.1.5
* [[DRUPSIBLE-105](https://drupsible.atlassian.net/browse/DRUPSIBLE-105)] - Remove workaround now Vagrant 1.8 is out (and enforce the new version)
* [[DRUPSIBLE-107](https://drupsible.atlassian.net/browse/DRUPSIBLE-107)] - Upgrade Drupsible VM to Ansible 2
* [[DRUPSIBLE-109](https://drupsible.atlassian.net/browse/DRUPSIBLE-109)] - Document Samba role
* [[DRUPSIBLE-110](https://drupsible.atlassian.net/browse/DRUPSIBLE-110)] - set/force location for downloading modules with drush dl
* [[DRUPSIBLE-116](https://drupsible.atlassian.net/browse/DRUPSIBLE-116)] - Update apache vhost common definition, as per new .htaccess in D7.42
* [[DRUPSIBLE-117](https://drupsible.atlassian.net/browse/DRUPSIBLE-117)] - Improvements to requirements.default.yml for the new galaxy
* [[DRUPSIBLE-118](https://drupsible.atlassian.net/browse/DRUPSIBLE-118)] - Replace hard role dependencies of apache2
* [[DRUPSIBLE-125](https://drupsible.atlassian.net/browse/DRUPSIBLE-125)] - Switch drush defaults to use Drupal 8
* [[DRUPSIBLE-126](https://drupsible.atlassian.net/browse/DRUPSIBLE-126)] - Switch default Drupal version to Drupal 8
* [[DRUPSIBLE-129](https://drupsible.atlassian.net/browse/DRUPSIBLE-129)] - Setup Twig's C extension
* [[DRUPSIBLE-132](https://drupsible.atlassian.net/browse/DRUPSIBLE-132)] - Remove debops.apt, debops.apt_preferences as they are not needed anymore
* [[DRUPSIBLE-148](https://drupsible.atlassian.net/browse/DRUPSIBLE-148)] - Allow to enable Xdebug for PHP-CLI (default disabled)
* [[DRUPSIBLE-149](https://drupsible.atlassian.net/browse/DRUPSIBLE-149)] - I want to forget about the communication method between PHP and Apache2 (socket or port)
* [[DRUPSIBLE-150](https://drupsible.atlassian.net/browse/DRUPSIBLE-150)] - Add HTTPS enabled? and Varnish enabled? questions to configure.sh
* [[DRUPSIBLE-151](https://drupsible.atlassian.net/browse/DRUPSIBLE-151)] - Improve logic and error handling in bin/ssh-agent.sh

# Release Notes - Drupsible - Version 0.9.8

## Bugs

*  [[DRUPSIBLE-61](https://drupsible.atlassian.net/browse/DRUPSIBLE-61)] - Samba does not work after a reboot. ferm service needs to be flushed.
*  [[DRUPSIBLE-100](https://drupsible.atlassian.net/browse/DRUPSIBLE-100)] - Reverse proxy header not properly set
*  [[DRUPSIBLE-101](https://drupsible.atlassian.net/browse/DRUPSIBLE-101)] - Skip full backups setup if not in PROD

## Stories

*  [[DRUPSIBLE-42](https://drupsible.atlassian.net/browse/DRUPSIBLE-42)] - I want to be able to add custom code to Drupal settings.php

# Release Notes - Drupsible - Version 0.9.7

## Bugs

*  [[DRUPSIBLE-99](https://drupsible.atlassian.net/browse/DRUPSIBLE-99)] - New handling of dependencies in debops locked me out of the VM

# Release Notes - Drupsible - Version 0.9.6

## Stories

*  [[DRUPSIBLE-93](https://drupsible.atlassian.net/browse/DRUPSIBLE-93)] - Ability to specify a Git password as a secret
*  [[DRUPSIBLE-95](https://drupsible.atlassian.net/browse/DRUPSIBLE-95)] - Use ControlPersist and pipelining
*  [[DRUPSIBLE-96](https://drupsible.atlassian.net/browse/DRUPSIBLE-96)] - Enable pipelining default
*  [[DRUPSIBLE-98](https://drupsible.atlassian.net/browse/DRUPSIBLE-98)] - Update apache vhost common definition, as per new .htaccess in D7.40

# Release Notes - Drupsible - Version 0.9.5

## Bugs

*  [[DRUPSIBLE-75](https://drupsible.atlassian.net/browse/DRUPSIBLE-75)] - Avoid New Relic PHP Agent being skipped

## Stories

*  [[DRUPSIBLE-52](https://drupsible.atlassian.net/browse/DRUPSIBLE-52)] - Support drush make in custom profiles
*  [[DRUPSIBLE-76](https://drupsible.atlassian.net/browse/DRUPSIBLE-76)] - Customize max_execution_time
*  [[DRUPSIBLE-88](https://drupsible.atlassian.net/browse/DRUPSIBLE-88)] - Provide a random private IP to avoid conflict with other Drupsible projects in the local environment
*  [[DRUPSIBLE-89](https://drupsible.atlassian.net/browse/DRUPSIBLE-89)] - Configure a VM with a larger disk size
*  [[DRUPSIBLE-90](https://drupsible.atlassian.net/browse/DRUPSIBLE-90)] - Reduce VM default disk size to 5G
*  [[DRUPSIBLE-91](https://drupsible.atlassian.net/browse/DRUPSIBLE-91)] - Update VBox Guest Additions ISO version

# Release Notes - Drupsible - Version 0.9.4

## Bugs

*  [[DRUPSIBLE-81](https://drupsible.atlassian.net/browse/DRUPSIBLE-81)] - Fix PKI installation
*  [[DRUPSIBLE-82](https://drupsible.atlassian.net/browse/DRUPSIBLE-82)] - Fix Newrelic PHP Agent configuration
*  [[DRUPSIBLE-85](https://drupsible.atlassian.net/browse/DRUPSIBLE-85)] - drush dl site_audit fails because of home dir
*  [[DRUPSIBLE-87](https://drupsible.atlassian.net/browse/DRUPSIBLE-87)] - Trying to branch when importing

## Stories

*  [[DRUPSIBLE-77](https://drupsible.atlassian.net/browse/DRUPSIBLE-77)] - Ability to disable trusted host pattern (teapot error) in Varnish
*  [[DRUPSIBLE-78](https://drupsible.atlassian.net/browse/DRUPSIBLE-78)] - Ability to specify more paths for piping
*  [[DRUPSIBLE-79](https://drupsible.atlassian.net/browse/DRUPSIBLE-79)] - Customize frequency and quantity of backups
*  [[DRUPSIBLE-84](https://drupsible.atlassian.net/browse/DRUPSIBLE-84)] - Skip base_url and cookie_domain if the webapp spans multiple different domains
*  [[DRUPSIBLE-86](https://drupsible.atlassian.net/browse/DRUPSIBLE-86)] - Copy and decompress codebase tarball failed

# Release Notes - Drupsible - Version 0.9.3

## Bugs

*  [[DRUPSIBLE-70](https://drupsible.atlassian.net/browse/DRUPSIBLE-70)] Escape slashes when expanding paths

## Stories

*  [[DRUPSIBLE-56](https://drupsible.atlassian.net/browse/DRUPSIBLE-56)] Test on Ubuntu Trusty
*  [[DRUPSIBLE-51](https://drupsible.atlassian.net/browse/DRUPSIBLE-51)] Fix backup in OSX
*  [[DRUPSIBLE-63](https://drupsible.atlassian.net/browse/DRUPSIBLE-63)] Varnish 4 and systemd in Debian/Ubuntu
*  [[DRUPSIBLE-63](https://drupsible.atlassian.net/browse/DRUPSIBLE-63)] Varnish 4 and systemd in Ubuntu Trusty
*  [[DRUPSIBLE-69](https://drupsible.atlassian.net/browse/DRUPSIBLE-69)] Varnish does not autostart on systemd

# Release Notes - Drupsible - Version 0.9.2

## Bugs
* [[DRUPSIBLE-46](https://drupsible.atlassian.net/browse/DRUPSIBLE-46)] - shell scripts in bin need x privilege
* [[DRUPSIBLE-47](https://drupsible.atlassian.net/browse/DRUPSIBLE-47)] - SSH agent handling is broken

## Stories
* [[DRUPSIBLE-48](https://drupsible.atlassian.net/browse/DRUPSIBLE-48)] - Add support (experimental) for Drupal 8

# Release Notes - Drupsible - Version 0.9.1
## Stories
* [[DRUPSIBLE-17](https://drupsible.atlassian.net/browse/DRUPSIBLE-17)] - Add specific versions to requirements.default.yml
* [[DRUPSIBLE-22](https://drupsible.atlassian.net/browse/DRUPSIBLE-22)] - Create a Drupsible Controller box for Virtualbox (based upon Debian Jessie)
* [[DRUPSIBLE-44](https://drupsible.atlassian.net/browse/DRUPSIBLE-44)] - I want to easily install a Drupal profile/distribution
* [[DRUPSIBLE-45](https://drupsible.atlassian.net/browse/DRUPSIBLE-45)] - Backups not being done

# Release Notes - Drupsible - Version 0.9
## Stories
* [[DRUPSIBLE-17](https://drupsible.atlassian.net/browse/DRUPSIBLE-17)] - Add specific versions to requirements.default.yml
* [[DRUPSIBLE-23](https://drupsible.atlassian.net/browse/DRUPSIBLE-23)] - I want each deploy to be a new/fresh deploy, but I want to reduce deployment time as much as possible.
* [[DRUPSIBLE-27](https://drupsible.atlassian.net/browse/DRUPSIBLE-27)] - I want my webapp to be able to send email notifications.
* [[DRUPSIBLE-28](https://drupsible.atlassian.net/browse/DRUPSIBLE-28)] - Provide a tarball option for deploying the codebase
* [[DRUPSIBLE-29](https://drupsible.atlassian.net/browse/DRUPSIBLE-29)] - I want to deploy real SSL certificates to the web server.
* [[DRUPSIBLE-31](https://drupsible.atlassian.net/browse/DRUPSIBLE-31)] - I want to configure my Drupal webapp to serve HTTPS
* [[DRUPSIBLE-32](https://drupsible.atlassian.net/browse/DRUPSIBLE-32)] - Fine-tune SSL settings of Apache
* [[DRUPSIBLE-33](https://drupsible.atlassian.net/browse/DRUPSIBLE-33)] - Fix access to Samba share
* [[DRUPSIBLE-34](https://drupsible.atlassian.net/browse/DRUPSIBLE-34)] - I want my webapp to be served faster (using Varnish as a front-end)
* [[DRUPSIBLE-35](https://drupsible.atlassian.net/browse/DRUPSIBLE-35)] - I want to use my own Jinja2 template for the VCL.
* [[DRUPSIBLE-36](https://drupsible.atlassian.net/browse/DRUPSIBLE-36)] - I want to specify an error page.
* [[DRUPSIBLE-38](https://drupsible.atlassian.net/browse/DRUPSIBLE-38)] - I want better mgmt of my configs
* [[DRUPSIBLE-40](https://drupsible.atlassian.net/browse/DRUPSIBLE-40)] - I want to run vagrant up instead of bin/up.sh
* [[DRUPSIBLE-41](https://drupsible.atlassian.net/browse/DRUPSIBLE-41)] - I want users browsers to internally cache all the static content of my webapp

# Release Notes - Drupsible - Version 0.8.5
## Story changelog ##
* [DRUPSIBLE-4](https://drupsible.atlassian.net/browse/DRUPSIBLE-4) - I want to run drupsible immediately on new remote servers
* [DRUPSIBLE-5](https://drupsible.atlassian.net/browse/DRUPSIBLE-5) - I want a solid sshd configuration of the remote servers
* [DRUPSIBLE-6](https://drupsible.atlassian.net/browse/DRUPSIBLE-6) - Create a new config playbook, cutting tasks from the deploy playbook
* [DRUPSIBLE-12](https://drupsible.atlassian.net/browse/DRUPSIBLE-12) - I want my configs to survive code updates from drupsible-project
* [DRUPSIBLE-13](https://drupsible.atlassian.net/browse/DRUPSIBLE-13) - Improve ssh-agent handling in Vagrantfile
* [DRUPSIBLE-24](https://drupsible.atlassian.net/browse/DRUPSIBLE-24) - I want to install a fresh Drupal 7 using any given install profile
* [DRUPSIBLE-26](https://drupsible.atlassian.net/browse/DRUPSIBLE-26) - I want my website accessible through HTTPS in my local.
