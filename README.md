# drupsible-project
Drupsible project template for Drupal 7 websites.

# Requirements
## Local
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads) 
* [Vagrant](http://www.vagrantup.com/downloads) 1.7.2+
* [Git Bash](https://git-scm.com/download/win) (Windows)

## Remotes
Must all be Debian (wheezy/jessie) or Ubuntu (trusty/vivid) stock boxes.

# Usage

## Local
* Download a copy of (or git clone) drupsible-project and put it in a folder named after your project, like myproject-drupsible/
* Configure your Vagrantfile and inventory (more documentation about this coming up next)
* ssh-agent must be running so Ansible is able to authenticate yourself against external services like Github or Bitbucket
```
eval $(ssh-agent)
ssh-add
```
* Run "vagrant up" and point your browser to your website. Voilà.
* In your file manager (Windows Explorer look for \\LOCAL, or Samba shares), there will be a shared folder:
local.webdomain app - Current version of the Drupal website and the logs.

## Remote
* Once your Drupal 7 website is working on your local, choose an Ansible controller server. A good starting point is your VM itself, since it has already provisioned and configured your local. Just make sure ansible/secret/credentials/mysql/root/password remains the same accross projects if  targeting the same mysql host.
* In your target hosts, create a passwordless sudo account for your application. Also make sure it is part of the group sshusers and it can authenticate your private keys using a proper .ssh/authorized_keys (this will be provided by debops.bootstrap in the near future).
 
# Notes
* You can pass parameters through environment variables, like
```
DEPLOY_ARGS="build=thursday git_repo_user=mbarcia git_repo_pass=mypwd accept_hostkey=yes" vagrant up
```
* If something goes wrong, start from scratch
```
vagrant destroy -f; DEPLOY_ARGS="build=thursday git_repo_user=mbarcia git_repo_pass=mypwd accept_hostkey=yes" vagrant up
```
* If the VM is already up and running (check with vagrant status first), then vagrant up will have no effect. Just use vagrant provision:
```
DEPLOY_ARGS="git_repo_user=mbarcia git_repo_pass=mypwd accept_hostkey=yes" vagrant provision
```
You can also pass tags to the playbook:
```
DEPLOY_ARGS="git_repo_user=mbarcia git_repo_pass=mypwd accept_hostkey=yes" TAGS="deploy" vagrant provision
```
