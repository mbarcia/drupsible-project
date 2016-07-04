#!/bin/bash
#
# Make sure the specified SSH key file exists
#
ID_FILE="${1}"
if [ "${ID_FILE}" == "" ]; then
	ID_FILE="$HOME/.ssh/id_rsa"
fi
if [ ! -f "${ID_FILE}" ]; then
	echo
	echo "Error: SSH key file not found!"
	echo "=============================="
	echo "Please run bin/ssh-agent.sh <valid-keyfile>"
	exit 2
fi

#
# Make sure there is connection to an SSH agent
#
SSH_AGENT_DATA="$HOME/.ssh-agent"
echo "Checking connection to SSH agent..."
# Only try with ssh-add if SSH_AUTH_SOCK is non-null and non-zero
if [ -n "$SSH_AUTH_SOCK" ]; then
	SSH_ADD_STATUS=$(ssh-add -l)
	FIRST="$?"
fi

if ([ -n "$SSH_AUTH_SOCK" ] && [ "$FIRST" -eq 2 ]) || [ -z "$SSH_AUTH_SOCK" ]; then
	# ssh-add exit status is 0 on success, 1 if the specified command fails,
	# and 2 if ssh-add is unable to contact the authentication agent.
	echo "SSH agent not in current session: trying stored connection..."
	test -r "$SSH_AGENT_DATA" && eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
	ssh-add -l &>/dev/null
	SECOND="$?"
	if [ "$SECOND" -ne 0 ]; then
		echo "Stored connection details not found or bogus: launching a new SSH agent..."
		(umask 066; ssh-agent > "${SSH_AGENT_DATA/#\~/$HOME}")
		echo "SSH agent launched, new connection details stored. Now connecting to it..."
		eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
		ssh-add -l &>/dev/null
		THIRD="$?"
		if [ "$THIRD" -eq 2 ]; then
			echo "ERROR: Connection FAILED. Check your environment."
			echo "================================================="
			exit 1
		elif [ "$THIRD" -eq 0 ]; then
			echo "Connection successful."
		fi
	else
		echo "Connected to existing SSH agent (from stored connection details)"
		echo "Adding the SSH key..."
	fi
elif [ -n "$SSH_AUTH_SOCK" ] && [ "$FIRST" -eq 0 ]; then
	echo "Connection successful."
fi
#
# Add specified SSH key, if not already present
#
if [ -z "${SSH_ADD_STATUS##*$ID_FILE*}" ]; then
	echo "SSH key already present. You may proceed with the Drupsible playbooks."
else
	ssh-add "$ID_FILE"
	FOURTH="$?"
	if [ "$FOURTH" -eq 0 ]; then
		echo "SSH key was added. You may proceed with the Drupsible playbooks."
	elif [ "$FOURTH" -eq 2 ]; then
		echo "ERROR: Connection FAILED. Check your environment."
		echo "================================================="
		exit 1
	fi
fi
