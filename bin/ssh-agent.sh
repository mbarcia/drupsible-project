#!/bin/bash
SSH_AGENT_DATA="$HOME/.ssh-agent"
ID_FILE="${1}"
if [ "${ID_FILE}" == "" ]; then
	ID_FILE="$HOME/.ssh/id_rsa"
fi

ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
	test -r "$SSH_AGENT_DATA" && eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
	ssh-add -l &>/dev/null
	if [ "$?" == 2 ]; then
		(umask 066; ssh-agent > "${SSH_AGENT_DATA/#\~/$HOME}")
		eval "$(<${SSH_AGENT_DATA/#\~/$HOME})" >/dev/null
	fi
fi

ssh-add "$ID_FILE"
