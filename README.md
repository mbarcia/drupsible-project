# drupsible-project

[![Join the chat at https://gitter.im/mbarcia/drupsible-project](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mbarcia/drupsible-project?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Drupsible is a DevOps tool for Drupal continuous delivery, based on Ansible. By using Drupsible, your team will be able to provision, import, integrate, deploy and maintain Drupal websites across complex infrastructures using a simple set of YAML configuration files.

Drupsible project is the starting point of Drupsible, and it is the only thing you need to download/clone, as every other component will be handled by Drupsible automatically.

# Requirements

## Local
* Any Windows, Linux or MacOS workstation
* 1G of free RAM, 6G of free disk space (or alternatively, 30G for the 'mbarcia/drupsible-large' VirtualBox box)
* A Virtual Machine provider
  * [Virtualbox](https://www.virtualbox.org/wiki/Downloads), or
  * VMWare Fusion or VMWare Workstation, or
  * Parallels Desktop 10+ for Mac
* [Vagrant](http://www.vagrantup.com/downloads) 1.8.1+
  * requires commercial plug-in for VMWare
* [Git Bash](https://git-scm.com/download/win) (only if you are on Windows)
* Make sure VT-x (or AMD-V) virtualization is enabled on the host machine
    * [I'm on a Linux host](http://www.cyberciti.biz/faq/linux-xen-vmware-kvm-intel-vt-amd-v-support/)
    * [I'm on a Windows host](http://amiduos.com/support/knowledge-base/article/how-can-i-get-to-know-my-processor-supports-virtualization-technology)
    * [I'm on a Mac host](http://kb.parallels.com/5653)

    This setting must be enabled for 64-bit OS guests like the Drupsible VM.
* If you want to import an ongoing development:
  * Have your Drupal website codebase. If using a tarball/archive, make sure the archive you provide produces index.php at the top-most level when decompressed (a.k.a. 'tarbomb') and does not include sites/default/files.
  * If using a Git repository, have a "deployment key" setup and present in your local workstation.
  * Have a separate files tarball/archive of sites/default/files. Make sure the archive you provide produces a files folder when decompressed.
  * Have a DB dump of your Drupal website. Make sure the SQL statements do NOT start with a CREATE DATABASE.
  * If your project is a distibution (using drush make and/or composer), you can also use Drupsible to manage it.
* If you want to try a Drupal distribution, type its name during bin/configure.sh when asked.

## Remote servers
All remote target servers must be Debian (jessie) or Ubuntu (trusty/xenial) stock boxes.
In the future, Drupsible may run on other *nix platforms.

# Basic usage

## Local
1. If you are on Windows, run Git Bash
1. Git-clone mbarcia/drupsible-project and put it in a folder named after your project, like _~/drupsible/my-project_

    ```
    cd ~/drupsible
    git clone https://github.com/mbarcia/drupsible-project.git myproject
    cd myproject
    ```
1. Run the configuration wizard

    ```
    . ./bin/configure.sh
    ```
1. Drupsible will start an interactive session, asking for the handful of values that really matter (app name, domain name, etc.).
1. Drupsible will
    1. create your app's drupsible profile in a file called myproject.profile
    2. setup SSH keys and SSH forwarding as needed
    2. customize your vagrant.yml for development (which you can edit further for advanced usage)
    3. create an Ansible inventory file for your local environment (which you can edit further for advanced usage)
    3. generate all the needed Ansible configuration for you
1. Next, run ```vagrant up```
1. Grab a cup of green tea, well deserved!
1. For one time only, it will download the drupsible box (~400M).
1. If your user is not admin, Vagrant should ask for your OS admin password
1. When you see it's done, you will see a message like this:

    ```
    ==> local: local.doma.in        : ok=493  changed=190  unreachable=0    failed=0
    ==> local: Drupsible box has been provisioned and configured, YAY!
    ==> local: =======================================================
    ```
1. Your Drupal app has been deployed! Point your browser to your website: http://local.doma.in. Voilà.
2. If your browser is not able to resolve local.doma.in, follow the instructions after the YAY! message and edit /etc/hosts if needed.

## Windows host support

There are a number of additional requirements depending on the version of Windows you're running

- [Git Bash](https://git-scm.com/download/win)
- Command prompt must be "Run as administrator" for Vagrant to automatically maintain the hosts file.
- If you're on a Professional/Enterprise version of Windows 8.1 or 10, make sure Hyper-V is disabled.
- .NET Framework 4 or higher (for Windows 7) and Windows Management Framework 3.0 (PowerShell 3) for versions of Windows under 8.1. PowerShell 3 is installed after installing Windows Management Framework 3.0 and rebooting.
- Make sure [long file names are supported](http://stackoverflow.com/questions/22575662/filename-too-long-in-git-for-windows) (by doing `git config --system core.longpaths true`) and [tune MAX_PATH on Windows 10](https://msdn.microsoft.com/en-us/library/aa365247.aspx#maxpath)
- If you are using a custom [VAGRANT_HOME](http://docs.vagrantup.com/v2/other/environmental-variables.html), ensure that the directory does not have a space in it. To properly set this env variable permanently, run the following command within an administration command prompt.

  ```
  setx VAGRANT_HOME "c:\vagrant\home\path" /M
  ```
  
## No multisite but multiple apps
Drupal is able to accomodate multiple applications in the same VM, that you may deploy to a single server in PROD as well. Just run

```
. ./bin/configure.sh myotherproject
```
answering to the questionnaire.
As a final step, simply run

```
vagrant provision
```
*Drupsible does not (on purpose) support the Drupal multisite approach, avoiding future pains and handling multiple Drupal websites in a more flexible way.*

### Comments and observations ###
* Your default credentials at http://local.doma.in/user/login are admin/drups1ble. You can override it later, per environment.
* If anything changes, ie. your Git credentials, run bin/configure.sh again but this time
    * You will be asked if you want to start over
    * Say no, and you will be automatically presented with the edition of `myproject.profile`
    * Edit your new value, save, and run `bin/generate.sh`
    * Run `vagrant provision` (instead of `vagrant up`)
* If you have chosen Dynamic IP for your VM, potentially all of the workstations in your LAN will be able to access your website docroot. Although this is considered a feature (and not a security hole!), please use with caution.
* If you use Static IP for your VMs, Drupsible will manage /etc/hosts for you (also on Windows), so you can access http(s)://local.doma.in immediately from your browser.
* If you want to customize more, please read section "Advanced usage" below.
* In your local environment, and on a per-app basis, Drupsible sets up these very handy shell aliases:
    * myproject-config
    * myproject-deploy
    * myproject-config-deploy
    You can even use these with tags or more extra-vars as if you were using `ansible-playbook`.
    Type `alias` at the command prompt for more info.

## Other target environments
Once your Drupal website is working on your local, you can proceed to deploy to the upper environments.

1. Write your Ansible inventory for the target environment. This inventory _must_ have 3 groups:

    ```
    myproject
    └── myproject-prod
        ├── deploy
        │   ├── web-server1
        │   ├── web-server2
        │   └── web-server3
        ├── mysql
        │   └── db-server
        └── varnish
            └── server1
    ```
    Check out the [local inventory](https://github.com/mbarcia/drupsible-project/blob/master/ansible/inventory/app_name-local) provided for details.
1. Choose an Ansible controller server. A good starting point is to use the VM itself as a controller, since it has already provisioned and configured your local. However, it is wise to consider having a separate "production" Ansible controller.
1. In your controller, make sure you have your public key in ~/.ssh/id_rsa.pub. This key will authorize your Drupsible SSH connections to all the hosts.

### Example
Say you are deploying your app to the live/prod environment, using the VM as the Ansible controller. Simply run the bootstrap-deploy playbook.

```
$ vagrant ssh
...
vagrant@local:~$ ansible-playbook -i ansible/inventory/<app_name>-prod ansible/playbooks/bootstrap-deploy.yml --extra-vars "app_name=<app_name> app_target=prod"
```
Once you've run that, subsequent deployments will be simpler, taking this form:

```
$ vagrant ssh
...
vagrant@local:~$ ansible-playbook -i ansible/inventory/<app_name>-prod ansible/playbooks/deploy.yml --extra-vars "app_name=<app_name> app_target=prod"
```
If you just want to re-configure, say a parameter in Varnish, you would just run the config playbook:

```
vagrant@local:~$ ansible-playbook -i ansible/inventory/<app_name>-prod ansible/playbooks/config.yml --extra-vars "app_name=<app_name> app_target=prod" --tags varnish
```
This will reconfigure Varnish, without triggering a new deployment of you Drupal webapp.

### Restarting the local VM ###
Whenever your local VM may go down (ie. after your workstation has been restarted), you need to `$ vagrant up` in your myproject directory.

# Developing on local

## Work your Drupal code
* On Windows Explorer, you will notice a new "LOCAL" server in your network when the Vagrant VM is up.
* On OSX Finder, Go->Connect to Server... and type `smb://Guest:@local.doma.in` in Server Address.
  A list with shared folders will display: mount (at least) the app share.

The app share is the important one, but you still have access to the home folder in case you want to make changes there.

Open `app` and you will see a list of folders, something like this:

```
logs
public_html
public\_html.20160114_1138
public_html.bak
public\_html.20160113_1452
```

`public\_html` and `public\_html.bak` are symbolic links to the matching `public\_html.<date>_<time>` folders. 

`public\_html` contains your Drupal codebase, to be edited with your favorite editor or sync'ed with your IDE workspace.

On OSX, you can mount the app share onto a local path, so it is easier to access by 3rd. party software, for example:
`mkdir -p /Users/me/drupsible/shares/mydrupal`
`sudo mount -t smbfs "smb://Guest:@local.doma.in/app" /Users/me/drupsible/shares/mydrupal`

## Work your Drupsible code
Under the roles share, you have access to edit all the Ansible roles that Drupsible uses. This is only intended for advanced users who want to modify the internals of Drupsible.

## Logs available!
The logs folder contains:
- access.log (Apache access log)
- drupal.log (Drupal syslog events)
- error.log (Apache error log

You can always disable syslog events in the ``ansible/playbooks/group_vars/<app_name>-local/deploy.yml`` deploy_syslog_enabled parameter (yes/no).

## Find Drupal performance bottlenecks with Blackfire.io
[Blackfire.io](https://blackfire.io) service can be used for free to assess performance of your Drupal website.

By default, Blackfire is not enabled. To enable it, set these values in `ansible/playbooks/group_vars/<app_name>/deploy.yml`: 
`deploy_blackfire_enabled: yes`, `blackfire_server_id`, `blackfire_server_token`, `blackfire_client_id`, and `blackfire_client_token`.

Register for free at [https://blackfire.io](https://blackfire.io), and look for those values (server/client IDs and tokens) in your account page.

Note: You may want to disable xdebug, adding `deploy_xdebug_enabled: no`

# Advanced customization
In line with Ansible's best practices, you can customize and override any value of your Drupsible stock/default by creating/editing any of the following:

* `ansible/playbooks/group_vars/<app_name>-<app_target>/all.yml`
* `ansible/playbooks/group_vars/<app_name>-<app_target>/deploy.yml`
* `ansible/playbooks/group_vars/<app_name>-<app_target>/varnish.yml`
* `ansible/playbooks/group_vars/<app_name>-<app_target>/mysql.yml`

You can also configure parameters which maybe global to the application under

 ```
 ansible/playbooks/group_vars/<app_name>/all.yml
 ```
or to the webservers group, no matter in which environment they are in

 ```
 ansible/playbooks/group_vars/<app_name>/deploy.yml
 ```

# Git keys and SSH-agent forwarding
If you are NOT using a codebase tarball/archive, and have your Drupal codebase in a Git repository, you are aware that, in order to deploy a new version of your codebase,

1. If you are using an encrypted private SSH key (which requires a passphrase), your terminal needs to be running an ssh agent with the key loaded.
1. If you are using an non-encrypted private SSH key (does not require a passphrase), it will be copied to the guest VM and be picked up by ssh automatically.
1. your Git repository will authorize Drupsible through the designated SSH deployment key. For a real world example, see the [docs at Bitbucket](https://confluence.atlassian.com/bitbucket/how-to-install-a-public-key-on-your-bitbucket-account-276628835.html).

The following is managed automatically by the bin/configure.sh script, so you will not need to worry. However, for the case of encrypted SSH keys, you can check that you have an SSH agent running, and that it has your private encrypted keys loaded with this command:

`ssh-add -l`

If nothings pops up, then your SSH agent needs to load your Git repository SSH key, like this

`. ./bin/ssh-agent.sh <your-private-key-filename>`

Drupsible will then present proper credentials to the Git server when the codebase needs to be cloned or checked out.
