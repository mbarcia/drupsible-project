#!/bin/sh

# Enables SSH in the docker container (phusion)
rm -f /etc/service/sshd/down
ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key
