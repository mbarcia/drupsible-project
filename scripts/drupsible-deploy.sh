#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

APP_NAME="$1"
APP_TARGET="$2"
DEPLOY_ARGS="$3"
TAGS="$4"
SKIP_TAGS="$5"
APP_FQDN="$6"
HOST_IP_ADDR="$7"

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
	echo "Drupsible box has been provisioned and configured, YAY!"
	echo "======================================================="
	if [ "$HOST_IP_ADDR" == "" ]; then
		echo "Make sure your local /etc/hosts is able to resolve the IP
		echo "properly, by following these steps:"
		echo "  1. Log into your VM with 'vagrant ssh'"
		echo "  2. Run 'sudo ifconfig -a', and take note of the eth1 IPv4"
		echo "	   address, and the MAC address (HWaddr) reported"
		echo "  3. Edit your /etc/hosts and add this line:"
		echo "     <IP> ${APP_FQDN}"
		echo "  4. Try to fix/reserve that same IP to the MAC address in your"
		echo "     LAN's DHCP server, so you don't have to change it later on"
	fi
	echo
	echo "Type http://${APP_FQDN} in your browser, and happy development!"
else
	echo "WARNING: Drupsible box has NOT been provisioned or configured"
	echo "============================================================="
	exit 1
fi
