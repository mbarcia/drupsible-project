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
