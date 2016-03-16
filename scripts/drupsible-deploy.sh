#!/bin/bash

export PYTHONUNBUFFERED=1 
export ANSIBLE_FORCE_COLOR=true 

APP_NAME="$1"
APP_TARGET="$2"
DEPLOY_ARGS="$3"
TAGS="$4"
SKIP_TAGS="$5"

ANSIBLE_PLAYBOOK="$HOME/ansible/playbooks/config-deploy.yml"
ANSIBLE_INVENTORY="$HOME/ansible/inventory/${APP_NAME}-${APP_TARGET}"
EXTRA_VARS="${DEPLOY_ARGS} app_name=${APP_NAME} app_target=${APP_TARGET}"

if [ ! -f $ANSIBLE_PLAYBOOK ]; then
	echo "Cannot find Ansible playbook at $ANSIBLE_PLAYBOOK."
	exit 1
fi

if [ ! -f $ANSIBLE_INVENTORY ]; then
	echo "Cannot find Ansible inventory at $ANSIBLE_INVENTORY."
	exit 1
fi

if [ -z "$TAGS" ]; then
	TAGS="all"
fi

echo "Running Drupsible configure and deploy playbook..."
echo "Inventory file: $ANSIBLE_INVENTORY"

if [ -z "$EXTRA_VARS" ]; then
	if [ -z "$SKIP_TAGS" ]; then
		ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --tags "$TAGS"
	else
		ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --tags "$TAGS" --skip-tags "$SKIP_TAGS"
	fi
else
	if [ -z "$SKIP_TAGS" ]; then
		ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --extra-vars "$EXTRA_VARS" --tags "$TAGS"
	else
		ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --extra-vars "$EXTRA_VARS" --tags "$TAGS" --skip-tags "$SKIP_TAGS"
	fi
fi 

if [ $? -eq 0 ]; then
	echo "Drupsible box has been provisioned and configured. Go to your app URL and have a happy development."
else  
	echo "Drupsible box has NOT been provisioned or configured."
	exit 1
fi
