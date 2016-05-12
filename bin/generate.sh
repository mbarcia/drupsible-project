#!/bin/bash
#
# Configures Vagrant and Ansible from the Drupsible profile provided.
#

if [ "$1" = "" ] || [ ! -f "$1" ]; then
	echo "Please provide a Drupsible profile."
	exit 1
else
	source "$1"
fi

# First perform a backup
./bin/backup.sh "${APP_NAME}"

#
# Validate tarballs are found, if not, issue a warning message.
#
if [ "$CODEBASE_TARBALL" != "" ] && [ ! -f "ansible/playbooks/codebase-tarballs/$CODEBASE_TARBALL" ]; then
	echo "WARNING: Copy $CODEBASE_TARBALL to ansible/playbooks/codebase-tarballs/"
	echo "======="
fi
if [ "$FILES_TARBALL" != "" ] && [ ! -f "ansible/playbooks/files-tarballs/$FILES_TARBALL" ]; then
	echo "WARNING: Copy $FILES_TARBALL to ansible/playbooks/files-tarballs/"
	echo "======="
fi
if [ "$DBDUMP" != "" ] && [ ! -f "ansible/playbooks/dbdumps/$DBDUMP" ]; then
	echo "WARNING: Please copy $DBDUMP to ansible/playbooks/dbdumps/"
	echo "======="
fi
for file in ".gitignore" "ansible.cfg" "Vagrantfile" "vagrant.yml"
do
if [ ! -f "${file}" ]; then
		cp "${file}".default "${file}"
		if [ "${FILES_LIST}" != "" ]; then
			FILES_LIST="${FILES_LIST}, ${file}"
		else
			FILES_LIST="${file}"
		fi
	fi
done
if [ "${FILES_LIST}" != "" ]; then
	echo "${FILES_LIST} have been created locally for your convenience."
fi
sed -i "s/domain:.*/domain: '${DOMAIN}'/g" vagrant.yml
# Remove any possible app duplicates
sed -i "s|^- name\: '${APP_NAME}'$||g" vagrant.yml
# Add app name to the list
sed -i "/apps\:/a\
- name: '${APP_NAME}'" vagrant.yml
# Remove empty lines
sed -i '/^$/d' vagrant.yml
#
# ansible/requirements.yml
#
if [ ! -f ansible/requirements.yml ]; then
	cp ansible/requirements.default.yml ansible/requirements.yml
	echo "ansible/requirements.yml has been created locally for your convenience.."
fi
#
# Create the inventory file for the local environment
#
for ENV in "-local"
do
	#
	# Inventory file
	#
	if [ ! -f "ansible/inventory/${APP_NAME}${ENV}" ]; then
		cp "ansible/inventory/app_name${ENV}" "ansible/inventory/${APP_NAME}${ENV}"
		# Assign web domain
		sed -i "s/app_webdomain=.*/app_webdomain=${DOMAIN}/g" "ansible/inventory/${APP_NAME}${ENV}"
		# Replace app_name by the actual app name
		sed -i "s/app_name/${APP_NAME}/g" "ansible/inventory/${APP_NAME}${ENV}"
		# Assign hostname
		sed -i "s/app_webhost=.*/app_webhost=${HOSTNAME}/g" "ansible/inventory/${APP_NAME}${ENV}"
	else
		echo "ansible/inventory/${APP_NAME}${ENV} already exists and has not been re-generated: if you have edited this file, double-check its content before proceeding."
	fi
done
#
# Create env directories under playbooks/group_vars
#
for ENV in "" "-local" "-ci" "-qa" "-uat" "-prod"
do
	# Copy/create the group vars directory under playbooks
	mkdir -p "ansible/playbooks/group_vars/${APP_NAME}${ENV}/"
done
#
# Loop through the local + the default, creating the default group vars
#
for ENV in "" "-local"
do
	#
	# Group vars
	#
	# Copy/create the group vars directory with the final config files in it
	mkdir -p "ansible/inventory/group_vars/${APP_NAME}${ENV}/"
	cp -pr "ansible/inventory/group_vars.default/app_name${ENV}/." "ansible/inventory/group_vars/${APP_NAME}${ENV}/"
	cd "ansible/inventory/group_vars/${APP_NAME}${ENV}" || exit 2
	# Perform the regexp replacements in the final config files
	sed -i "s/app_name:.*/app_name: '${APP_NAME}'/g" all.yml
	if [ "$ENV" != "-local" ]; then
		sed -i "s/app_user:.*/app_user: ${APP_NAME}/g" all.yml
	else
		sed -i "s/app_user:.*/app_user: vagrant/g" all.yml
	fi
	sed -i "s/app_drupal_version:.*/app_drupal_version: '${DRUPAL_VERSION}'/g" all.yml
	if [ "$MULTILINGUAL" == "yes" ]; then
		sed -i "s|app_i18n_enabled:.*$|app_i18n_enabled: yes|g" all.yml
		if [ "$LANGUAGES" != "" ]; then
			sed -i "s|app_languages:.*$|app_languages: [ ${LANGUAGES} ]|g" all.yml
		fi
	else
		sed -i "s|app_i18n_enabled:.*$|app_i18n_enabled: no|g" all.yml
	fi
	if [ "$APP_HTTPS_ENABLED" == "yes" ]; then
		sed -i "s|app_https_enabled:.*$|app_https_enabled: yes|g" all.yml
		# Varnish can only be enabled in http (not https)
		sed -i "s|app_varnish_enabled:.*$|app_varnish_enabled: no|g" all.yml
	else
		if [ "$APP_VARNISH_ENABLED" == "yes" ]; then
			sed -i "s|app_varnish_enabled:.*$|app_varnish_enabled: yes|g" all.yml
		else
			sed -i "s|app_varnish_enabled:.*$|app_varnish_enabled: no|g" all.yml
		fi
	fi
	sed -i "s|app_timezone:.*$|app_timezone: '${APP_TIMEZONE}'|g" all.yml
	if [ "$USE_INSTALL_PROFILE" == "yes" ]; then
		sed -i "s/deploy_install_profile_enabled:.*$/deploy_install_profile_enabled: 'yes'/g" deploy.yml
		if [ "$D_O_INSTALL_PROFILE" != "" ]; then
			sed -i "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: '${D_O_INSTALL_PROFILE}'/g" deploy.yml
			sed -i "s/deploy_custom_install_profile:.*$/deploy_custom_install_profile: ''/g" deploy.yml
		elif [ "$CUSTOM_INSTALL_PROFILE" != "" ]; then
			sed -i "s/deploy_custom_install_profile:.*$/deploy_custom_install_profile: '${CUSTOM_INSTALL_PROFILE}'/g" deploy.yml
			sed -i "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: ''/g" deploy.yml
		else
			sed -i "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: standard/g" deploy.yml
		fi
		if [ "$USE_DRUSH_MAKE" == "yes" ]; then
			sed -i "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: 'yes'|g" deploy.yml
			sed -i "s|deploy_composer_enabled:.*$|deploy_composer_enabled: 'no'|g" deploy.yml
			if [ "$DRUSH_MAKEFILE" != "" ]; then
				sed -i "s|deploy_drush_makefile:.*$|deploy_drush_makefile: '${DRUSH_MAKEFILE}'|g" deploy.yml
			fi
		elif [ "$USE_COMPOSER" == "yes" ]; then
			sed -i "s|deploy_composer_enabled:.*$|deploy_composer_enabled: 'yes'|g" deploy.yml
			sed -i "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: 'no'|g" deploy.yml
		else
			sed -i "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: 'no'|g" deploy.yml
			sed -i "s|deploy_composer_enabled:.*$|deploy_composer_enabled: 'no'|g" deploy.yml
		fi
	else
		if [ ! "$CODEBASE_TARBALL" == "" ]; then
			sed -i "s|deploy_codebase_tarball_filename:.*$|deploy_codebase_tarball_filename: '${CODEBASE_TARBALL}'|g" deploy.yml
			sed -i "s|deploy_codebase_import_enabled:.*$|deploy_codebase_import_enabled: yes|g" deploy.yml
		else
			sed -i "s|deploy_codebase_import_enabled:.*$|deploy_codebase_import_enabled: no|g" deploy.yml
		fi
		sed -i "s/deploy_install_profile_enabled:.*$/deploy_install_profile_enabled: 'no'/g" deploy.yml
	fi
	if [ "$USE_UPSTREAM_SITE" == "yes" ]; then
		sed -i "s|deploy_db_sync_enabled:.*$|deploy_db_sync_enabled: '${SYNC_DB}'|g" deploy.yml
		sed -i "s|deploy_files_sync_enabled:.*$|deploy_files_sync_enabled: '${SYNC_FILES}'|g" deploy.yml
		sed -i "s|deploy_upstream_remote_host:.*$|deploy_upstream_remote_host: '${REMOTE_UPSTREAM_HOST}'|g" deploy.yml
		sed -i "s|deploy_upstream_remote_port:.*$|deploy_upstream_remote_port: '${REMOTE_UPSTREAM_PORT}'|g" deploy.yml
		sed -i "s|deploy_upstream_remote_user:.*$|deploy_upstream_remote_user: '${REMOTE_UPSTREAM_USER}'|g" deploy.yml
		sed -i "s|deploy_upstream_docroot:.*$|deploy_upstream_docroot: '${REMOTE_UPSTREAM_DOCROOT}'|g" deploy.yml
		sed -i "s|deploy_upstream_files_path:.*$|deploy_upstream_files_path: '${REMOTE_UPSTREAM_FILES_PATH}'|g" deploy.yml
		sed -i "s|deploy_upstream_proxy_credentials:.*$|deploy_upstream_proxy_credentials: '${REMOTE_UPSTREAM_PROXY_CREDENTIALS}'|g" deploy.yml
		sed -i "s|deploy_upstream_proxy_port:.*$|deploy_upstream_proxy_port: '${REMOTE_UPSTREAM_PROXY_PORT}'|g" deploy.yml
		sed -i "s|deploy_upstream_ssh_options:.*$|deploy_upstream_ssh_options: '${REMOTE_UPSTREAM_SSH_OPTIONS}'|g" deploy.yml
	fi
	if [ "$USE_SITE_INSTALL" == "yes" ]; then
		sed -i "s|deploy_site_install_enabled:.*$|deploy_site_install_enabled: yes|g" deploy.yml
	else
		if [ ! "$DBDUMP" == "" ]; then
			sed -i "s|deploy_db_dump_filename:.*$|deploy_db_dump_filename: '${DBDUMP}'|g" deploy.yml
			sed -i "s|deploy_db_import_enabled:.*$|deploy_db_import_enabled: yes|g" deploy.yml
		else
			sed -i "s|deploy_db_import_enabled:.*$|deploy_db_import_enabled: no|g" deploy.yml
		fi
		if [ ! "$FILES_TARBALL" == "" ]; then
			sed -i "s|deploy_files_tarball_filename:.*$|deploy_files_tarball_filename: '${FILES_TARBALL}'|g" deploy.yml
			sed -i "s|deploy_files_import_enabled:.*$|deploy_files_import_enabled: yes|g" deploy.yml
		else
			sed -i "s|deploy_files_import_enabled:.*$|deploy_files_import_enabled: no|g" deploy.yml
		fi
	fi
	# Git config
	sed -i "s/deploy_git_repo_protocol:.*$/deploy_git_repo_protocol: \"${GIT_PROTOCOL}\"/g" deploy.yml
	sed -i "s/deploy_git_repo_server:.*$/deploy_git_repo_server: \"${GIT_SERVER}\"/g" deploy.yml
	sed -i "s/deploy_git_repo_user:.*$/deploy_git_repo_user: \"${GIT_USER}\"/g" deploy.yml
	sed -i "s|deploy_git_repo_path:.*$|deploy_git_repo_path: \"${GIT_PATH}\"|g" deploy.yml
	sed -i "s|deploy_git_repo_version:.*$|deploy_git_repo_version: \"${GIT_BRANCH}\"|g" deploy.yml
	# Change directory out of group vars
	cd - > /dev/null || exit 2
done
# Finish execution with a final message
echo
echo "-------------------------------------------------------------------------------"
echo "Thank you, all of the Drupsible defaults have been properly generated."
echo "You may override them by creating YAML files under "
echo "ansible/playbooks/groups_vars."
echo
echo "If this is your Ansible controller, refer to the docs to properly run "
echo "ansible-playbook. You may need to run the bootstrap playbook for each host."
echo "If so, have the root password at hand and run:"
echo
echo "ansible-playbook -l <host> -u root -k ansible/playbooks/bootstrap.yml"
echo "-------------------------------------------------------------------------------"
echo "Or, if this is your local environment, just run vagrant up."
echo "                                                =========="
echo "Vagrant will run the drupsible VM by default."
echo "You can edit vagrant.yml to change this and other VM custom config values."
echo "In case vagrant hangs, make sure VT-x/AMD-V is enabled in your BIOS settings."
echo "-------------------------------------------------------------------------------"
