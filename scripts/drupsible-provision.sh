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
	echo "Vagrant scaffolding (general)..."
	if [ ! -d /etc/ansible ]; then
		mkdir /etc/ansible
	fi
	if [ ! -L /etc/ansible/requirements.yml ]; then
		ln -s /vagrant/ansible/requirements.yml /etc/ansible/requirements.yml
	fi
	echo "Vagrant scaffolding (Windows only)..."
	if [ "$2" == "is_windows" ]; then
		# Create symlinks to keep the configuration in sync with the Vagrant host system
		if [ ! -d /home/vagrant/ansible ]; then
			mkdir /home/vagrant/ansible
		fi
		if [ ! -d /home/vagrant/ansible/inventory ]; then
			mkdir /home/vagrant/ansible/inventory
		fi
		if [ ! -L /home/vagrant/ansible/playbooks ]; then
			ln -s /vagrant/ansible/playbooks /home/vagrant/ansible/playbooks
		fi
		if [ ! -L /home/vagrant/ansible/dbdumps ]; then
			ln -s /vagrant/ansible/dbdumps /home/vagrant/ansible/dbdumps
		fi
		if [ ! -L /home/vagrant/ansible/files-tarballs ]; then
			ln -s /vagrant/ansible/files-tarballs /home/vagrant/ansible/files-tarballs
		fi
		if [ ! -L /home/vagrant/ansible/inventory/host_vars ]; then
			ln -s /vagrant/ansible/inventory/host_vars /home/vagrant/ansible/inventory/host_vars
		fi
		if [ ! -L /home/vagrant/ansible/inventory/group_vars ]; then
			ln -s /vagrant/ansible/inventory/group_vars /home/vagrant/ansible/inventory/group_vars
		fi
	
		# Copy inventory file, as Ansible chokes on its permissions when synced 
		# with a Windows host
		cp /vagrant/ansible/inventory/hosts-local /home/vagrant/ansible/inventory/
		
		# Change owner (this cannot be done on a synced folder in Windows)
		chown -R vagrant:vagrant /home/vagrant/
	
		# Remove exec permission on the inventory file (Ansible does not allow it)
		chmod -x /home/vagrant/ansible/inventory/hosts-local
	else
		echo "Vagrant scaffolding (Linux only)..."
		if [ ! -L /home/vagrant/ansible ]; then
			ln -s /vagrant/ansible /home/vagrant/ansible
		fi
	fi
fi
#
# End Vagrant-specific
#

# Download Drupsible roles
echo "Installing Drupsible roles and its dependencies..."
if [ -f ~/ansible/requirements.yml ]; then
	ansible-galaxy install --ignore-errors -f -r ~/ansible/requirements.yml
elif [ -f /etc/ansible/requirements.yml ]; then
	ansible-galaxy install --ignore-errors -f -r /etc/ansible/requirements.yml
else
	echo "Drupsible requirements not found"
	exit -1
fi
