#!/bin/bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hf] -s app-name -d domain -m db-dump -z files-tarball -k key-filename -g git-server -p git-password -t git-protocol -r git-path -u git-user -b git-branch command
Your Drupal project up and running with Drupsible. Options:

	-h	show this help and exits
	-f	force overriding of config files
	-s	application name (defaults to folder name)
	-d	domain name (ie. example.com)
	-m	DB dump filename (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)
	-z	Files tarball (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)
	-k	SSH private key filename (defaults to ~/.ssh/id_rsa)
	-g	git server (ie. bitbucket.org, or git.your.org:8443)
	-p	git password (in case you are NOT using an SSH key)
	-t	git protocol (defaults to git)
	-r	git path (ie. example.git)
	-u	git user
    -b	git branch (defaults to master)

Commands:
	up 			Run vagrant up (default)
	provision	Run vagrant provision

	If you want to run other commands (halt/destroy/suspend/reload) on the VM, 
	you can use vagrant directly (not this script).
EOF
}

while getopts "hfs:d:m:z:k:g:p:t:r:u:b:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        f)  FORCE=1
			;;
        s)  APP_NAME=$OPTARG
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
        p)  GIT_PASS=$OPTARG
            ;;
        t)  GIT_PROTOCOL=$OPTARG
            ;;
        r)  GIT_PATH=$OPTARG
            ;;
        u)  GIT_USER=$OPTARG
            ;;
        b)  GIT_BRANCH=$OPTARG
            ;;
        \?)
            show_help >&2
            exit 1
            ;;
    esac
done

echo "Is Virtualization enabled in your BIOS settings?"

if [ "$1" == "" ]; then
	VAGRANT_COMMAND="up"
else
	VAGRANT_COMMAND="$1"
fi

if [ "$APP_NAME" == "" ]; then
	DIR_NAME=${PWD##*/}
	PROJ_NAME=${DIR_NAME%-drupsible}
	echo "Application code name? (ie. example, default: $PROJ_NAME): "
	read APP_NAME
	if [ "$APP_NAME" == "" ]; then
		APP_NAME="$PROJ_NAME"
	fi
fi

if [ "$DOMAIN" == "" ]; then
	echo "Domain name? (ie. example.com)"
	read DOMAIN
fi

if [ "$DBDUMP" == "" ]; then
	echo "DB dump filename? (ie. example.sql.gz, must be in ansible/playbooks/dbdumps)"
	read DBDUMP
fi

if [ "$DBDUMP" != "" ] && [ ! -f ansible/playbooks/dbdumps/$DBDUMP ]; then
	echo "Please copy your DB dump $DBDUMP to ansible/playbooks/dbdumps/"
	exit -1
fi

if [ "$FILES_TARBALL" == "" ]; then
	echo "Files tarball? (ie. example-files.tar.gz, must be in ansible/playbooks/files-tarballs)"
	read FILES_TARBALL
fi

if [ "$FILES_TARBALL" != "" ] && [ ! -f ansible/playbooks/files-tarballs/$FILES_TARBALL ]; then
	echo "Please copy your file tarball $FILES_TARBALL to ansible/playbooks/files-tarballs/"
	exit -1
fi

if [ ! -f .gitignore ] || [ $FORCE ]; then
	cp default.gitignore .gitignore
fi

if [ ! -f Vagrantfile ] || [ $FORCE ]; then
	cp Vagrantfile.default Vagrantfile
fi

if [ ! -f vagrant.yml ] || [ $FORCE ]; then
	sed "s/example\.com/$DOMAIN/g" <vagrant.default.yml >vagrant.yml
fi

if [ ! -f ansible/requirements.yml ] || [ $FORCE ]; then
	cp ansible/requirements.default.yml ansible/requirements.yml
fi

if [ ! -f ansible/inventory/hosts-local ] || [ $FORCE ]; then
	sed "s/example\.com/$DOMAIN/g" <ansible/inventory/hosts-local.default >ansible/inventory/hosts-local
fi

if [ ! -d ansible/inventory/group_vars ] || [ $FORCE ]; then
	cp -pr ansible/inventory/group_vars.default/* ansible/inventory/group_vars
	cd ansible/inventory/group_vars
	sed -i "s/example\.com/$DOMAIN/g" all.yml
	sed -i "s/example-project/$APP_NAME/g" all.yml
	
	# Set branch to default: master
	if [ "$GIT_BRANCH" == "" ]; then
		GIT_BRANCH=master
	fi
	
	# Set protocol to default: git
	if [ "$GIT_PROTOCOL" == "" ]; then
		GIT_PROTOCOL=git
	fi
	
	if [ "$GIT_SERVER" == "" ]; then
		echo "Git server name where your Drupal website is?"
		read GIT_SERVER
	fi
	
	if [ "$GIT_USER" == "" ]; then
		echo "Git username of your Drupal repository?"
		read GIT_USER
	fi
	
	if [ "$GIT_PATH" == "" ]; then
		echo "Git path of your Drupal repository? (ie. example.git)"
		read GIT_PATH
	fi
	
	# Append to group_vars/all
	cat <<EOF >> all.yml
	
	# Version of the repository to check out (full 40-character SHA-1 hash, the literal string HEAD, a branch name, or a tag name).
	git_version: "$GIT_BRANCH"
	# can be git, ssh, or http
	git_repo_protocol: "$GIT_PROTOCOL"
	git_repo_server: "$GIT_SERVER"
	git_repo_user: "$GIT_USER"
	git_repo_path: "$GIT_PATH"
EOF
	cd - > /dev/null
fi

if [ ! -d ansible/inventory/host_vars ] || [ $FORCE ]; then
	cp -pr ansible/inventory/host_vars.default/* ansible/inventory/host_vars
	cd ansible/inventory/host_vars
	cp local.example.com.yml local.$DOMAIN.yml
	sed -i "s/example\.com/$DOMAIN/g" local.$DOMAIN.yml
	
	if [ "$DBDUMP" != "" ]; then
		sed -i "s/db_dump_filename\: '{{ app_name }}.sql.gz'/db_dump_filename: '$DBDUMP'/g" local.$DOMAIN.yml
		sed -i "s/db_import\: False/db_import\: True/g" local.$DOMAIN.yml
	fi
		
	if [ "$FILES_TARBALL" != "" ]; then
		sed -i "s/files_tarball_filename\: '{{ app_name }}.tar.gz'/files_tarball_filename: '$FILES_TARBALL'/g" local.$DOMAIN.yml
		sed -i "s/files_import\: False/files_import\: True/g" local.$DOMAIN.yml
	fi
	
	cd - > /dev/null
fi

if [ "$GIT_PASS" == "" ]; then
	echo "Git password? (leave it empty if you use an SSH key)"
	read -s GIT_PASS
fi


if [ "$GIT_PASS" == "" ]; then
	echo "SSH key filename? (~/.ssh/id_rsa)"
	read KEY_FILENAME
	# Set key to default: ~/.ssh/id_rsa
	if [ "$KEY_FILENAME" == "" ]; then
		KEY_FILENAME="~/.ssh/id_rsa"
	fi
	./ssh-agent.ssh $KEY_FILENAME
	vagrant "$VAGRANT_COMMAND"
else
	DEPLOY_ARGS="git_repo_pass=$GIT_PASS accept_hostkey=True" vagrant "$VAGRANT_COMMAND"
fi