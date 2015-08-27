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

Note: A fresh install with drush make or drush site-install is not yet supported, but will be soon
## Remotes
All remote target servers must be Debian (wheezy/jessie) or Ubuntu (trusty/vivid) stock boxes.
In the future, Drupsible may run on other platforms.
In the future, Drupsible may share the server with other webapps.

# Usage

## Local
* Git clone drupsible-project and put it in a folder named after your project, like _~/myproject-drupsible_, or _~/drupsible/my-project_
```
git clone git@github.com:mbarcia/drupsible-project.git myproject-drupsible
cd myproject-drupsible
bin/up.sh
```
* Grab a cup of coffee, or watch the tasks on the screen narrated by the cow. Drupsible will finish in about 15 minutes (your mileage may vary).
* Point your browser to your website: http://local.domain. Voilà.
* In your file manager (Windows Explorer look for \\LOCAL, or Samba shares), there will be a shared folder:
local.webdomain app - Current version of the Drupal website and the logs.
You will then be able to connect your IDE of choice to this folder, or use any editor to develop and test. After you are done, just commit to your GIT repository.
## Remote
* Once your Drupal 7 website is working on your local, write your Ansible inventory for the environment you want to build and choose an Ansible controller server. A good starting point is to use the VM itself as a controller, since it has already provisioned and configured your local.
* In your target host/s, create a passwordless sudo account for your application. Also make sure it is part of the group sshusers and it can authenticate your private keys using a proper .ssh/authorized_keys.
* Example: Say you are deploying your app to the live/prod environment from the VM. First, edit your new inventory (use hosts-local as a starting point). Second and last step, run the deploy playbook.
```
$ vagrant ssh
...
vagrant@local:~$ nano ansible/inventory/hosts-prod
vagrant@local:~$ ansible-playbook -i ansible/inventory/hosts-prod ansible/playbooks/config-n-deploy.yml
```
