#!/bin/bash
export PYTHONUNBUFFERED=1
# Install Ansible and its dependencies if it's not installed already.
if [ -f /usr/bin/ansible ] || [ -f /usr/local/bin/ansible ]; then
	echo "Ansible is installed ($(ansible --version))"
	pip install --upgrade pip
else
	echo "Installing Ansible dependencies..."
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get install -y zlib1g-dev libssl-dev libreadline-gplv2-dev libffi-dev
	apt-get install -y curl unzip
	apt-get install -y git python python-dev python-setuptools python-pip python-netaddr
	# Make sure setuptools are installed correctly.
	pip install --upgrade pip
	pip install setuptools setupext-pip --upgrade
	pip install cryptography --upgrade
	pip install paramiko PyYAML Jinja2 httplib2 six markupsafe
	pip install ansible==2.0.2.0
fi
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
