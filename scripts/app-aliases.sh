#
# Section added by Drupsible
#
# drupsible aliases
alias pitiribi-deploy='ansible-playbook -i /vagrant/ansible/inventory/pitiribi-local /vagrant/ansible/playbooks/deploy.yml -e "app_name=pitiribi app_target=local"'
alias pitiribi-config='ansible-playbook -i /vagrant/ansible/inventory/pitiribi-local /vagrant/ansible/playbooks/config.yml -e "app_name=pitiribi app_target=local"'
alias pitiribi-config-deploy='ansible-playbook -i /vagrant/ansible/inventory/pitiribi-local /vagrant/ansible/playbooks/config-deploy.yml -e "app_name=pitiribi app_target=local"'
#
# End of section by Drupsible
#
