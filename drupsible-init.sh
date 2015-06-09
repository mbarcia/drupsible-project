#!/bin/bash

# Usage info
show_help() {
cat << EOF
usage: ${0##*/} [-h] project-name
Scaffolding for a Drupsible project.

    -h          Shows this help text
EOF
} 

while getopts "h" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        \?)
            show_help >&2
            exit 1
            ;;
    esac
done

debops-update

PROJECT=$1
if [ -z "$PROJECT" ]; 
then
	echo "Please specify a project name."
else
	echo "Configuring Drupsible for $PROJECT..."
	debops-init ../$PROJECT
	cp ansible/requirements.yml ../$PROJECT/ansible/
	cd ../$PROJECT/ansible
	ansible-galaxy install -f -r requirements.yml
	cd -
fi
