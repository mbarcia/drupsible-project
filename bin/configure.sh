#!/bin/bash

#
# Set APP_NAME
#
if [ "$1" == "" ]; then
	# Take the folder name as app name, if app-name param has not been given.
	DIR_NAME=${PWD##*/}
	# But remove suffix -drupsible if any.
	PROJ_NAME=${DIR_NAME%-drupsible}
	echo "Make sure VT-x/AMD-V is enabled (in your BIOS settings)."
	echo "Type bin/configure.sh <app-name> (and skip these messages)."
	echo
	echo "Application code name? (ie. example, default: $PROJ_NAME): "
	read APP_NAME
	if [ "${APP_NAME}" == "" ]; then
		APP_NAME="${PROJ_NAME}"
	fi
else
	APP_NAME="$1"
fi

if [ ! -f "${APP_NAME}.profile" ]; then
	echo "${APP_NAME}.profile does not exist." 
	echo "Configuring for the first time? Just type 'yes' or Enter."
	echo "Otherwise, type 'no' and check the app name."
	read CONFIRM
	if [ ! "$CONFIRM" == "no" ]; then
		# Create APP_NAME.profile from the empty project template
		cp default.profile "${APP_NAME}.profile"
		# Write APP_NAME
		sed -i "s/APP_NAME=.*/APP_NAME=\"${APP_NAME}\"/g" "${APP_NAME}.profile"
		CONFIRM='yes'
	else
		echo "Check the app name. Exiting..."
		exit 0
	fi
fi

# Do NOT open the editor the first time
if [ ! "$CONFIRM" == "yes" ]; then 
	# Let the user edit the values in a temporary cloned file
	cp "$APP_NAME.profile" "$APP_NAME.profile.tmp"
	if [ "$EDITOR" == "" ]; then
		vim "$APP_NAME.profile.tmp"
	else
		$EDITOR "$APP_NAME.profile.tmp"
	fi
	DIFF=$(diff "$APP_NAME.profile.tmp" "$APP_NAME.profile")
	if [ "$DIFF" == "" ]; then 
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
	[-d domain] 
	[-m db-dump] [-z files-tarball] [-k key-filename] 
	[-g git-server] [-t git-protocol] [-r git-path] [-u git-user] [-p git-password] [-b git-branch]
	app-name

Options:

	-h	show this help and exits
	-d	webdomain (ie. example.com)
	-m	DB dump filename (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)
	-z	Files tarball (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)
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
while getopts "hd:m:z:k:g:t:r:u:p:b:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        d)  DOMAIN=$OPTARG
            ;;
        m)  DBDUMP=$OPTARG
            ;;
        z)  FILES_TARBALL=$OPTARG
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
	echo "Domain name? (ie. example.com)"
	read DOMAIN
	# Write DOMAIN
	sed -i "s/DOMAIN=.*$/DOMAIN=\"${DOMAIN}\"/g" "${APP_NAME}.profile"
fi

if [ "$DBDUMP" == "" ] && [ "$CONFIRM" == 'yes' ]; then
	echo "DB dump filename? (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)"
	read DBDUMP
	# Write DBDUMP
	sed -i "s/DBDUMP=.*$/DBDUMP=${DBDUMP}/g" "${APP_NAME}.profile"
fi

if [ "$DBDUMP" != "" ] && [ ! -f ansible/playbooks/dbdumps/$DBDUMP ]; then
	echo "Please copy your DB dump $DBDUMP to ansible/playbooks/dbdumps/"
	exit -1
fi

if [ "$FILES_TARBALL" == "" ] && [ "$CONFIRM" == 'yes' ]; then
	echo "Files tarball? (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)"
	read FILES_TARBALL
	# Write FILES_TARBALL
	sed -i "s/FILES_TARBALL=.*$/FILES_TARBALL=${FILES_TARBALL}/g" "${APP_NAME}.profile"
fi

if [ "$FILES_TARBALL" != "" ] && [ ! -f ansible/playbooks/files-tarballs/$FILES_TARBALL ]; then
	echo "Please copy your file tarball $FILES_TARBALL to ansible/playbooks/files-tarballs/"
	exit -1
fi

#
# Create configuration files, replacing with all the project-specific 
# config values gathered.
#
cp default.gitignore .gitignore
cp Vagrantfile.default Vagrantfile
sed "s/example\.com/${DOMAIN}/g" <vagrant.default.yml >vagrant.yml
cp ansible/requirements.default.yml ansible/requirements.yml
sed "s/example\.com/${DOMAIN}/g" <ansible/inventory/hosts-local.default >ansible/inventory/hosts-local
rm -fr ansible/playbooks/deploy 2>/dev/null
cp -pr ansible/playbooks/deploy.default ansible/playbooks/deploy
rm -fr ansible/inventory/group_vars 2>/dev/null
cp -pr ansible/inventory/group_vars.default ansible/inventory/group_vars
cd ansible/inventory/group_vars
sed -i "s/example\.com/${DOMAIN}/g" all.yml
sed -i "s/example\.com/${DOMAIN}/g" drupsible_deploy.yml
sed -i "s/example-project/${APP_NAME}/g" all.yml
sed -i "s/example-project/${APP_NAME}/g" drupsible_deploy.yml
cd - > /dev/null

rm -fr ansible/inventory/host_vars 2>/dev/null
cp -pr ansible/inventory/host_vars.default ansible/inventory/host_vars
cd ansible/inventory/host_vars
cp local.example.com.yml "local.$DOMAIN.yml"
sed -i "s/example\.com/${DOMAIN}/g" "local.$DOMAIN.yml"
	
if [ ! "$DBDUMP" == "" ]; then
	sed -i "s/db_dump_filename: '{{ app_name }}.sql.gz'/db_dump_filename: '${DBDUMP}'/g" "local.$DOMAIN.yml"
	sed -i "s/db_import: False/db_import: yes/g" "local.$DOMAIN.yml"
fi
	
if [ ! "$FILES_TARBALL" == "" ]; then
	sed -i "s/files_tarball_filename: '{{ app_name }}.tar.gz'/files_tarball_filename: '${FILES_TARBALL}'/g" "local.$DOMAIN.yml"
	sed -i "s/files_import: False/files_import: yes/g" "local.$DOMAIN.yml"
fi
cd - > /dev/null

#
# GIT config values
#
# Set branch to default: master
if [ "$GIT_BRANCH" == "" ]; then
	GIT_BRANCH=master
	# Write GIT_BRANCH
	sed -i "s/GIT_BRANCH=.*$/GIT_BRANCH=\"${GIT_BRANCH}\"/g" "${APP_NAME}.profile"
fi

# Set protocol to default: git
if [ "$GIT_PROTOCOL" == "" ]; then
	GIT_PROTOCOL=git
	# Write GIT_PROTOCOL
	sed -i "s/GIT_PROTOCOL=.*$/GIT_PROTOCOL=\"${GIT_PROTOCOL}\"/g" "${APP_NAME}.profile"
fi

if [ "$GIT_SERVER" == "" ]; then
	echo "Git server name where your Drupal website is?"
	read GIT_SERVER
	# Write GIT_SERVER
	sed -i "s/GIT_SERVER=.*$/GIT_SERVER=\"${GIT_SERVER}\"/g" "${APP_NAME}.profile"
fi

if [ "$GIT_USER" == "" ]; then
	echo "Git username of your Drupal repository?"
	read GIT_USER
	# Write GIT_USER
	sed -i "s/GIT_USER=.*$/GIT_USER=\"${GIT_USER}\"/g" "${APP_NAME}.profile"
fi

if [ "$GIT_PATH" == "" ]; then
	echo "Git path of your Drupal repository? (ie. example.git)"
	read GIT_PATH
	# Write GIT_PATH
	sed -i "s/GIT_PATH=.*$/GIT_PATH=\"${GIT_PATH}\"/g" "${APP_NAME}.profile"
fi

if [ "$GIT_PASS" == "" ]; then
	echo "Git password? (leave it empty if you use a SSH key)"
	read -s GIT_PASS
	# Write GIT_PASS
	sed -i "s/GIT_PASS=.*$/GIT_PASS=\"${GIT_PASS}\"/g" "${APP_NAME}.profile"
fi

cd ansible/inventory/group_vars
# Append to group_vars/drupsible_deploy.yml
cat <<EOF >> drupsible_deploy.yml

# Version of the repository to check out (full 40-character SHA-1 hash, the literal string HEAD, a branch name, or a tag name).
git_version: "$GIT_BRANCH"
# can be git, ssh, or http
git_repo_protocol: "$GIT_PROTOCOL"
git_repo_server: "$GIT_SERVER"
git_repo_user: "$GIT_USER"
git_repo_path: "$GIT_PATH"
git_repo_pass: "$GIT_PASS"
EOF
cd - > /dev/null

# Connect to a new or existing ssh-agent
# Then add/load your SSH key
if [ "$GIT_PASS" == "" ] && [ "$KEY_FILENAME" == "" ]; then
	echo "SSH key filename? (~/.ssh/id_rsa)"
	read KEY_FILENAME
	if [ "$KEY_FILENAME" == "" ]; then
		# Set key to default: ~/.ssh/id_rsa
		KEY_FILENAME="~/.ssh/id_rsa"
	fi
	# Write KEY_FILENAME
	sed -i "s|KEY_FILENAME=.*$|KEY_FILENAME=\"${KEY_FILENAME}\"|g" "${APP_NAME}.profile"
fi

if [ "$GIT_PASS" == "" ]; then
	# Invoke ssh-agent script, applying bash expansion to the tilde
	./bin/ssh-agent.sh "${KEY_FILENAME/#\~/$HOME}"
	# Connect to ssh-agent launched by ssh-agent.sh
	eval $(< "${~/.ssh-agent/#\~/$HOME}}")
	# Report back
	echo "SSH keys loaded:"
	ssh-add -l
fi

# Append last-mod
DATE_LEGEND=$(date +"%c %Z")
PHRASE="Last reconfigured on"
sed -i "s/${PHRASE}:.*$/${PHRASE}: ${DATE_LEGEND}/g" "${APP_NAME}.profile"

echo
echo "Your webapp has been reconfigured for Drupsible."
echo "If this is your Ansible controller, refer to the docs to properly run ansible-playbook."
if [ "$CONFIRM" == "yes" ]; then
	echo "You will probably need to run the bootstrap playbook for each host in your infrastructure."
	echo "Have the root password at hand and run:"
	echo "ansible-playbook -l <host> -u root -k ansible/playbooks/bootstrap.yml"
fi
echo "If this is your local environment, just run vagrant up."
if [ "$CONFIRM" == "yes" ]; then
	echo "Vagrant will run a Debian Jessie Virtualbox by default. Edit vagrant.yml to change this and other custom config values."
fi
echo
