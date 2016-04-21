#!/bin/bash
#
# Make sure the specified SSH key file exists
#
ID_FILE="${1}"
if [ "${ID_FILE}" == "" ]; then
	ID_FILE="$HOME/.ssh/id_rsa"
fi
if [ ! -f "${ID_FILE}" ]; then
	echo "SSH key file not found: please run bin/ssh-agent.sh <valid-keyfile>" 
	echo "before proceeding with the plays."
	exit 2
fi
#
# Make sure there is connection to an SSH agent
#
SSH_AGENT_DATA="$HOME/.ssh-agent"
echo "Checking connection to SSH agent..."
# Only try with ssh-add if SSH_AUTH_SOCK is non-null and non-zero
if [ -n "$SSH_AUTH_SOCK" ]; then
	ssh-add -l &>/dev/null
fi
if ([ -n "$SSH_AUTH_SOCK" ] && [ $? -eq 2 ]) || [ -z "$SSH_AUTH_SOCK" ]; then
	# ssh-add exit status is 0 on success, 1 if the specified command fails, 
	# and 2 if ssh-add is unable to contact the authentication agent.
	echo "Connection not active: connecting to any previous SSH agent..."
	test -r "$SSH_AGENT_DATA" && eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
	if [ $? -ne 0 ]; then
		echo "Existing agent not found or not active: launching a new SSH agent..."
		(umask 066; ssh-agent > "${SSH_AGENT_DATA/#\~/$HOME}")
		echo "Connecting to it..."
		eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
		ssh-add -l &>/dev/null
		if [ $? -eq 2 ]; then
			echo "ERROR: Connection FAILED. Check your environment."
			exit 1
		elif [ $? -eq 0 ]; then
			echo "Connection successful."
		else 
			echo "Unknown error from ssh-add. Check your environment."
			exit 3
		fi
	fi
elif [ -n "$SSH_AUTH_SOCK" ] && [ $? -eq 0 ]; then
	echo "Connection successful."
fi
#
# Add specified SSH key
#
ssh-add "$ID_FILE"
if [ $? -eq 0 ]; then
	echo "SSH key was successfully added: you may proceed with Drupsible plays."
elif [ $? -eq 2 ]; then
	echo "ERROR: Connection to the SSH agent unexpectedly FAILED. Check your environment."
	exit 1
else 
	echo "Unknown error from ssh-add. Check your environment."
fi
