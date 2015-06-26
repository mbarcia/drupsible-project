#!/bin/bash

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
echo "Installing DebOps..."
pip install debops

#
# Vagrant-specific
#

if [ "$1" == 'vagrant' ]; then
	echo "Vagrant scaffolding..."

	# Create symlinks to keep the configuration in sync with the Vagrant host system
	mkdir /etc/ansible
	mkdir /home/vagrant/ansible
	mkdir /home/vagrant/ansible/inventory
	ln -s /vagrant/ansible/inventory/host_vars /home/vagrant/ansible/inventory/host_vars
	ln -s /vagrant/ansible/inventory/group_vars /home/vagrant/ansible/inventory/group_vars
	ln -s /vagrant/ansible/drupsible-playbook.yml /home/vagrant/ansible/drupsible-playbook.yml
	ln -s /vagrant/secret /home/vagrant/secret
	ln -s /vagrant/ansible/drupsible-requirements.yml /etc/ansible/drupsible-requirements.yml

	# Copy inventory file, as Ansible chokes on its permissions when synced 
	# with a Windows host
	cp /vagrant/ansible/inventory/vagrant_ansible_inventory /home/vagrant/ansible/inventory/
	
	#
	# Change owner (this cannot be done on a synced folder in Windows)
	chown -R vagrant:vagrant /home/vagrant/

	# Remove exec permission on the inventory file (Ansible does not allow it)
	chmod -x /home/vagrant/ansible/inventory/vagrant_ansible_inventory
fi
#
# End Vagrant-specific
#

# Download Drupsible roles
echo "Installing Drupsible roles and its dependencies..."
if [ -f ~/ansible/drupsible-requirements.yml ]; then
	ansible-galaxy install -f -r ~/ansible/drupsible-requirements.yml
elif [ -f /etc/ansible/drupsible-requirements.yml ]; then
	ansible-galaxy install -f -r /etc/ansible/drupsible-requirements.yml
fi
