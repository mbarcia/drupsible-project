#!/bin/bash
ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
	test -r ~/.ssh-agent && eval "$(<~/.ssh-agent)" >/dev/null
	ssh-add -l &>/dev/null
	if [ "$?" == 2 ]; then
		(umask 066; ssh-agent > ~/.ssh-agent)
		eval "$(<~/.ssh-agent)" >/dev/null
	fi
fi

ssh-add "${1}"
