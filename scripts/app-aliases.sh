#
# Section added by Drupsible
#
# drupsible aliases
alias pitiribi-deploy='ansible-playbook -i ansible/inventory/pitiribi-local ansible/playbooks/deploy.yml -e "app_name=pitiribi app_target=local"'
alias pitiribi-config='ansible-playbook -i ansible/inventory/pitiribi-local ansible/playbooks/config.yml -e "app_name=pitiribi app_target=local"'
alias pitiribi-config-deploy='ansible-playbook -i ansible/inventory/pitiribi-local ansible/playbooks/config-deploy.yml -e "app_name=pitiribi app_target=local"'
#
# End of section by Drupsible
#
