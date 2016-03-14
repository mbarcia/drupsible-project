#!/bin/bash
export PYTHONUNBUFFERED=1
# Install Ansible and its dependencies if it's not installed already.
if [ -f /usr/bin/ansible ] || [ -f /usr/local/bin/ansible ]; then
	echo "Ansible is installed ($(ansible --version))"
else
	echo "Installing Ansible dependencies..."
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
echo "Installing Debops support..."
pip install debops
# Download Drupsible roles
echo "Installing Drupsible roles and its dependencies..."
if [ -f /vagrant/ansible/requirements.yml ]; then
	ansible-galaxy install -r /vagrant/ansible/requirements.yml
elif [ -f /etc/ansible/requirements.yml ]; then
	ansible-galaxy install -r /etc/ansible/requirements.yml
else
	echo "Drupsible requirements not found"
	exit -1
fi
# Workaround to Ansible bug https://github.com/ansible/ansible-modules-core/issues/2585 
sed -i "s|errno.EEXISTS|errno.EEXIST|g" /usr/local/lib/python2.7/dist-packages/ansible/modules/core/files/file.py
