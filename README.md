# drupsible-project
Drupsible is a DevOps tool for Drupal continuous delivery, based on Ansible. By using Drupsible, your team will be able to provision, import, integrate, deploy and maintain Drupal websites across complex infrastructures using a simple set of YAML configuration files.

Drupsible project is the starting point of Drupsible, and it is the only thing you need to download/clone, as every other component will be handled by Drupsible automatically.

# Requirements
## Local
* Any Windows, Linux or MacOS workstation, with VT-x/AMD-V enabled and 1G RAM free memory.
* A Virtual Machine provider
  * [Virtualbox](https://www.virtualbox.org/wiki/Downloads), or
  * VMWare Fusion or VMWare Workstation, or 
  * Parallels Desktop 10+ for Mac
* [Vagrant](http://www.vagrantup.com/downloads) 1.7.2+
  * requires commercial plug-in for VMWare
* [Git Bash](https://git-scm.com/download/win) (if you use Windows)
* [Check your BIOS](http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/) for virtualization must be enabled
* Have a GIT repository for your Drupal website codebase (code tarball/archive is not yet supported). Ideally, without sites/default/files in it!
* Have a DB dump of your Drupal website
* Optionally, have a separate files tarball/archive of sites/default/files
* Optionally, have a SSH key setup for your git repository

## Remote servers
All remote target servers must be Debian (wheezy/jessie) or Ubuntu (trusty/vivid) stock boxes.
In the future, Drupsible may run on other platforms.
In the future, Drupsible may share the server with other webapps.

# Basic usage

## Local
1.If you are on Windows, run Git Bash (as _administrator_)
1. Git clone drupsible-project and put it in a folder named after your project, like _~/myproject-drupsible_, or _~/drupsible/my-project_
```
git clone https://github.com/mbarcia/drupsible-project.git myproject-drupsible
cd myproject-drupsible
bin/configure.sh
vagrant up
```
1. Drupsible will start an interactive session, asking all the values needed.
1. After it is done asking, you can grab a cup of coffee and watch the tasks being run. 
1. Drupsible will finish in about 15 minutes (your mileage may vary). 
1. Now your VM is ready: point your browser to your website: http://local.domain (or https://local.domain). Voilà.
1. In your file manager (Windows Explorer look for \\LOCAL, or Samba shares), there will be a shared folder:
local.webdomain app - Current version of the Drupal website and the logs.
1. You will then be able to connect your IDE of choice to this folder, or use any editor to develop and test. After you are done, just commit to your GIT repository.

## Other target environments
Once your Drupal 7 website is working on your local, you can proceed to deploy to the upper environments.

1. Write your Ansible inventory for the target environment
1. Choose an Ansible controller server. A good starting point is to use the VM itself as a controller, since it has already provisioned and configured your local. However, it is wise to consider having a separate "production" Ansible controller.
1. In your controller, make sure you have your public key in ~/.ssh/id_rsa.pub. This key will authorize your Drupsible SSH connections to all the hosts.

### Email sending capability ###
Your Drupal website will need to send emails to notify the admin (and the registered users, if any) of several important events.
In order to do that, a SMTP service must be made available to PHP. Simply add something like this to ansible/inventory/host_vars/<target-server>.yml

```
# SMTP settings
smtp_server: 'smtp.gmail.com'
smtp_port: 587
smtp_user: 'me@gmail.com'
```
and Drupsible will automatically configure everything so the web server is ready to send out notification emails.

*Important* - Your admin_email (under app_env) must be accepted by your SMTP service. Most likely, your admin_email and your smtp_user will need to match.
And, if you want to use the Gmail SMTP service, you will have to [relax the security measures of your Gmail account]
(https://support.google.com/accounts/answer/6010255) to let Drupsible send emails via Gmail.

### Example
Say you are deploying your app to the live/prod environment from the VM. First, edit your new inventory (use hosts-local as a starting point). Second and last step, run the deploy playbook.
```
$ vagrant ssh
...
vagrant@local:~$ nano ansible/inventory/hosts-prod
vagrant@local:~$ ansible-playbook -i ansible/inventory/hosts-prod ansible/playbooks/bootstrap-deploy.yml
```
Once you ran that, subsequent deployments will be simpler, taking this form:
```
$ vagrant ssh
...
vagrant@local:~$ ansible-playbook -i ansible/inventory/hosts-prod ansible/playbooks/deploy.yml
```
### Restarting the local VM ###
Whenever your local VM may go down (ie. after your workstation has been restarted), you need to
```
$ vagrant up
```

### SSH-agent forwarding
When you need to deploy a new version of your web app, your console needs to run an ssh-agent prior to vagrant up/provision. 
This agent needs to load your GIT repo's SSH key, like this
```
bin/ssh-agent.sh <your-private-key-filename>
eval $(<~/.ssh-agent)
```
Drupsible will, from where the codebase needs to be cloned/checked-out, automatically present the credentials to the Git server.
