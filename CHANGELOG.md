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
