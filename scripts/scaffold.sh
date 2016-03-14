#!/bin/bash
APP_NAME=$1
export PYTHONUNBUFFERED=1
if [ "$2" == "is_windows" ]; then
	echo "Vagrant scaffolding (Windows)..."
	# Create symlinks to keep the configuration in sync with the Vagrant host system
	if [ ! -d /home/vagrant/ansible ]; then
		mkdir /home/vagrant/ansible
	fi
	if [ ! -d /home/vagrant/ansible/inventory ]; then
		mkdir /home/vagrant/ansible/inventory
	fi
	if [ ! -L /home/vagrant/ansible/inventory/group_vars ]; then
		ln -s /vagrant/ansible/inventory/group_vars /home/vagrant/ansible/inventory/group_vars
	fi
	if [ ! -L /home/vagrant/ansible/playbooks ]; then
		ln -s /vagrant/ansible/playbooks /home/vagrant/ansible/playbooks
	fi
	# Copy inventory files
	for ENV in "-local" "-ci" "-qa" "-uat" "-prod"
	do
		# Ansible chokes on its permissions when synced with a Windows host
		cp "/vagrant/ansible/inventory/${APP_NAME}${ENV}" /home/vagrant/ansible/inventory/
		# Remove exec permission on the inventory file (Ansible does not allow it)
		chmod -x "/home/vagrant/ansible/inventory/${APP_NAME}${ENV}"
	done
	# Change owner (this cannot be done on a synced folder in Windows)
	chown -R vagrant:vagrant /home/vagrant/
else
	echo "Vagrant scaffolding (Linux)..."
	if [ ! -L /home/vagrant/ansible ]; then
		ln -s /vagrant/ansible /home/vagrant/ansible
	fi
fi
echo "Done with the scaffolding."
echo
