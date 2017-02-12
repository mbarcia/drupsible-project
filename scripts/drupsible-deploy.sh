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

ANSIBLE_PLAYBOOK="/vagrant/ansible/playbooks/config-deploy.yml"
ANSIBLE_INVENTORY="/vagrant/ansible/inventory/${APP_NAME}-${APP_TARGET}"
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
  if [ "${HOST_IP_ADDR}" == "" ]; then
    echo "Make sure /etc/hosts (C:\Windows\System32\Drivers\etc\hosts)"
    echo "is able to resolve the IP properly, by following these steps:"
    echo "  1. Log into your VM with 'vagrant ssh'"
    echo "  2. Run 'sudo ifconfig -a', and take note of the eth1 IPv4"
    echo "     address, and the MAC address (HWaddr) reported"
    echo "  3. Edit your /etc/hosts and add this line:"
    echo "     <IP> ${APP_FQDN}"
    echo "  4. Try to fix/reserve IP to the MAC address in your LAN"
    echo "     DHCP server, so you don't have to change it later on."
  else
    echo "Verify that /etc/hosts (C:\Windows\System32\Drivers\etc\hosts)"
    echo "contains this line:"
    echo "${HOST_IP_ADDR}  ${APP_FQDN}  # VAGRANT ..."
  fi
  echo
  echo "On Finder, Go->Connect to Server and type smb://Guest:@${APP_FQDN} (at least mount the 'app' volume)."
  echo "On Explorer, find a \\\\LOCAL server under Network."
  echo
  echo "On your browser, go to http://${APP_FQDN} for your Drupal website."
  echo
  echo "Happy development!"
  echo
else
  echo "WARNING: Drupsible box has NOT been provisioned or configured"
  echo "============================================================="
  exit 1
fi
