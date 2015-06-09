#!/bin/bash

# Install Ansible and its dependencies if it's not installed already.
if [ -f /usr/bin/ansible ] || [ -f /usr/local/bin/ansible ]; then
	echo "Ansible is installed ($(ansible --version))"
else
	echo "Installing Ansible dependencies"
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get install -y git python python-dev python-setuptools python-pip python-netaddr
	# Make sure setuptools are installed crrectly.
	pip install setuptools --upgrade
	echo "Installing required python modules..."
	pip install paramiko pyyaml jinja2 markupsafe
fi

echo "Installing Ansible scripts in /usr/local/bin..."
pip install ansible
echo "Installing DebOps..."
pip install debops
