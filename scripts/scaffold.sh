#!/bin/bash
APP_NAME=$1
export PYTHONUNBUFFERED=1
echo "Vagrant scaffolding"
# Create top ansible folder
if [ ! -d /home/vagrant/ansible ]; then
	mkdir /home/vagrant/ansible
fi
# Create the inventory folder
if [ ! -d /home/vagrant/ansible/inventory ]; then
	mkdir /home/vagrant/ansible/inventory
fi
# The inventory/group_vars folder can be a symlink
if [ ! -L /home/vagrant/ansible/inventory/group_vars ]; then
	ln -s /vagrant/ansible/inventory/group_vars /home/vagrant/ansible/inventory/group_vars
fi
# The playbooks folder can be a symlink
if [ ! -L /home/vagrant/ansible/playbooks ]; then
	ln -s /vagrant/ansible/playbooks /home/vagrant/ansible/playbooks
fi
# The secret folder needs to be created inside the guest OS
if [ ! -d /home/vagrant/ansible/secret ]; then
	mkdir /home/vagrant/ansible/secret
fi
# Copy ansible.cfg
if [ -f /vagrant/ansible.cfg ]; then
	cp /vagrant/ansible.cfg /home/vagrant
fi
# Copy (local) inventory file
cp "/vagrant/ansible/inventory/${APP_NAME}-local" /home/vagrant/ansible/inventory/
# Remove exec permission from it (Ansible tries to execute otherwise)
chmod -x "/home/vagrant/ansible/inventory/${APP_NAME}-local"
# Copy secrets (eventually gathered by configure.sh) to the guest OS
if [ -d /vagrant/ansible/secret ]; then
	cp -pr "/vagrant/ansible/secret" /home/vagrant/ansible/
fi
# Change owner (note that this cannot be done on a synced folder in Windows)
chown -R vagrant:vagrant /home/vagrant/
echo "Done with the scaffolding."
echo
