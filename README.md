# drupsible-project
Drupsible is a DevOps tool for Drupal continuous delivery, based on Ansible. By using Drupsible, your team will be able to provision, import, integrate, deploy and maintain Drupal websites across complex infrastructures using a simple set of YAML configuration files.

Drupsible project is the starting point of Drupsible, and it is the only thing you need to download/clone, as every other component will be handled by Drupsible automatically.

# Requirements
## Local
* Any Windows, Linux or MacOS workstation, with VT-x/AMD-V enabled
* 1G of free RAM, 10G of free disk space
* A Virtual Machine provider
  * [Virtualbox](https://www.virtualbox.org/wiki/Downloads), or
  * VMWare Fusion or VMWare Workstation, or 
  * Parallels Desktop 10+ for Mac
* [Vagrant](http://www.vagrantup.com/downloads) 1.7.2+
  * requires commercial plug-in for VMWare
* [Git Bash](https://git-scm.com/download/win) (only if you are on Windows)
* [Check your BIOS](http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/) for virtualization, it must be enabled
* If you want to import an ongoing development:
  * Have your Drupal website codebase, either managed through a GIT repository or simply stored in a tarball/archive. Ideally, without sites/default/files in it!.
  * Optionally, have a SSH key setup for your Git repository.
  * Have a DB dump of your Drupal website.
  * Optionally, have a separate files tarball/archive of sites/default/files.
* If you want to try a Drupal distribution, 
  * you will be able to type its name (interactively) and 
  * run it locally in no time.

## Remote servers
All remote target servers must be Debian (wheezy/jessie) or Ubuntu (trusty/vivid) stock boxes (although currently testing Jessie only). 
In the future, Drupsible may run on other platforms. In the future, Drupsible may share the server with other webapps.

# Basic usage

## Local
1. If you are on Windows, run Git Bash (as _administrator_)
1. Git clone drupsible-project and put it in a folder named after your project, like _~/myproject-drupsible_, or _~/drupsible/my-project_
```
git clone https://github.com/mbarcia/drupsible-project.git myproject
cd myproject
bin/configure.sh
```
1. Drupsible will start an interactive session, asking for the handful of values that really matter (app name, domain name, etc.).
1. Next, run ```vagrant up``` and Drupsible will start working hard. 
1. Grab a cup of coffee while you watch the tasks being run. 
1. When you see it's done, you will see a message like this:
```
==> local: local.<domain>        : ok=493  changed=190  unreachable=0    failed=0
==> local: Drupsible box has been provisioned and configured. Go to your app URL and have a happy development.
```

* Your VM will be ready: point your browser to your website: http://local.domain (or https://local.domain). Voilà.
* In your file manager (Windows Explorer look for \\LOCAL, or Samba shares), there will be a shared folder:
local.webdomain app - Current version of the Drupal website and the logs.
* You will then be able to connect your IDE of choice to this folder, or use any editor to develop and test. After you are done, just commit to your GIT repository.
* If anything changes, ie. your Git credentials, run bin/configure.sh again but this time
  * You will be automatically presented with the edition of ```<app_name>.profile```
  * After saving ```<app_name>.profile```, run ```vagrant provision``` (instead of ```vagrant up```)
* If you want to customize more, please read section "Advanced usage" below. 

## Other target environments
Once your Drupal 7 website is working on your local, you can proceed to deploy to the upper environments.

1. Write your Ansible inventory for the target environment
1. Choose an Ansible controller server. A good starting point is to use the VM itself as a controller, since it has already provisioned and configured your local. However, it is wise to consider having a separate "production" Ansible controller.
1. In your controller, make sure you have your public key in ~/.ssh/id_rsa.pub. This key will authorize your Drupsible SSH connections to all the hosts.

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
If you just want to re-configure, say a parameter in Varnish, you would just run the config playbook:
```
vagrant@local:~$ ansible-playbook -i ansible/inventory/hosts-prod ansible/playbooks/config.yml
```
This will reconfigure Varnish, without triggering a new deployment of you Drupal webapp. 

### Restarting the local VM ###
Whenever your local VM may go down (ie. after your workstation has been restarted), you need to
```
$ vagrant up
```
in your myproject directory.
# Advanced usage
## Advanced customization
In line with Ansible's best practices, you can customize and override any value of your Drupsible stock/default by creating and editing any of the following:
* ```ansible/playbooks/group_vars/<role>.yml```
* ```ansible/playbooks/host_vars/<host>.yml```

A good example (SMTP) follows.
### Email sending capability ###
Your Drupal website will need to send emails to notify the admin (and the registered users, if any) of several important events.

In order to do that, a SMTP service must be made available to PHP. The default behavior is to relay all email to the MX host of the domain. But what if that's not what you want?

Say you would like to send emails trough Gmail. Simply add something like this to ansible/playbooks/group_vars/drupsible_deploy.yml

```
# SMTP settings
smtp_server: 'smtp.gmail.com'
smtp_port: 587
smtp_user: '<username>@gmail.com'
```
and Drupsible will automatically configure everything so the web server is ready to send out notification emails.

*Important* - Your admin_email (under app_env) must be accepted by your SMTP service. Most likely, your admin_email and your smtp_user will have to match.
And, if you want to use the Gmail SMTP service, you will have to [relax the security measures of your Gmail account]
(https://support.google.com/accounts/answer/6010255) to let Drupsible send emails via Gmail.

## Git keys and SSH-agent forwarding

If you are NOT using a codebase tarball/archive, and have your Drupal codebase in a Git repository, you are aware that, in order to deploy a new version of your codebase,
 
1. your session needs to be running an ssh-agent. 
1. your Git repository needs to authorize Drupsible through your public key. For a real world example, see the [docs at Bitbucket](https://confluence.atlassian.com/bitbucket/how-to-install-a-public-key-on-your-bitbucket-account-276628835.html).

The following is managed automatically by the bin/configure.sh script, so you will not need to worry. However, just in case you are not using configure.sh, you can check that you have an SSH agent running, and that it has your private keys loaded with this command:
```
ssh-add -l
``` 

If nothings pops up, then your SSH agent needs to load your Git repository SSH key, like this
```
bin/ssh-agent.sh <your-private-key-filename>
eval $(<~/.ssh-agent)
```
Drupsible will, from where the codebase needs to be cloned/checked-out, automatically present the credentials to the Git server.
### Note to OSX users
You will see a few errors in Drupsible 1.9.2, but the keychain in OSX has some advantages, so just make sure you private key is in the keychain and you will be fine.
Also, config backups are not being made. Expect these pitfalls to be fixed in Drupsible 0.9.3.

