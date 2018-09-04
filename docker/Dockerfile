#
# Dockerfile for building all 3 containers provisioned by Ansible.
#
# Run with --build-arg tags=provision for base image build
#

ARG from_image

FROM ${from_image}

LABEL maintainer "Mariano Barcia <mariano.barcia@gmail.com>"

RUN apt-get update && apt-get install -y \
  git \
  python \
  sudo
  
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/service/sshd/down
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
