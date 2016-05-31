#!/bin/bash

enter_password ()
{
	local __resultvarname=$1
	local password_input=''
	while IFS= read -r -s -n1 char; do
	  [[ -z $char ]] && { printf '\n'; break; } # ENTER pressed; output \n and break.
	  if [[ $char == $'\x7f' ]]; then # backspace was pressed
	      # Remove last char from output variable.
	      [[ -n $password_input ]] && password_input=${password_input%?}
	      # Erase '*' to the left.
	      printf '\b \b'
	  else
	    # Add typed char to output variable.
	    password_input+=$char
	    # Print '*' in its stead.
	    printf '*'
	  fi
	done
	unset IFS

	eval $__resultvarname="'${password_input}'"
}

start_over ()
{
	# Create APP_NAME.profile.tmp from the empty project template
	cp default.profile "${APP_NAME}.profile.tmp"
	# Write APP_NAME
	sed -i "s/APP_NAME=.*/APP_NAME=\"${APP_NAME}\"/g" "${APP_NAME}.profile.tmp"
}

askyesno ()
{
	while read -r -n 1 -s answer; do
		if [[ $answer = [YyNn] ]]; then
			[[ $answer = [Yy] ]] && retval=0
			[[ $answer = [Nn] ]] && retval=1
    		break
		fi
	done
	return ${retval}
}

function clean_up {
	echo "-------------------------------------------------------------------------------"
	echo "Configuration script terminated."
	# Perform program exit housekeeping
	if [ ! -f "${APP_NAME}.profile.tmp" ]; then
		rm "${APP_NAME}.profile.tmp"
	fi
	echo "Run bin/configure.sh to start over."
	echo "-------------------------------------------------------------------------------"

	exit
}

trap clean_up SIGHUP SIGINT SIGTERM

echo "-------------------------------------------------------------------------------"
echo "Welcome to the Drupsible wizard"
echo "==============================="
echo
echo "Take this brief questionnaire and you will be up and running in no time!"
echo
echo "You may configure Drupsible to install any of these: core profiles (minimal, "
echo "standard) contributed distributions (bear, thunder), or your own project."
echo
echo "Available options are prompted between parenthesis, like (y|n)."
echo "Default values (when you hit Enter) are prompted between brackets []."
echo "-------------------------------------------------------------------------------"

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
	echo "Application name? [$PROJ_NAME]: "
	read -r APP_NAME
	if [ "${APP_NAME}" == "" ]; then
		APP_NAME="${PROJ_NAME}"
		echo "Application name set to ${PROJ_NAME}"
	fi
else
	APP_NAME="$1"
fi

if [ ! -f "${APP_NAME}.profile" ]; then
	start_over
else
	echo "${APP_NAME}.profile already exists. Do you want to start over? (y|n)"
	if ! askyesno; then
		echo "Do you want to re-generate ${APP_NAME}'s configuration? (y|n)"
		if askyesno; then
			./bin/generate.sh "${APP_NAME}.profile"
		else
			echo "Done (nothing changed)."
		fi
		exit
	else
		start_over
	fi
fi
#
# Start interactive questionnaire
#
echo
echo "What is the primary internet domain of your web application?"
read -r DOMAIN
# Write DOMAIN
sed -i "s/DOMAIN=.*$/DOMAIN=\"${DOMAIN}\"/g" "${APP_NAME}.profile.tmp"
echo
echo "Host name in your local environment? [local]"
read -r HOSTNAME
if [ "$HOSTNAME" == "" ]; then
	# Set hostname to default: local
	HOSTNAME="local"
	echo "Host name set to local"
fi
# Write HOSTNAME
sed -i "s/HOSTNAME=.*$/HOSTNAME=\"${HOSTNAME}\"/g" "${APP_NAME}.profile.tmp"
echo
echo "What Drupal version are you using? (7|8) [8])"
echo "8 (or 7) will get you the latest stable, but you can also specify any "
echo "particular Drupal core version, like 8.0.5 (or 7.43)"
read -r DRUPAL_VERSION
if [ "$DRUPAL_VERSION" == "" ]; then
	DRUPAL_VERSION="8"
	echo "Drupal version set to 8"
fi
# Write DRUPAL_VERSION
sed -i "s|DRUPAL_VERSION=.*$|DRUPAL_VERSION=\"${DRUPAL_VERSION}\"|g" "${APP_NAME}.profile.tmp"
echo
echo "Are you setting up a multilingual website? (y|n)"
if askyesno; then
	MULTILINGUAL='yes'
else
	MULTILINGUAL='no'
fi
# Write MULTILINGUAL
sed -i "s|MULTILINGUAL=.*$|MULTILINGUAL=\"${MULTILINGUAL}\"|g" "${APP_NAME}.profile.tmp"
if [ "$MULTILINGUAL" == "yes" ]; then
	echo "Enumerate the languages, comma-separated, starting with the default language:"
	echo "For example, you could type es,en"
	read -r LANGUAGES
	LANGUAGES_NO_WHITESPACE="$(echo -e "${LANGUAGES}" | tr -d '[[:space:]]')"
	# Write LANGUAGES
	sed -i "s|LANGUAGES=.*$|LANGUAGES=\"${LANGUAGES_NO_WHITESPACE}\"|g" "${APP_NAME}.profile.tmp"
fi
echo
echo "Will you be using a distribution or install profile? (y|n)"
if askyesno; then
	USE_INSTALL_PROFILE='yes'
else
	USE_INSTALL_PROFILE='no'
fi
# Write USE_INSTALL_PROFILE
sed -i "s|USE_INSTALL_PROFILE=.*$|USE_INSTALL_PROFILE=\"${USE_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile.tmp"
if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ]; then
	echo "Name of contrib distribution, or core profile?"
	echo "If you are using a custom profile, leave this empty now."
	echo "For example, here you could type 'bear', or 'minimal'"
	read -r D_O_INSTALL_PROFILE
	# Write D_O_INSTALL_PROFILE
	sed -i "s|D_O_INSTALL_PROFILE=.*$|D_O_INSTALL_PROFILE=\"${D_O_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile.tmp"
fi
if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
	echo "Custom profile name?"
	echo "You will be able to configure the Git-related information in a moment."
	read -r CUSTOM_INSTALL_PROFILE
	# Write CUSTOM_INSTALL_PROFILE
	sed -i "s|CUSTOM_INSTALL_PROFILE=.*$|CUSTOM_INSTALL_PROFILE=\"${CUSTOM_INSTALL_PROFILE}\"|g" "${APP_NAME}.profile.tmp"
fi
if [ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$D_O_INSTALL_PROFILE" == "" ] && [ "$CUSTOM_INSTALL_PROFILE" == "" ]; then
	echo "WARNING: You have not specified a profile name. The core standard profile will be used."
	echo "======="
fi
echo
if [ "$USE_INSTALL_PROFILE" == "yes" ]; then
	if [ "$CUSTOM_INSTALL_PROFILE" != "" ] || ([ "$D_O_INSTALL_PROFILE" != "" ] && [ "$D_O_INSTALL_PROFILE" != "standard" ] && [ "$D_O_INSTALL_PROFILE" != "minimal" ] && [ "$D_O_INSTALL_PROFILE" != "testing" ]); then
		echo "Are you using drush make? (y|n)"
		if [ "$D_O_INSTALL_PROFILE" != "" ]; then
			echo "Hint: a Drupal.org distribution usually does, so if in doubt, press 'y'"
		fi
		if askyesno; then
			USE_DRUSH_MAKE='yes'
		else
			USE_DRUSH_MAKE='no'
		fi
		# Write USE_DRUSH_MAKE
		sed -i "s|USE_DRUSH_MAKE=.*$|USE_DRUSH_MAKE=\"${USE_DRUSH_MAKE}\"|g" "${APP_NAME}.profile.tmp"
		if [ "$USE_DRUSH_MAKE" == "yes" ]; then
			if [ "$D_O_INSTALL_PROFILE" != "" ]; then
				echo "Makefile? [build-${D_O_INSTALL_PROFILE}.make]"
				echo "Hint: hit Enter if in doubt"
			elif [ "$CUSTOM_INSTALL_PROFILE" != "" ]; then
				echo "Makefile? [build-${CUSTOM_INSTALL_PROFILE}.make]"
				echo "Hint: hit Enter if in doubt"
			fi
			read -r DRUSH_MAKEFILE
			if [ "$DRUSH_MAKEFILE" == "" ]; then
				if [ "$D_O_INSTALL_PROFILE" != "" ]; then
					DRUSH_MAKEFILE="build-${D_O_INSTALL_PROFILE}.make"
				elif [ "$CUSTOM_INSTALL_PROFILE" != "" ]; then
					DRUSH_MAKEFILE="build-${CUSTOM_INSTALL_PROFILE}.make"
				fi
				echo "Makefile set to ${DRUSH_MAKEFILE}"
			fi
			# Write DRUSH_MAKEFILE
			sed -i "s|DRUSH_MAKEFILE=.*$|DRUSH_MAKEFILE=\"${DRUSH_MAKEFILE}\"|g" "${APP_NAME}.profile.tmp"
		else
			echo "Are you using composer? (y|n)"
			echo "Warning: support for composer is experimental"
			if askyesno; then
				USE_COMPOSER='yes'
			else
				USE_COMPOSER='no'
			fi
			# Write USE_COMPOSER
			sed -i "s|USE_COMPOSER=.*$|USE_COMPOSER=\"${USE_COMPOSER}\"|g" "${APP_NAME}.profile.tmp"
		fi
	fi
fi
echo
if [ "$USE_INSTALL_PROFILE" == "yes" ]; then
	echo "Are you using drush site-install? (y|n)"
	echo "Hint: an install profile usually needs this so, if in doubt, press 'y'"
	if askyesno; then
		USE_SITE_INSTALL='yes'
	else
		USE_SITE_INSTALL='no'
	fi
	# Write USE_SITE_INSTALL
	sed -i "s|USE_SITE_INSTALL=.*$|USE_SITE_INSTALL=\"${USE_SITE_INSTALL}\"|g" "${APP_NAME}.profile.tmp"
fi
echo
if [ "$USE_SITE_INSTALL" != "yes" ]; then
	echo "Are you importing the content from another Drupal site? (y|n)"
	echo "You will need to inform its remote host, user, and base path."
	if askyesno; then
		USE_UPSTREAM_SITE='yes'
	else
		USE_UPSTREAM_SITE='no'
	fi
	# Write USE_UPSTREAM_SITE
	sed -i "s|USE_UPSTREAM_SITE=.*$|USE_UPSTREAM_SITE=\"${USE_UPSTREAM_SITE}\"|g" "${APP_NAME}.profile.tmp"
	if [ "$USE_UPSTREAM_SITE" == "yes" ]; then
		#
		echo "Remote upstream host?"
		read -r REMOTE_UPSTREAM_HOST
		# Write REMOTE_UPSTREAM_HOST
		sed -i "s|REMOTE_UPSTREAM_HOST=.*$|REMOTE_UPSTREAM_HOST=\"${REMOTE_UPSTREAM_HOST}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Remote upstream port to SSH to (if not 22)? []"
		read -r REMOTE_UPSTREAM_PORT
		# Write REMOTE_UPSTREAM_PORT
		sed -i "s|REMOTE_UPSTREAM_PORT=.*$|REMOTE_UPSTREAM_PORT=\"${REMOTE_UPSTREAM_PORT}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Username to SSH into that remote host? []"
		read -r REMOTE_UPSTREAM_USER
		# Write REMOTE_UPSTREAM_USER
		sed -i "s|REMOTE_UPSTREAM_USER=.*$|REMOTE_UPSTREAM_USER=\"${REMOTE_UPSTREAM_USER}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Full site path in the remote host (docroot)?"
		read -r REMOTE_UPSTREAM_DOCROOT
		# Write REMOTE_UPSTREAM_DOCROOT
		sed -i "s|REMOTE_UPSTREAM_DOCROOT=.*$|REMOTE_UPSTREAM_DOCROOT=\"${REMOTE_UPSTREAM_DOCROOT}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "If using a bastion host (as in ProxyCommand ssh), enter its credentials: []"
		read -r REMOTE_UPSTREAM_PROXY_CREDENTIALS
		# Write REMOTE_UPSTREAM_PROXY_CREDENTIALS
		sed -i "s|REMOTE_UPSTREAM_PROXY_CREDENTIALS=.*$|REMOTE_UPSTREAM_PROXY_CREDENTIALS=\"${REMOTE_UPSTREAM_PROXY_CREDENTIALS}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Bastion host port to SSH to (if not 22)? []"
		read -r REMOTE_UPSTREAM_PROXY_PORT
		# Write REMOTE_UPSTREAM_PROXY_PORT
		sed -i "s|REMOTE_UPSTREAM_PROXY_PORT=.*$|REMOTE_UPSTREAM_PROXY_PORT=\"${REMOTE_UPSTREAM_PROXY_PORT}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Enter any other SSH options needed: []"
		read -r REMOTE_UPSTREAM_SSH_OPTIONS
		# Write REMOTE_UPSTREAM_SSH_OPTIONS
		sed -i "s|REMOTE_UPSTREAM_SSH_OPTIONS=.*$|REMOTE_UPSTREAM_SSH_OPTIONS=\"${REMOTE_UPSTREAM_SSH_OPTIONS}\"|g" "${APP_NAME}.profile.tmp"
		#
		echo "Are you rsync'ing files from this Drupal site? (y|n)"
		if askyesno; then
			SYNC_FILES='yes'
		else
			SYNC_FILES='no'
		fi
		# Write SYNC_FILES
		sed -i "s|SYNC_FILES=.*$|SYNC_FILES=\"${SYNC_FILES}\"|g" "${APP_NAME}.profile.tmp"
		if [ "$SYNC_FILES" == "yes" ]; then
			echo "Files path relative to the docroot? [sites/default/files]"
			read -r REMOTE_UPSTREAM_FILES_PATH
			if [ "$REMOTE_UPSTREAM_FILES_PATH" == "" ]; then
				REMOTE_UPSTREAM_FILES_PATH='sites/default/files'
				echo "Path set to ${REMOTE_UPSTREAM_FILES_PATH}"
			fi
			# Write REMOTE_UPSTREAM_FILES_PATH
			sed -i "s|REMOTE_UPSTREAM_FILES_PATH=.*$|REMOTE_UPSTREAM_FILES_PATH=\"${REMOTE_UPSTREAM_FILES_PATH}\"|g" "${APP_NAME}.profile.tmp"
		fi
		#
		echo "Are you sql-sync'ing the DB from this other Drupal site? (y|n)"
		if askyesno; then
			SYNC_DB='yes'
		else
			SYNC_DB='no'
		fi
		# Write SYNC_DB
		sed -i "s|SYNC_DB=.*$|SYNC_DB=\"${SYNC_DB}\"|g" "${APP_NAME}.profile.tmp"
	fi
	if [ "$SYNC_DB" != "yes" ]; then
		echo "NO to site install, NO to sync DB, means the only option left for the DB is a dump."
		echo "DB dump filename?"
		echo "This archive/file (the DB dump) is a SQL file, in plain text or gzipped, and must be present in ansible/playbooks/dbdumps."
		echo "For example, ${APP_NAME}.sql.gz"
		read -r DBDUMP
		# Write DBDUMP
		sed -i "s|DBDUMP=.*$|DBDUMP=\"${DBDUMP}\"|g" "${APP_NAME}.profile.tmp"
	fi
	if [ "$SYNC_FILES" != "yes" ]; then
		echo "NO to install profile, NO to sync files, means the only option left for the files is a tarball."
		echo "Files tarball filename?"
		echo "This archive can be a tar, a gzip, a bzip2 or a xz, and must be present in ansible/playbooks/files-tarballs."
		echo "For example, ${APP_NAME}-files.tar.gz"
		read -r FILES_TARBALL
		# Write FILES_TARBALL
		sed -i "s|FILES_TARBALL=.*$|FILES_TARBALL=\"${FILES_TARBALL}\"|g" "${APP_NAME}.profile.tmp"
	fi
fi
echo
if [ "$USE_INSTALL_PROFILE" != "yes" ] || ([ "$USE_INSTALL_PROFILE" == "yes" ] && [ "$CUSTOM_INSTALL_PROFILE" != "" ]); then
	echo "Will you be using a codebase tarball? (y|n)"
	if askyesno; then
		USE_CODEBASE_TARBALL='yes'
	else
		USE_CODEBASE_TARBALL='no'
	fi
	if [ "$USE_CODEBASE_TARBALL" == "yes" ]; then
		echo "Codebase tarball filename?"
		echo "This archive can be a tar, a gzip, a bzip2 or a xz, and must be located in ansible/playbooks/codebase-tarballs."
		echo "For example, ${APP_NAME}-codebase.tar.gz"
		read -r CODEBASE_TARBALL
		# Write CODEBASE_TARBALL
		sed -i "s|CODEBASE_TARBALL=.*$|CODEBASE_TARBALL=\"${CODEBASE_TARBALL}\"|g" "${APP_NAME}.profile.tmp"
	else
		echo "NO to install profile, and NO to codebase tarball, means the only option left for the codebase is Git (sorry, SVN not supported)."
		# GIT config values
		echo "Protocol to access your Git clone URL? (ssh|https|git|http)"
		read -r GIT_PROTOCOL
		# Write GIT_PROTOCOL
		sed -i "s/GIT_PROTOCOL=.*$/GIT_PROTOCOL=\"${GIT_PROTOCOL}\"/g" "${APP_NAME}.profile.tmp"
		echo "Git server name?"
		echo "For example, bitbucket.org"
		read -r GIT_SERVER
		# Write GIT_SERVER
		sed -i "s/GIT_SERVER=.*$/GIT_SERVER=\"${GIT_SERVER}\"/g" "${APP_NAME}.profile.tmp"
		echo "Git username who will be cloning the Drupal repository?"
		echo "For example, git"
		read -r GIT_USER
		# Write GIT_USER
		sed -i "s/GIT_USER=.*$/GIT_USER=\"${GIT_USER}\"/g" "${APP_NAME}.profile.tmp"
		echo "Git path of your Drupal repository?"
		echo "For example, mbarcia/drupsible-project.git"
		read -r GIT_PATH
		# Write GIT_PATH
		sed -i "s|GIT_PATH=.*$|GIT_PATH=\"${GIT_PATH}\"|g" "${APP_NAME}.profile.tmp"
		echo "Git password?"
		echo "(leave this empty if you use SSH deployment keys)"
		enter_password "GIT_PASS"
		# Write GIT_PASS
		if [ ! "$GIT_PASS" == "" ]; then
			mkdir -p "./ansible/secret/credentials/${APP_NAME}/git"
			touch "./ansible/secret/credentials/${APP_NAME}/git/${GIT_USER}"
			echo "${GIT_PASS}" > "./ansible/secret/credentials/${APP_NAME}/git/${GIT_USER}"
		fi
		echo "Branch/version of your codebase? [master]"
		read -r GIT_BRANCH
		if [ "$GIT_BRANCH" == "" ]; then
			GIT_BRANCH='master'
			echo "Branch/version set to master"
		fi
		# Write GIT_BRANCH
		sed -i "s|GIT_BRANCH=.*$|GIT_BRANCH=\"${GIT_BRANCH}\"|g" "${APP_NAME}.profile.tmp"
	fi
fi
echo
# Gather input about VM IP mode (static or dynamic)
IP_OPTION1='Static IP (Drupsible)'
IP_OPTION2='Static IP (Yours)'
IP_OPTION3='Dynamic IP (DHCP)'
echo "${IP_OPTION1} means Drupsible will generate and use a valid static IP."
echo "${IP_OPTION2} means you can type your own specific IP."
echo "${IP_OPTION3} means Drupsible will use DHCP to get an IP from "
echo "the DHCP server in your workstation's network."
echo
echo "Choose the first option if you are not sure what this means."
PS3="Regarding your VM's IP, please enter your choice: "
optionstring="${IP_OPTION1},${IP_OPTION2},${IP_OPTION3}"
# Save the current IFS (Internal Field Separator)
OIFS=$IFS
# New IFS
IFS=','
options=( $optionstring )
# Restore the IFS
IFS=${OIFS}
set $(dd if=/dev/urandom bs=2 count=1 2>/dev/null | od -An -tu1)
IP_ADDR_RANDOM="192.168.${1}.${2}"
IP_ADDR=""
select opt in "${options[@]}"
do
	case $opt in
        "${IP_OPTION1}")
			IP_ADDR="${IP_ADDR_RANDOM}"
            echo "Static IP ${IP_ADDR} has been assigned to your VM."
            break
            ;;
         "${IP_OPTION2}")
			echo "IP address? [${IP_ADDR_RANDOM}]"
			read -r IP_ADDR_CUSTOM
			if [ "$IP_ADDR_CUSTOM" == "" ]; then
				IP_ADDR_CUSTOM="${IP_ADDR_RANDOM}"
			fi
			IP_ADDR="${IP_ADDR_CUSTOM}"
	        echo "Static IP ${IP_ADDR_CUSTOM} has been assigned to your VM."
	        break
            ;;
        "${IP_OPTION3}")
			echo "${IP_OPTION3} makes it possible to access your local website from other workstations in your network."
			echo "With ${IP_OPTION3}, the VM will be provisioned but afterwards, in order to "
			echo "access your website, you will need to manually add the IP your /etc/hosts "
			echo "file (in Windows systems, this file can be found at "
			echo "C:\Windows\System32\drivers\etc\hosts)."
			echo
			echo "After your VM has been provisioned, run 'vagrant ssh' and type"
			echo "sudo ifconfig -a"
			echo "Take note of the inet address of your eth1 and add this line to /etc/hosts."
			echo "<ip_addr> ${HOSTNAME}.${DOMAIN}"
			echo
			echo "Add the same line to the etc/hosts of every workstation that needs access to your website."
			echo "Warning: the docroot and home folders of your VM will be shared with other machines within your network."
            break
            ;;
        *) echo "Invalid option"
        	;;
    esac
done
# Write IP_ADDR
sed -i "s|IP_ADDR=.*$|IP_ADDR=\"${IP_ADDR}\"|g" "${APP_NAME}.profile.tmp"

echo
# Gather input about https enabled
# HTTPS is currently available only on D7, so don't bother asking in D8
echo "Want your website deployed as HTTPS://, instead of just http://? (y|n)"
echo "HTTPS will require a few more minutes to process a self-signed certificate."
if [ "${DRUPAL_VERSION}" == '7' ]; then
	echo "Drupsible will install and configure securepages and patch D7's core, as instructed by securepages."
fi
if askyesno; then
	APP_HTTPS_ENABLED='yes'
else
	APP_HTTPS_ENABLED='no'
fi
# Write APP_HTTPS_ENABLED
sed -i "s|APP_HTTPS_ENABLED=.*$|APP_HTTPS_ENABLED=\"${APP_HTTPS_ENABLED}\"|g" "${APP_NAME}.profile.tmp"
echo
# Gather input about SMTP enabled
echo "Want to make use of a SMTP service? (y|n)"
echo "(you will next be asked for server, port, username and password)"
echo "Defaults are provided for using a free Gmail account."
if askyesno; then
	if [ "$APP_POSTFIX_CLIENT_ENABLED" != "yes" ]; then
		echo "SMTP server? [smtp.gmail.com]"
		read -r SMTP_SERVER
		if [ "$SMTP_SERVER" == "" ]; then
			SMTP_SERVER='smtp.gmail.com'
			echo "SMTP server set to smtp.gmail.com"
		fi
		# Write SMTP_SERVER
		sed -i "s/SMTP_SERVER=.*$/SMTP_SERVER=\"${SMTP_SERVER}\"/g" "${APP_NAME}.profile.tmp"
		echo "SMTP port? [587]"
		read -r SMTP_PORT
		if [ "$SMTP_PORT" == "" ]; then
			SMTP_PORT='587'
			echo "SMTP port set to 587"
		fi
		# Write SMTP_PORT
		sed -i "s/SMTP_PORT=.*$/SMTP_PORT=\"${SMTP_PORT}\"/g" "${APP_NAME}.profile.tmp"
		echo "SMTP username?"
		echo "For example, ${APP_NAME}@gmail.com"
		read -r SMTP_USER
		# Write SMTP_USER
		sed -i "s/SMTP_USER=.*$/SMTP_USER=\"${SMTP_USER}\"/g" "${APP_NAME}.profile.tmp"
		echo "SMTP password?"
		enter_password "SMTP_PASS"
		# Write SMTP_PASS to the secret dir
		if [ ! "${SMTP_PASS}" == "" ]; then
			mkdir -p "./ansible/secret/credentials/postfix/smtp_sasl_password_map/[${SMTP_SERVER}]:${SMTP_PORT}"
			touch "./ansible/secret/credentials/postfix/smtp_sasl_password_map/[${SMTP_SERVER}]:${SMTP_PORT}/${SMTP_USER}"
			echo "${SMTP_PASS}" > "./ansible/secret/credentials/postfix/smtp_sasl_password_map/[${SMTP_SERVER}]:${SMTP_PORT}/${SMTP_USER}"
		fi
	fi
fi
echo
# Gather input about varnish enabled
# Varnish does not perform SSL termination, so don't ask if HTTPS is enabled
if [ "$APP_HTTPS_ENABLED" != "yes" ]; then
	echo "Want your website deployed behind Varnish? (y|n)"
	echo "The provided configuration is production-ready and also 'safe for development' (your browser will get fresh content with Ctrl-F5)."
	if askyesno; then
		APP_VARNISH_ENABLED='yes'
	else
		APP_VARNISH_ENABLED='no'
	fi
	# Write APP_VARNISH_ENABLED
	sed -i "s|APP_VARNISH_ENABLED=.*$|APP_VARNISH_ENABLED=\"${APP_VARNISH_ENABLED}\"|g" "${APP_NAME}.profile.tmp"
fi
echo
#
# Connect to a new or existing ssh-agent
#
if ([ "$GIT_PASS" == "" ] && [ "$USE_INSTALL_PROFILE" != "yes" ]) || [ "$USE_UPSTREAM_SITE" == "yes" ]; then
	echo "SSH key filename (to git clone, and/or sync with the upstream host)? [$HOME/.ssh/id_rsa]"
	read -r KEY_FILENAME
	if [ "$KEY_FILENAME" == "" ]; then
		# Set key to default: ~/.ssh/id_rsa
		KEY_FILENAME="$HOME/.ssh/id_rsa"
		echo "Using key ${KEY_FILENAME}"
	fi
	# Write KEY_FILENAME
	sed -i "s|KEY_FILENAME=.*$|KEY_FILENAME=\"${KEY_FILENAME}\"|g" "${APP_NAME}.profile.tmp"
	if [ ! "$OSTYPE" = "darwin"* ]; then
		# Invoke ssh-agent script, applying bash expansion to the tilde
		./bin/ssh-agent.sh "${KEY_FILENAME/#\~/$HOME}"
	fi
fi
#
# Timezone configuration
#
# Try to detect current timezone in Mac, Cygwin and Linux
if hash systemsetup 2>/dev/null; then
	CURRENT_TZ=$(systemsetup -gettimezone | sed "s|.*Time Zone: \(.*/.*\)$|\1|g")
elif hash tzset 2>/dev/null; then
	CURRENT_TZ=$(tzset)
elif hash timedatectl 2>/dev/null; then
	CURRENT_TZ=$(timedatectl | grep "Time zone" | sed "s|.*Time zone: \(.*/.*\) (.*)$|\1|g")
else
	CURRENT_TZ=""
fi
if [ ! "${CURRENT_TZ}" == "" ]; then
	echo "Time Zone? [${CURRENT_TZ}]"
else
	echo "Time Zone?"
fi
read -r DRUPSIBLE_TZ
if [ "${DRUPSIBLE_TZ}" == "" ] && [ ! "${CURRENT_TZ}" == "" ]; then
	DRUPSIBLE_TZ=${CURRENT_TZ}
	echo "Time zone set to ${DRUPSIBLE_TZ}"
fi
# Write TIME_ZONE
sed -i "s|APP_TIME_ZONE=.*$|APP_TIME_ZONE=\"${DRUPSIBLE_TZ}\"|g" "${APP_NAME}.profile.tmp"
#
# Append last-mod
#
DATE_LEGEND=$(date +"%c %Z")
PHRASE="Last reconfigured on"
sed -i "s/${PHRASE}:.*$/${PHRASE}: ${DATE_LEGEND}/g" "${APP_NAME}.profile.tmp"
#
# Save the result of .profile.tmp in .profile
#
cp "${APP_NAME}.profile.tmp" "${APP_NAME}.profile"
# Remove temporary profile
rm "${APP_NAME}.profile.tmp"
#
# Generate Drupsible configuration
#
./bin/generate.sh "${APP_NAME}.profile"
exit
