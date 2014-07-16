# Roketi Hiera Demo

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  domain        = "vagrant"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "puppetlabs/debian-7.4-32-puppet"

  # vagrant-cachier
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
    config.cache.scope = :box
  else
    puts 'WARN: vagrant-cachier plugin not detected. Continuing unoptimized.'
  end

  # vagrant-hostmanager
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  else
    puts 'WARN: vagrant-hostmanager plugin not detected. Name based lookup will not work.'
  end

  # SSH Options
  config.ssh.forward_agent = true

  # Network Configuration
  config.vm.network "private_network", type: "dhcp"

  # execute Puppet
  config.vm.provision "puppet" do |puppet|
    puppet.hiera_config_path = "puppet-data/hiera.yaml"
    puppet.module_path       = [ "modules", "modules-contrib" ]
    puppet.options           = "--parser future -e 'include base'"
  end

  # define Servers
  vms = {
    :panel => {
      :alias => 'panel.example.net',
    },
    :webserver1 => {
      :alias => 'www.example.net www.example.com',
    },
    :mailserver1 => {
      :alias => 'mail.example.net',
    },
  }

  # create Servers
  vms.each_pair do |vm_name, vm_config|
    config.vm.define vm_name do |node|
      node.vm.hostname = vm_name.to_s
      node.hostmanager.aliases = vm_config[:alias]

      # custom IP Resolver because we need eth1 (private Network)
      node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        `vagrant ssh #{vm_name} -c "facter ipaddress_eth1"`.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
      end
    end
  end
end

