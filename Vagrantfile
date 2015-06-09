# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for Drupsible

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Minimum Vagrant version required
Vagrant.require_version ">= 1.6.4"

# Install required plugins if not present.
required_plugins = %w(vagrant-cachier vagrant-hostsupdater)
required_plugins.each do |plugin|
  need_restart = false
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    need_restart = true
  end
  exec "vagrant #{ARGV.join(' ')}" if need_restart
end

ANSIBLE_INVENTORY_DIR = 'ansible/inventory'

#
# Customize as needed
#

# Default Virtualbox .box
# Source: https://github.com/ginas/vagrant-debian-wheezy-64
BOX               = 'debian-wheezy-amd64-netinst'
BOX_URL           = 'https://dl.dropboxusercontent.com/u/55426468/20140317/debian-wheezy-amd64-netinst.box'

# Default Virtualbox parameters
GUI               = false # Enable/Disable GUI
RAM               = 128   # Default memory size in MB
PAE               = 'on'
ACPI              = 'on'
IOAPIC            = 'on'
CHIPSET           = 'ich9'

# Network configuration
DOMAIN            = ".local.example.com"
NETWORK           = "192.168.50."
NETMASK           = "255.255.255.0"

# These hosts must match your Ansible inventory
HOSTS = {
   "web" => [NETWORK+"10", 512, false, BOX, PAE, ACPI, IOAPIC, CHIPSET],
   "db" => [NETWORK+"11", 512, false, BOX, PAE, ACPI, IOAPIC, CHIPSET],
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  HOSTS.each do | (name, cfg) |
    ipaddr, ram, gui, box, pae, acpi, ioapic, chipset = cfg

    config.vm.define name do |machine|
      machine.vm.box     = box
      machine.vm.box_url = BOX_URL
      machine.vm.guest = :debian
      machine.vm.provider "virtualbox" do |vb|
        vb.gui    = gui
        vb.memory = ram
        # Configure misc settings
        vb.customize ['modifyvm', :id,
        '--rtcuseutc', 'on',
        '--natdnshostresolver1', 'on',
        '--nictype1', 'virtio',
        '--nictype2', 'virtio']
        vb.customize ["modifyvm", :id, "--pae", pae]
        vb.customize ["modifyvm", :id, "--acpi", acpi]
        vb.customize ["modifyvm", :id, "--ioapic", ioapic]
        vb.customize ["modifyvm", :id, "--chipset", chipset]
      end

      machine.vm.hostname = name + DOMAIN
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK

      # Add aliases of each host to /etc/hosts
      config.hostsupdater.aliases = []

      config.vm.provision "shell" do |sh|
        #if there a line that only consists of 'mesg n' in /root/.profile, replace it with 'tty -s && mesg n'
        sh.inline = "(grep -q -E '^mesg n$' /root/.profile && sed -i 's/^mesg n$/tty -s \\&\\& mesg n/g' /root/.profile && echo 'Ignore the previous error about stdin not being a tty. Fixing it now...') || exit 0;"
      end

      # Install Ansible on host named web, which becomes the controller
      if name.eql?'web' 
        machine.vm.provision "shell" do |sh|
          sh.path = "drupsible-install.sh"
        end
      end 

    end

  end # HOSTS-each

  # SSH setup
  # Vagrant >= 1.7.0 defaults to using a randomly generated RSA key.
  # We need to disable this in order to pass the correct identity from host to guest.
  config.ssh.insert_key = false
  # Allow identities to be passed from host to guest.
  config.ssh.forward_agent = true

  # Allow caching to be used (see the vagrant-cachier plugin)
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
    config.cache.auto_detect = false
    config.cache.enable :apt
    config.cache.enable :gem
    config.cache.enable :npm
  end

end
