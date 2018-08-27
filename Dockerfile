#
# Dockerfile for building all 3 containers provisioned by Ansible.
#
# Run with --build-arg tags=provision for base image build
#

ARG fromimage

FROM ${fromimage}

ARG limitgroup
ARG tags=all
ARG skiptags
ARG playbook='config-deploy.yml'
ARG ansibleversion='2.3.3.0'

LABEL maintainer "Mariano Barcia <mariano.barcia@gmail.com>"

ADD . /drupsible

WORKDIR /drupsible

RUN apt-get update && apt-get install -y \
  curl \
  git \
  libssl-dev \
  libreadline-gplv2-dev \
  libffi-dev \
  python \
  python-dev \
  python-setuptools \
  python-pip \
  python-netaddr \
  sudo \
  unzip \
  zlib1g-dev \
# Debops reqs
  libldap2-dev \
  libsasl2-dev \
# Drupsible reqs
  mysql-client \
  && rm -rf /var/lib/apt/lists/*
# Make sure setuptools are installed correctly.
RUN python -m pip install --upgrade setuptools setupext-pip
# Upgrade criptography before pyOpenSSL
RUN python -m pip install --upgrade 'cryptography>2.1.4'
# Install pyOpenSSL before pip
RUN python -m easy_install --upgrade pyOpenSSL
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade --no-cache-dir paramiko PyYAML Jinja2 httplib2 six markupsafe
RUN python -m pip install ansible==${ansibleversion}

# DebOps
RUN python -m pip install debops
RUN ansible-galaxy install -f -r /drupsible/ansible/requirements.yml

RUN ansible-playbook -vvvv \
  --inventory ansible/inventory/mydocker-local\
  --limit ${limitgroup}\
  --tags "${tags}"\
  --skip-tags "${skiptags}"\
  --extra-vars "app_name=mydocker app_target=local app_in_cloud=yes app_in_container=yes"\
  ansible/playbooks/${playbook}
