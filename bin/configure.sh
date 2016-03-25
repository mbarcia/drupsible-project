#!/bin/bash
askyesno () 
{
	while read -r -n 1 -s answer; do
		if [[ $answer = [YyNn] ]]; then
			[[ $answer = [Yy] ]] && retval=0
			[[ $answer = [Nn] ]] && retval=1
    		break
		fi
	done
	echo # just a final linefeed, optics...
	return $retval
}
#
# Chdir to top-level folder if needed.
#
if [ -f "../default.profile" ]; then
	echo "Changed current dir to the project's top level folder, for your convenience."
	cd .. || exit 2
fi
#
# Set APP_NAME.
#
if [ "$1" == "" ]; then
	# Take the folder name as app name, if app-name param has not been given.
	DIR_NAME=${PWD##*/}
	# But remove suffix -drupsible if any.
	PROJ_NAME=${DIR_NAME%-drupsible}
	echo "Make sure VT-x/AMD-V is enabled (in your BIOS settings)."
	echo "Type bin/configure.sh <app-name> (and skip these messages)."
	echo
	echo "Application code name? [$PROJ_NAME]: "
	read -r APP_NAME
	if [ "${APP_NAME}" == "" ]; then
		APP_NAME="${PROJ_NAME}"
	fi
else
	APP_NAME="$1"
fi
if [ ! -f "${APP_NAME}.profile" ]; then
	FIRST_TIME="yes"
	# Create APP_NAME.profile from the empty project template
	cp default.profile "${APP_NAME}.profile"
	# Write APP_NAME
	sed -i "s/APP_NAME=.*/APP_NAME=\"${APP_NAME}\"/g" "${APP_NAME}.profile"
fi
# Do NOT open the editor the first time
if [ ! "$FIRST_TIME" == "yes" ]; then 
	# Let the user edit the values in a temporary cloned file
	cp "$APP_NAME.profile" "$APP_NAME.profile.tmp"
	if [ "$EDITOR" == "" ]; then
		vim "$APP_NAME.profile.tmp"
	else
		$EDITOR "$APP_NAME.profile.tmp"
	fi
	DIFF=$(diff "$APP_NAME.profile.tmp" "$APP_NAME.profile")
	if [ ! "$DIFF" == "" ]; then 
		# Copy changes from tmp file and discard it
		cp "${APP_NAME}.profile.tmp" "${APP_NAME}.profile"
		rm "${APP_NAME}.profile.tmp"
	fi
fi
# Read values from the profile
source "${APP_NAME}.profile"
# Usage info
show_help() {
cat << EOH
Your Drupal project up and running with Drupsible. 

Usage: ${0##*/} [-h]
	[-d domain] [-v drupal-version]
	[-i (-n d-o-profile-name|-a custom-profile-name)] [-e [-f makefile]] 
	[-s] [-m db-dump] [-z files-tarball] [-c codebase-tarball] [-k key-filename] 
	[-g git-server -t git-protocol -r git-path -u git-user -p git-password [-b git-branch]]
	app-name

Options:

	-h	show this help and exits
	-d	webdomain (ie. example.com)
	-v	Drupal version (7 or 8)
	-i	Use an install profile
	-n	D.O. profile name
	-a	Custom profile name
	-e	Use drush make
	-f	Makefile
	-s	Use drush site-install (drush si)
	-m	DB dump filename (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)
	-z	Files tarball (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)
	-c	Codebase tarball (ie. example-codebase.tar.gz, must be in ansible/playbooks/codebase-tarballs)
	-k	SSH private key filename (defaults to ~/.ssh/id_rsa)
	-g	git server (ie. bitbucket.org, or git.your.org:8443 if using http/s)
	-t	git protocol (defaults to git)
	-r	git path (ie. example.git)
	-u	git user
	-p	git password (in case you are NOT using an SSH key)
    -b	git branch (defaults to master)

EOH
}
# Read any option from the command line (with precedence over the .profile)
while getopts "hd:v:in:a:ef:sm:z:c:k:g:t:r:u:p:b:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        d)  DOMAIN=$OPTARG
            ;;
        v)  DRUPAL_VERSION=$OPTARG
            ;;
        i)  USE_INSTALL_PROFILE='yes'
            ;;
        n)  D_O_INSTALL_PROFILE=$OPTARG
            ;;
        a)  CUSTOM_INSTALL_PROFILE=$OPTARG
            ;;
        e)  USE_DRUSH_MAKE='yes'
            ;;
        f)  DRUSH_MAKEFILE=$OPTARG
            ;;
        s)  USE_SITE_INSTALL='yes'
            ;;
        m)  DBDUMP=$OPTARG
            ;;
        z)  FILES_TARBALL=$OPTARG
            ;;
        c)  CODEBASE_TARBALL=$OPTARG
            ;;
        k)  KEY_FILENAME=$OPTARG
            ;;
        g)  GIT_SERVER=$OPTARG
            ;;
        t)  GIT_PROTOCOL=$OPTARG
            ;;
        r)  GIT_PATH=$OPTARG
            ;;
        u)  GIT_USER=$OPTARG
            ;;
        p)  GIT_PASS=$OPTARG
            ;;
        b)  GIT_BRANCH=$OPTARG
            ;;
        \?)
            show_help >&2
            exit 1
            ;;
    esac
done
# Perform a backup
./bin/backup.sh "$APP_NAME"
#
# Prompt for values not yet assigned.
#
if [ "$DOMAIN" == "" ]; then
	echo "Internet domain of the web application?"
	read -r DOMAIN
	# Write DOMAIN
	sed -i "s/DOMAIN=.*$/DOMAIN=\"${DOMAIN}\"/g" "${APP_NAME}.profile"
fi
if [ "$DRUPAL_VERSION" == "" ] || [ "$FIRST_TIME" == 'yes' ]; then
	echo "Drupal version? (7|8) [8])"
	read -r DRUPAL_VERSION
	if [ "$DRUPAL_VERSION" == "" ]; then
		DRUPAL_VERSION="8"
	fi
	# Write DRUPAL_VERSION
	sed -i "s|DRUPAL_VERSION=.*$|DRUPAL_VERSION=\"${DRUPAL_VERSION}\"|g" "${APP_NAME}.profile"
fi
if [ "$FIRST_TIME" == 'yes' ]; then
	if [ "$MULTILINGUAL" == "" ]; then
		echo "Will you setup a multilingual website? (y|n)"
		if askyesno; then
			MULTILINGUAL='yes'
		else
			MULTILINGUAL='no'
		fi
		# Write MULTILINGUAL
		sed -i "s|MULTILINGUAL=.*$|MULTILINGUAL=\"${MULTILINGUAL}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$MULTILINGUAL" == "yes" ]; then
		echo "Enumerate the languages, comma-separated, starting with the default language:"
		read -r LANGUAGES
		LANGUAGES_NO_WHITESPACE="$(echo -e "${LANGUAGES}" | tr -d '[[:space:]]')"
		# Write LANGUAGES
		sed -i "s|LANGUAGES=.*$|LANGUAGES=\"${LANGUAGES_NO_WHITESPACE}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$USE_INSTALL_PROFILE" == "" ]; then
		echo "Will you be using a distribution or install profile? (y|n)"
		if askyesno; then
			USE_INSTALL_PROFILE='yes'
		else
			USE_INSTALL_PROFILE='no'
		fi
		# Write USE_INSTALL_PROFILE
		sed -i "s|USE_INSTALL_PROFILE=.*$|USE_INSTALL_PROFILE=\"${USE_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ]; then
		echo "Type contrib/core profile or distribution, if applicable (ie. commerce_kickstart) []"
		read -r D_O_INSTALL_PROFILE
		# Write D_O_INSTALL_PROFILE
		sed -i "s|D_O_INSTALL_PROFILE=.*$|D_O_INSTALL_PROFILE=\"${D_O_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
		echo "Type the name of your custom profile/distribution"
		read -r CUSTOM_INSTALL_PROFILE
		# Write CUSTOM_INSTALL_PROFILE
		sed -i "s|CUSTOM_INSTALL_PROFILE=.*$|CUSTOM_INSTALL_PROFILE=\"${CUSTOM_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
		echo "WARNING: You have not specified a profile name. The core standard profile will be used."
		echo "======="
	fi
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$USE_DRUSH_MAKE" == "" ]; then
		if [ "$D_O_INSTALL_PROFILE" != "" ] && [ "$D_O_INSTALL_PROFILE" != "standard" ] && [ "$D_O_INSTALL_PROFILE" != "minimal" ] && [ "$D_O_INSTALL_PROFILE" != "testing" ]; then
			echo "Want to drush make <yourmakefile>? (y|n)"
			if askyesno; then
				USE_DRUSH_MAKE='yes'
			else
				USE_DRUSH_MAKE='no'
			fi
			# Write USE_DRUSH_MAKE
			sed -i "s|USE_DRUSH_MAKE=.*$|USE_DRUSH_MAKE=\"${USE_DRUSH_MAKE}\"|g" "${APP_NAME}.profile"
			if [ "$DRUSH_MAKEFILE" == "" ] && [ "$USE_DRUSH_MAKE" == "yes" ]; then
				echo "Makefile? [build-${APP_NAME}.make]"
				read -r DRUSH_MAKEFILE
				if [ "$DRUSH_MAKEFILE" == "" ]; then
					DRUSH_MAKEFILE="build-${APP_NAME}.make"
				fi
				# Write DRUSH_MAKEFILE
				sed -i "s|DRUSH_MAKEFILE=.*$|DRUSH_MAKEFILE=\"${DRUSH_MAKEFILE}\"|g" "${APP_NAME}.profile"
			fi
		fi
	fi
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$USE_SITE_INSTALL" == "" ]; then
		echo "Want to drush site-install? (y|n)"
		if askyesno; then
			USE_SITE_INSTALL='yes'
		else
			USE_SITE_INSTALL='no'
		fi
		# Write USE_SITE_INSTALL
		sed -i "s|USE_SITE_INSTALL=.*$|USE_SITE_INSTALL=\"${USE_SITE_INSTALL}\"|g" "${APP_NAME}.profile"
	fi
	if [ "$USE_UPSTREAM_SITE" != "yes" ]; then
		echo "Want to use an upstream site to sync the DB and/or files with? (y|n)"
		if askyesno; then
			USE_UPSTREAM_SITE='yes'
		else
			USE_UPSTREAM_SITE='no'
		fi
		# Write USE_UPSTREAM_SITE
		sed -i "s|USE_UPSTREAM_SITE=.*$|USE_UPSTREAM_SITE=\"${USE_UPSTREAM_SITE}\"|g" "${APP_NAME}.profile"
		if [ "$USE_UPSTREAM_SITE" == "yes" ]; then
			#
			echo "Remote upstream host?"
			read -r REMOTE_UPSTREAM_HOST
			# Write REMOTE_UPSTREAM_HOST
			sed -i "s|REMOTE_UPSTREAM_HOST=.*$|REMOTE_UPSTREAM_HOST=\"${REMOTE_UPSTREAM_HOST}\"|g" "${APP_NAME}.profile"
			#
			echo "Remote upstream port to SSH to (if not 22)? []"
			read -r REMOTE_UPSTREAM_PORT
			# Write REMOTE_UPSTREAM_PORT
			sed -i "s|REMOTE_UPSTREAM_PORT=.*$|REMOTE_UPSTREAM_PORT=\"${REMOTE_UPSTREAM_PORT}\"|g" "${APP_NAME}.profile"
			#
			echo "Username to SSH into that remote host? []"
			read -r REMOTE_UPSTREAM_USER
			# Write REMOTE_UPSTREAM_USER
			sed -i "s|REMOTE_UPSTREAM_USER=.*$|REMOTE_UPSTREAM_USER=\"${REMOTE_UPSTREAM_USER}\"|g" "${APP_NAME}.profile"
			#
			echo "Full site path in the remote host (docroot)?"
			read -r REMOTE_UPSTREAM_DOCROOT
			# Write REMOTE_UPSTREAM_DOCROOT
			sed -i "s|REMOTE_UPSTREAM_DOCROOT=.*$|REMOTE_UPSTREAM_DOCROOT=\"${REMOTE_UPSTREAM_DOCROOT}\"|g" "${APP_NAME}.profile"
			#
			echo "If using a bastion host (as in ProxyCommand ssh), enter its credentials: []"
			read -r REMOTE_UPSTREAM_PROXY_CREDENTIALS
			# Write REMOTE_UPSTREAM_PROXY_CREDENTIALS
			sed -i "s|REMOTE_UPSTREAM_PROXY_CREDENTIALS=.*$|REMOTE_UPSTREAM_PROXY_CREDENTIALS=\"${REMOTE_UPSTREAM_PROXY_CREDENTIALS}\"|g" "${APP_NAME}.profile"
			#
			echo "Bastion host port to SSH to (if not 22)? []"
			read -r REMOTE_UPSTREAM_PROXY_PORT
			# Write REMOTE_UPSTREAM_PROXY_PORT
			sed -i "s|REMOTE_UPSTREAM_PROXY_PORT=.*$|REMOTE_UPSTREAM_PROXY_PORT=\"${REMOTE_UPSTREAM_PROXY_PORT}\"|g" "${APP_NAME}.profile"
			#
			echo "Enter any other SSH options needed: []"
			read -r REMOTE_UPSTREAM_SSH_OPTIONS
			# Write REMOTE_UPSTREAM_SSH_OPTIONS
			sed -i "s|REMOTE_UPSTREAM_SSH_OPTIONS=.*$|REMOTE_UPSTREAM_SSH_OPTIONS=\"${REMOTE_UPSTREAM_SSH_OPTIONS}\"|g" "${APP_NAME}.profile"
			#
			echo "Want to sync files with the upstream site? (y|n)"
			if askyesno; then
				SYNC_FILES='yes'
			else
				SYNC_FILES='no'
			fi
			# Write SYNC_FILES
			sed -i "s|SYNC_FILES=.*$|SYNC_FILES=\"${SYNC_FILES}\"|g" "${APP_NAME}.profile"
			if [ "$SYNC_FILES" == "yes" ]; then
				echo "Files path relative to the docroot? [sites/default/files]"
				read -r REMOTE_UPSTREAM_FILES_PATH
				if [ "$REMOTE_UPSTREAM_FILES_PATH" == "" ]; then
					REMOTE_UPSTREAM_FILES_PATH='sites/default/files'
				fi
				# Write REMOTE_UPSTREAM_FILES_PATH
				sed -i "s|REMOTE_UPSTREAM_FILES_PATH=.*$|REMOTE_UPSTREAM_FILES_PATH=\"${REMOTE_UPSTREAM_FILES_PATH}\"|g" "${APP_NAME}.profile"
			fi
			#
			echo "Want to sync the DB with the upstream site? (y|n)"
			if askyesno; then
				SYNC_DB='yes'
			else
				SYNC_DB='no'
			fi
			# Write SYNC_DB
			sed -i "s|SYNC_DB=.*$|SYNC_DB=\"${SYNC_DB}\"|g" "${APP_NAME}.profile"
		else
			if [ "$DBDUMP" == "" ]; then
				echo "DB dump filename? (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)"
				read -r DBDUMP
				# Write DBDUMP
				sed -i "s|DBDUMP=.*$|DBDUMP=\"${DBDUMP}\"|g" "${APP_NAME}.profile"
			fi
			if [ "$FILES_TARBALL" == "" ]; then
				echo "Files tarball? (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)"
				read -r FILES_TARBALL
				# Write FILES_TARBALL
				sed -i "s|FILES_TARBALL=.*$|FILES_TARBALL=\"${FILES_TARBALL}\"|g" "${APP_NAME}.profile"
			fi
		fi
	fi
	if [ "$CODEBASE_TARBALL" == "" ]; then
		if [ "$USE_INSTALL_PROFILE" == "no" ] || ([ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$CUSTOM_INSTALL_PROFILE" != "" ]); then
			echo "Codebase tarball? (must be in ansible/playbooks/codebase-tarballs, leave empty if you have a Git repo.)"
			read -r CODEBASE_TARBALL
			# Write CODEBASE_TARBALL
			sed -i "s|CODEBASE_TARBALL=.*$|CODEBASE_TARBALL=\"${CODEBASE_TARBALL}\"|g" "${APP_NAME}.profile"
		fi
	fi
fi
if [ "$CODEBASE_TARBALL" == "" ]; then
	if [ "$USE_INSTALL_PROFILE" != "yes" ] || ([ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$CUSTOM_INSTALL_PROFILE" != "" ]); then
		# GIT config values
		if [ "$GIT_PROTOCOL" == "" ]; then
			echo "Protocol to access your Git clone URL? (ssh|https|git|http)"
			read -r GIT_PROTOCOL
			# Write GIT_PROTOCOL
			sed -i "s/GIT_PROTOCOL=.*$/GIT_PROTOCOL=\"${GIT_PROTOCOL}\"/g" "${APP_NAME}.profile"
		fi
		
		if [ "$GIT_SERVER" == "" ]; then
			echo "Git server name where your Drupal website is?"
			read -r GIT_SERVER
			# Write GIT_SERVER
			sed -i "s/GIT_SERVER=.*$/GIT_SERVER=\"${GIT_SERVER}\"/g" "${APP_NAME}.profile"
		fi
		
		if [ "$GIT_USER" == "" ]; then
			echo "Git username who will be cloning the Drupal repository?"
			read -r GIT_USER
			# Write GIT_USER
			sed -i "s/GIT_USER=.*$/GIT_USER=\"${GIT_USER}\"/g" "${APP_NAME}.profile"
		fi
		
		if [ "$GIT_PATH" == "" ]; then
			echo "Git path of your Drupal repository? (ie. mbarcia/drupsible-project.git)"
			read -r GIT_PATH
			# Write GIT_PATH
			sed -i "s|GIT_PATH=.*$|GIT_PATH=\"${GIT_PATH}\"|g" "${APP_NAME}.profile"
		fi
		
		if [ "$GIT_PASS" == "" ]; then
			echo "Git password? (leave it empty if you use a SSH key)"
			read -r -s GIT_PASS
			# Write GIT_PASS
			if [ ! "$GIT_PASS" == "" ]; then
				sed -i "s|GIT_PASS=.*$|GIT_PASS=\"${GIT_PASS}\"|g" "${APP_NAME}.profile"
			fi
		fi
		
		if [ "$GIT_BRANCH" == "" ]; then
			echo "Branch/version of your codebase? [master]"
			read -r GIT_BRANCH
			if [ "$GIT_BRANCH" == "" ]; then
				GIT_BRANCH='master'
			fi
			# Write GIT_BRANCH
			if [ ! "$GIT_PASS" == "" ]; then
				sed -i "s|GIT_BRANCH=.*$|GIT_BRANCH=\"${GIT_BRANCH}\"|g" "${APP_NAME}.profile"
			fi
		fi
	fi
fi
# Connect to a new or existing ssh-agent
if ([ "$GIT_PASS" == "" ] && [ "$KEY_FILENAME" == "" ] && [ "$USE_INSTALL_PROFILE" != "yes" ]) || [ "$USE_UPSTREAM_SITE" == "yes" ]; then
	echo "SSH key filename (to git clone, and/or sync with the upstream host)? [$HOME/.ssh/id_rsa]"
	read -r KEY_FILENAME
	if [ "$KEY_FILENAME" == "" ]; then
		# Set key to default: ~/.ssh/id_rsa
		KEY_FILENAME="$HOME/.ssh/id_rsa"
	fi
	# Write KEY_FILENAME
	sed -i "s|KEY_FILENAME=.*$|KEY_FILENAME=\"${KEY_FILENAME}\"|g" "${APP_NAME}.profile"
	if [ ! "$OSTYPE" = "darwin"* ]; then
		# Invoke ssh-agent script, applying bash expansion to the tilde
		./bin/ssh-agent.sh "${KEY_FILENAME/#\~/$HOME}"
	fi
fi
# Gather input about https enabled
if [ "$APP_HTTPS_ENABLED" == "" ]; then
	echo "Want your website deployed as https:// instead of just http://? (y|n)"
	if askyesno; then
		APP_HTTPS_ENABLED='yes'
	else
		APP_HTTPS_ENABLED='no'
	fi
	# Write APP_HTTPS_ENABLED
	sed -i "s|APP_HTTPS_ENABLED=.*$|APP_HTTPS_ENABLED=\"${APP_HTTPS_ENABLED}\"|g" "${APP_NAME}.profile"
fi
# Gather input about varnish enabled
if [ "$APP_HTTPS_ENABLED" != "yes" ] && [ "$APP_VARNISH_ENABLED" == "" ]; then
	echo "Want your website deployed behind a Varnish front-end? (y|n)"
	if askyesno; then
		APP_VARNISH_ENABLED='yes'
	else
		APP_VARNISH_ENABLED='no'
	fi
	# Write APP_VARNISH_ENABLED
	sed -i "s|APP_VARNISH_ENABLED=.*$|APP_VARNISH_ENABLED=\"${APP_VARNISH_ENABLED}\"|g" "${APP_NAME}.profile"
fi
#
# Create configuration files, replacing with all the project-specific 
# config values gathered.
#
# .gitignore
cp default.gitignore .gitignore
sed -i "s/app_name/${APP_NAME}/g" .gitignore
#
if [ ! -f ansible.cfg ]; then
	cp ansible.cfg.default ansible.cfg
else
	echo "Warning: skipped copy of ansible.cfg because it already exists. Check its contents before proceeding."
fi
# Vagrantfile
#
cp Vagrantfile.default Vagrantfile
#
# vagrant.yml
#
if [ ! -f vagrant.yml ]; then
	cp vagrant.default.yml vagrant.yml
else
	echo "Warning: skipped copy of vagrant.yml because it already exists. Check its contents before proceeding."
fi
sed -i "s/example\.com/${DOMAIN}/g" vagrant.yml
# Remove any possible app duplicates
sed -i "s|^- name\: '${APP_NAME}'$||g" vagrant.yml
# Add app name to the list
sed -i "/apps\:/a\
- name: '${APP_NAME}'" vagrant.yml
# Remove empty lines
sed -i '/^$/d' vagrant.yml
#
# Assign a random private IP address to minimize collision with other Drupsible projects.
#
set $(dd if=/dev/urandom bs=2 count=1 2>/dev/null | od -An -tu1)
IP_ADDR_RANDOM="192.168.$1.$2"
sed -i "s/ip_addr:.*/ip_addr: '${IP_ADDR_RANDOM}'/g" vagrant.yml
#
# ansible/requirements.yml
#
cp ansible/requirements.default.yml ansible/requirements.yml
#
# Create the inventory file
#
for ENV in "-local"
do
	#
	# Inventory file
	#
	if [ ! -f "ansible/inventory/${APP_NAME}${ENV}" ]; then
		cp "ansible/inventory/app_name${ENV}" "ansible/inventory/${APP_NAME}${ENV}"
		# Replace example.com by the proper hostname
		sed -i "s/example\.com/${DOMAIN}/g" "ansible/inventory/${APP_NAME}${ENV}"
		# Replace app_name by the actual app name
		sed -i "s/app_name/${APP_NAME}/g" "ansible/inventory/${APP_NAME}${ENV}"
	else
		echo "Warning: skipped copy of ansible/inventory/${APP_NAME}${ENV} because it already exists. Check its contents before proceeding."
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
	sed -i "s/example\.com/${DOMAIN}/g" all.yml
	sed -i "s/example-project/${APP_NAME}/g" all.yml
	sed -i "s/example\.com/${DOMAIN}/g" deploy.yml
	sed -i "s/example-project/${APP_NAME}/g" deploy.yml
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
	else
		sed -i "s/deploy_install_profile_enabled:.*$/deploy_install_profile_enabled: 'no'/g" deploy.yml
	fi
	if [ "$USE_DRUSH_MAKE" == "yes" ]; then
		sed -i "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: 'yes'|g" deploy.yml
		if [ "$DRUSH_MAKEFILE" != "" ]; then
			sed -i "s|deploy_drush_makefile:.*$|deploy_drush_makefile: '${DRUSH_MAKEFILE}'|g" deploy.yml
		fi		
	else
		sed -i "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: 'no'|g" deploy.yml
	fi
	if [ ! "$CODEBASE_TARBALL" == "" ] && [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$CUSTOM_INSTALL_PROFILE" != "" ]; then
		sed -i "s|deploy_codebase_tarball_filename:.*$|deploy_codebase_tarball_filename: '${CODEBASE_TARBALL}'|g" deploy.yml
		sed -i "s|deploy_codebase_import_enabled:.*$|deploy_codebase_import_enabled: yes|g" deploy.yml
	else
		sed -i "s|deploy_codebase_import_enabled:.*$|deploy_codebase_import_enabled: no|g" deploy.yml
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
	sed -i "s/deploy_git_repo_pass:.*$/deploy_git_repo_pass: \"${GIT_PASS}\"/g" deploy.yml
	sed -i "s|deploy_git_repo_version:.*$|deploy_git_repo_version: \"${GIT_BRANCH}\"|g" deploy.yml
	# Change directory out of group vars
	cd - > /dev/null || exit 2
done
# Append last-mod
DATE_LEGEND=$(date +"%c %Z")
PHRASE="Last reconfigured on"
sed -i "s/${PHRASE}:.*$/${PHRASE}: ${DATE_LEGEND}/g" "${APP_NAME}.profile"
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
echo
echo "Your webapp has been reconfigured for Drupsible."
echo "If this is your Ansible controller, refer to the docs to properly run ansible-playbook."
if [ "$FIRST_TIME" == "yes" ]; then
	echo "You will probably need to run the bootstrap playbook for each host in your infrastructure."
	echo "Have the root password at hand and run:"
	echo "ansible-playbook -l <host> -u root -k ansible/playbooks/bootstrap.yml"
fi
echo "If this is your local environment, just run vagrant up."
if [ "$FIRST_TIME" == "yes" ]; then
	echo "Vagrant will run a Debian Jessie Virtualbox by default. Edit vagrant.yml to change this and other custom config values."
fi
echo
