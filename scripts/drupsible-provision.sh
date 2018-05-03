#!/bin/bash
export PYTHONUNBUFFERED=1

ANSIBLE_VERSION="2.3.0.0"
ANSIBLE_UPGRADE="no"

# Install Ansible and its dependencies if it's not installed already.
if [ -f /usr/bin/ansible ] || [ -f /usr/local/bin/ansible ]; then
	ANSIBLE_VERSION_PACKED=$(ansible --version | grep "ansible 2" | sed 's/^ansible \(.*$\)/\1/g')
	if [ "$ANSIBLE_VERSION" == "$ANSIBLE_VERSION_PACKED" ]; then
		echo "Ansible is installed ($ANSIBLE_VERSION_PACKED)"
		pip install --upgrade pip
	else
		ANSIBLE_UPGRADE="yes"
	fi
fi

if [ "$ANSIBLE_UPGRADE" == "yes" ]; then
	echo "Installing Ansible dependencies..."
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get install -y zlib1g-dev libssl-dev libreadline-gplv2-dev libffi-dev
	apt-get install -y curl unzip
	apt-get install -y git python python-dev python-setuptools python-pip python-netaddr
    # Upgrade criptography before pyOpenSSL
    pip install --upgrade 'cryptography>2.1.4'
    # Install pyOpenSSL before pip
    python -m easy_install --upgrade pyOpenSSL
    pip install --upgrade pip
    # Make sure setuptools are installed correctly.
    pip install --upgrade setuptools setupext-pip
    pip install --upgrade paramiko PyYAML Jinja2 httplib2 six markupsafe
	# Jinja2 2.9 to 2.9.6 breaks Ansible 2.3.0.0 
	# See https://github.com/ansible/ansible/issues/20063 
    # Ansible version next to 2.3.0.0 will fix this
    if [ "$ANSIBLE_VERSION" == "2.3.0.0" ]; then
        pip install -U 'jinja2<2.9'
    fi
	echo "Installing Ansible $ANSIBLE_VERSION..."
	pip install ansible=="${ANSIBLE_VERSION}"
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
