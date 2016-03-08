#!/bin/bash

#
# Chdir to top-level folder if needed.
#
if [ -f "../default.profile" ]; then
	echo "Changed current dir to the project's top level folder, for your convenience."
	cd ..
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
	read APP_NAME
	if [ "${APP_NAME}" == "" ]; then
		APP_NAME="${PROJ_NAME}"
	fi
else
	APP_NAME="$1"
fi

if [ ! -f "${APP_NAME}.profile" ]; then
	FIRST_TIME='yes'
	# Create APP_NAME.profile from the empty project template
	cp default.profile "${APP_NAME}.profile"
	# Write APP_NAME
	sed -i.ori "s/APP_NAME=.*/APP_NAME=\"${APP_NAME}\"/g" "${APP_NAME}.profile"
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
	echo "Domain name? (ie. $APP_NAME.com)"
	read DOMAIN
	# Write DOMAIN
	sed -i.ori "s/DOMAIN=.*$/DOMAIN=\"${DOMAIN}\"/g" "${APP_NAME}.profile"
fi

if [ "$DRUPAL_VERSION" == "" ] || [ "$FIRST_TIME" == 'yes' ]; then
	echo "Drupal version? (7|8) [7])"
	read DRUPAL_VERSION
	if [ "$DRUPAL_VERSION" == "" ]; then
		DRUPAL_VERSION=7
	fi
	# Write DRUPAL_VERSION
	sed -i.ori "s|DRUPAL_VERSION=.*$|DRUPAL_VERSION=\"${DRUPAL_VERSION}\"|g" "${APP_NAME}.profile"
fi

if [ "$FIRST_TIME" == 'yes' ]; then
	if [ "$USE_INSTALL_PROFILE" == "" ]; then
		echo "Will you be using a distribution or install profile? (y|n)"
		if askyesno; then
			USE_INSTALL_PROFILE = 'yes'
		else
			USE_INSTALL_PROFILE = 'no'
		fi
		# Write USE_INSTALL_PROFILE
		sed -i.ori "s|USE_INSTALL_PROFILE=.*$|USE_INSTALL_PROFILE=\"${USE_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ]; then
		echo "Type contrib/core profile or distribution, if applicable (ie. commerce_kickstart) []"
		read D_O_INSTALL_PROFILE
		# Write D_O_INSTALL_PROFILE
		sed -i.ori "s|D_O_INSTALL_PROFILE=.*$|D_O_INSTALL_PROFILE=\"${D_O_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
		echo "Type the name of your custom profile/distribution"
		read CUSTOM_INSTALL_PROFILE
		# Write CUSTOM_INSTALL_PROFILE
		sed -i.ori "s|CUSTOM_INSTALL_PROFILE=.*$|CUSTOM_INSTALL_PROFILE=\"${CUSTOM_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
		echo "WARNING: You have not specified a profile name. The core standard profile will be used."
		echo "======="
	fi
	
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$USE_SITE_INSTALL" == "" ]; then
		echo "Will you be using drush site-install? (y|n)"
		if askyesno; then
			USE_SITE_INSTALL = 'yes'
		else
			USE_SITE_INSTALL = 'no'
		fi
		# Write USE_SITE_INSTALL
		sed -i.ori "s|USE_SITE_INSTALL=.*$|USE_SITE_INSTALL=\"${USE_SITE_INSTALL}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$USE_DRUSH_MAKE" == "" ]; then
		echo "Will you be using drush make? (y|n)"
		if askyesno; then
			USE_DRUSH_MAKE = 'yes'
		else
			USE_DRUSH_MAKE = 'no'
		fi
		# Write USE_DRUSH_MAKE
		sed -i.ori "s|USE_DRUSH_MAKE=.*$|USE_DRUSH_MAKE=\"${USE_DRUSH_MAKE}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$DRUSH_MAKEFILE" == "" ] && [ "$USE_DRUSH_MAKE" == "yes" ]; then
		echo "Makefile? (ie. ${APP_NAME}.make)"
		read DRUSH_MAKEFILE
		# Write DRUSH_MAKEFILE
		sed -i.ori "s|DRUSH_MAKEFILE=.*$|DRUSH_MAKEFILE=\"${DRUSH_MAKEFILE}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$DBDUMP" == "" ] && [ "$USE_SITE_INSTALL" == "no" ]; then
		echo "DB dump filename? (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)"
		read DBDUMP
		# Write DBDUMP
		sed -i.ori "s|DBDUMP=.*$|DBDUMP=\"${DBDUMP}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$FILES_TARBALL" == "" ] && [ "$USE_SITE_INSTALL" == "no" ]; then
		echo "Files tarball? (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)"
		read FILES_TARBALL
		# Write FILES_TARBALL
		sed -i.ori "s|FILES_TARBALL=.*$|FILES_TARBALL=\"${FILES_TARBALL}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$CODEBASE_TARBALL" == "" ]; then
		if [[ "$USE_INSTALL_PROFILE" == "no" || ("$USE_INSTALL_PROFILE" == "yes" && "$CUSTOM_INSTALL_PROFILE" != "") ]]; then
			echo "Codebase tarball? (must be in ansible/playbooks/codebase-tarballs, leave empty if you have a Git repo.)"
			read CODEBASE_TARBALL
			# Write CODEBASE_TARBALL
			sed -i.ori "s|CODEBASE_TARBALL=.*$|CODEBASE_TARBALL=\"${CODEBASE_TARBALL}\"|g" "${APP_NAME}.profile"
		fi
	fi
fi

#
# Create configuration files, replacing with all the project-specific 
# config values gathered.
#
cp default.gitignore .gitignore
cp Vagrantfile.default Vagrantfile
sed "s/example\.com/${DOMAIN}/g" <vagrant.default.yml >vagrant.yml
# Assign a random private IP address to minimize collision with other Drupsible projects.
set $(dd if=/dev/urandom bs=2 count=1 2>/dev/null | od -An -tu1)
IP_ADDR_RANDOM="192.168.$1.$2"
sed -i.ori "s/ip_addr:.*/ip_addr: '${IP_ADDR_RANDOM}'/g" vagrant.yml
cp ansible/requirements.default.yml ansible/requirements.yml
sed "s/example\.com/${DOMAIN}/g" <ansible/inventory/hosts-local.default >ansible/inventory/hosts-local
rm -fr ansible/playbooks/deploy 2>/dev/null
cp -pr ansible/playbooks/deploy.default ansible/playbooks/deploy
rm -fr ansible/inventory/group_vars 2>/dev/null

#
# groups_vars
#
cp -pr ansible/inventory/group_vars.default ansible/inventory/group_vars
cd ansible/inventory/group_vars
sed -i.ori "s/example\.com/${DOMAIN}/g" drupsible_all_hosts.yml
sed -i.ori "s/example\.com/${DOMAIN}/g" drupsible_deploy.yml
sed -i.ori "s/example-project/${APP_NAME}/g" drupsible_all_hosts.yml
sed -i.ori "s/example-project/${APP_NAME}/g" drupsible_deploy.yml
sed -i.ori "s/drupal_version:.*/drupal_version: '${DRUPAL_VERSION}'/g" drupsible_all_hosts.yml

if [ "$DRUPAL_VERSION" == "8" ]; then
	sed -i.ori "s/drush_min_version:.*/drush_min_version: \"dev-master\"/g" drupsible_deploy.yml
else
	sed -i.ori "s/drush_min_version:.*/drush_min_version: \"${DRUPAL_VERSION}\.*\"/g" drupsible_deploy.yml
fi

if [ "$USE_INSTALL_PROFILE" == "yes" ]; then
	sed -i.ori "s/deploy_install_profile_enabled:.*$/deploy_install_profile_enabled: '${USE_INSTALL_PROFILE}'/g" drupsible_deploy.yml
	if [ "$D_O_INSTALL_PROFILE" != "" ]; then
		sed -i.ori "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: '${D_O_INSTALL_PROFILE}'/g" drupsible_deploy.yml
		sed -i.ori "s/deploy_custom_install_profile:.*$/deploy_custom_install_profile: ''/g" drupsible_deploy.yml
	elif [ "$CUSTOM_INSTALL_PROFILE" != "" ]; then
		sed -i.ori "s/deploy_custom_install_profile:.*$/deploy_custom_install_profile: '${CUSTOM_INSTALL_PROFILE}'/g" drupsible_deploy.yml
		sed -i.ori "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: ''/g" drupsible_deploy.yml
	else 
		sed -i.ori "s/deploy_d_o_install_profile:.*$/deploy_d_o_install_profile: standard/g" drupsible_deploy.yml
	fi		
fi

if [ "$USE_DRUSH_MAKE" == "yes" ]; then
	sed -i.ori "s|deploy_drush_make_enabled:.*$|deploy_drush_make_enabled: '${USE_DRUSH_MAKE}'|g" drupsible_deploy.yml
	if [ "$DRUSH_MAKEFILE" != "" ]; then
		sed -i.ori "s|deploy_drush_makefile:.*$|deploy_drush_makefile: '${DRUSH_MAKEFILE}'|g" drupsible_deploy.yml
	fi		
fi

if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$CUSTOM_INSTALL_PROFILE" != "" ] && [ ! "$CODEBASE_TARBALL" == "" ]; then
	sed -i.ori "s|codebase_tarball_filename:.*$|codebase_tarball_filename: '${CODEBASE_TARBALL}'|g" drupsible_deploy.yml
	sed -i.ori "s|codebase_import:.*$|codebase_import: yes|g" drupsible_deploy.yml
else
	sed -i.ori "s|codebase_import:.*$|codebase_import: no|g" drupsible_deploy.yml
fi

cd - > /dev/null

rm -fr ansible/inventory/host_vars 2>/dev/null
cp -pr ansible/inventory/host_vars.default ansible/inventory/host_vars
cd ansible/inventory/host_vars
cp local.example.com.yml "local.$DOMAIN.yml"
sed -i.ori "s/example\.com/${DOMAIN}/g" "local.$DOMAIN.yml"

sed -i.ori "s|site_install_:.*$|site_install: '${USE_SITE_INSTALL}'|g" "local.$DOMAIN.yml"

if [ "$USE_SITE_INSTALL" == "no" ]; then
	if [ ! "$DBDUMP" == "" ]; then 
		sed -i.ori "s|db_dump_filename:.*$|db_dump_filename: '${DBDUMP}'|g" "local.$DOMAIN.yml"
		sed -i.ori "s|db_import:.*$|db_import: yes|g" "local.$DOMAIN.yml"
	else
		sed -i.ori "s|db_import:.*$|db_import: no|g" "local.$DOMAIN.yml"
	fi
	
	if [ ! "$FILES_TARBALL" == "" ]; then
		sed -i.ori "s|files_tarball_filename:.*$|files_tarball_filename: '${FILES_TARBALL}'|g" "local.$DOMAIN.yml"
		sed -i.ori "s|files_import:.*$|files_import: yes|g" "local.$DOMAIN.yml"
	else
		sed -i.ori "s|files_import:.*$|files_import: no|g" "local.$DOMAIN.yml"
	fi
fi

cd - > /dev/null

if [ "$CODEBASE_TARBALL" == "" ]; then
	if [[ "$USE_INSTALL_PROFILE" == "no" || ("$USE_INSTALL_PROFILE" == "yes" && "$CUSTOM_INSTALL_PROFILE" != "") ]]; then
	#
	# GIT config values
	#
	if [ "$GIT_PROTOCOL" == "" ]; then
		echo "Protocol to access your Git clone URL? (ssh|https|git|http)"
		read GIT_PROTOCOL
		# Write GIT_PROTOCOL
		sed -i.ori "s/GIT_PROTOCOL=.*$/GIT_PROTOCOL=\"${GIT_PROTOCOL}\"/g" "${APP_NAME}.profile"
	fi
	
	if [ "$GIT_SERVER" == "" ]; then
		echo "Git server name where your Drupal website is?"
		read GIT_SERVER
		# Write GIT_SERVER
		sed -i.ori "s/GIT_SERVER=.*$/GIT_SERVER=\"${GIT_SERVER}\"/g" "${APP_NAME}.profile"
	fi
	
	if [ "$GIT_USER" == "" ]; then
		echo "Git username who will be cloning the Drupal repository?"
		read GIT_USER
		# Write GIT_USER
		sed -i.ori "s/GIT_USER=.*$/GIT_USER=\"${GIT_USER}\"/g" "${APP_NAME}.profile"
	fi
	
	if [ "$GIT_PATH" == "" ]; then
		echo "Git path of your Drupal repository? (ie. mbarcia/drupsible-project.git)"
		read GIT_PATH
		# Write GIT_PATH
		sed -i.ori "s|GIT_PATH=.*$|GIT_PATH=\"${GIT_PATH}\"|g" "${APP_NAME}.profile"
	fi
	
	if [ "$GIT_PASS" == "" ]; then
		echo "Git password? (leave it empty if you use a SSH key)"
		read -s GIT_PASS
		# Write GIT_PASS
		if [ ! "$GIT_PASS" == "" ]; then
			sed -i.ori "s|GIT_PASS=.*$|GIT_PASS=\"${GIT_PASS}\"|g" "${APP_NAME}.profile"
		fi
	fi
	
	if [ "$GIT_BRANCH" == "" ]; then
		echo "Branch/version of your codebase? [master]"
		read GIT_BRANCH
		if [ "$GIT_BRANCH" == "" ]; then
			GIT_BRANCH = 'master'
		fi
		# Write GIT_BRANCH
		if [ ! "$GIT_PASS" == "" ]; then
			sed -i.ori "s|GIT_BRANCH=.*$|GIT_BRANCH=\"${GIT_BRANCH}\"|g" "${APP_NAME}.profile"
		fi
	fi

	cd ansible/inventory/group_vars
	
	sed -i.ori "s/git_repo_protocol:.*$/git_repo_protocol: \"${GIT_PROTOCOL}\"/g" drupsible_deploy.yml
	sed -i.ori "s/git_repo_server:.*$/git_repo_server: \"${GIT_SERVER}\"/g" drupsible_deploy.yml
	sed -i.ori "s/git_repo_user:.*$/git_repo_user: \"${GIT_USER}\"/g" drupsible_deploy.yml
	sed -i.ori "s|git_repo_path:.*$|git_repo_path: \"${GIT_PATH}\"|g" drupsible_deploy.yml
	sed -i.ori "s/git_repo_pass:.*$/git_repo_pass: \"${GIT_PASS}\"/g" drupsible_deploy.yml
	sed -i.ori "s|git_version:.*$|git_version: \"${GIT_BRANCH}\"|g" drupsible_deploy.yml
	
	cd - > /dev/null

fi

# Connect to a new or existing ssh-agent
# Then add/load your SSH key
if [ "$GIT_PASS" == "" ] && [ "$KEY_FILENAME" == "" ] && [ "$USE_INSTALL_PROFILE" == "no" ]; then
	echo "SSH key filename? (~/.ssh/id_rsa)"
	read KEY_FILENAME
	if [ "$KEY_FILENAME" == "" ]; then
		# Set key to default: ~/.ssh/id_rsa
		KEY_FILENAME="~/.ssh/id_rsa"
	fi
	# Write KEY_FILENAME
	sed -i.ori "s|KEY_FILENAME=.*$|KEY_FILENAME=\"${KEY_FILENAME}\"|g" "${APP_NAME}.profile"
fi

if [ "$GIT_PASS" == "" ] && [ "$USE_INSTALL_PROFILE" == "no" ] && [[ ! $OSTYPE = "darwin"* ]]; then
	# Invoke ssh-agent script, applying bash expansion to the tilde
	./bin/ssh-agent.sh "${KEY_FILENAME/#\~/$HOME}"
	# Connect to ssh-agent launched by ssh-agent.sh
	SSH_AGENT_DATA="~/.ssh-agent"
	eval $(< "${SSH_AGENT_DATA/#\~/$HOME}")
	# Report back
	echo "SSH keys loaded:"
	ssh-add -l
fi

# Append last-mod
DATE_LEGEND=$(date +"%c %Z")
PHRASE="Last reconfigured on"
sed -i.ori "s/${PHRASE}:.*$/${PHRASE}: ${DATE_LEGEND}/g" "${APP_NAME}.profile"

#
# Validate tarballs are found, if not, issue a warning message.
#
if [ "$CODEBASE_TARBALL" != "" ] && [ ! -f ansible/playbooks/codebase-tarballs/$CODEBASE_TARBALL ]; then
	echo "WARNING: Copy $CODEBASE_TARBALL to ansible/playbooks/codebase-tarballs/"
	echo "======="
fi

if [ "$FILES_TARBALL" != "" ] && [ ! -f ansible/playbooks/files-tarballs/$FILES_TARBALL ]; then
	echo "WARNING: Copy $FILES_TARBALL to ansible/playbooks/files-tarballs/"
	echo "======="
fi

if [ "$DBDUMP" != "" ] && [ ! -f ansible/playbooks/dbdumps/$DBDUMP ]; then
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

askyesno() {
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
