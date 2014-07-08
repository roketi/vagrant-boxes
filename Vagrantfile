# Roketi Hiera Demo
# 

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  domain        = "vagrant"
  network       = "192.168.55.0/24"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "puppetlabs/debian-7.4-32-puppet"

  # vagrant-cachier
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
    config.cache.scope = :box
  else
    puts 'WARN:  Vagrant-cachier plugin not detected. Continuing unoptimized.'
  end

  # vagrant-hostmanager
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end

  # SSH Options
  config.ssh.forward_agent = true

  # roketi-panel
  config.vm.define "roketi-panel" do  |node|
    name          = "roketi-panel"
    aliases       = "panel.example.net"

    # vagrant-hostmanager
    if Vagrant.has_plugin?('vagrant-hostmanager')
      # get current ip address
      node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if hostname = (vm.ssh_info && vm.ssh_info[:host])
          `vagrant ssh roketi-panel -c "facter ipaddress"`.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
        end
      end

      # set Aliases
      if not aliases.to_s.empty?
        node.hostmanager.aliases = name.to_s + " " + aliases.to_s
      end

      # Run the hostmanager plugin
      node.vm.provision :hostmanager
    end

    # set Hostname
    node.vm.hostname =  "%s.#{domain}" % name.to_s

    # execute Puppet
    node.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet-data/hiera.yaml"
      puppet.manifests_path    = "puppet-data"
      puppet.module_path       = "puppet-modules"
    end
  end

  # roketi-webserver1
  config.vm.define "roketi-webserver1" do  |node|
    name          = "roketi-webserver1"
    aliases       = "www.example.com www.example.net"

    # vagrant-hostmanager
    if Vagrant.has_plugin?('vagrant-hostmanager')
      # get current ip address
      node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if hostname = (vm.ssh_info && vm.ssh_info[:host])
          `vagrant ssh roketi-webserver1 -c "facter ipaddress"`.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
        end
      end

      # set Aliases
      if not aliases.to_s.empty?
        node.hostmanager.aliases = name.to_s + " " + aliases.to_s
      end

      # Run the hostmanager plugin
      node.vm.provision :hostmanager
    end

    # set Hostname
    node.vm.hostname =  "%s.#{domain}" % name.to_s

    # execute Puppet
    node.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet-data/hiera.yaml"
      puppet.manifests_path    = "puppet-data"
      puppet.module_path       = "puppet-modules"
    end
  end

  # roketi-mailserver1
  config.vm.define "roketi-mailserver1" do  |node|
    name          = "roketi-mailserver1"
    aliases       = "mail.example.net"

    # vagrant-hostmanager
    if Vagrant.has_plugin?('vagrant-hostmanager')
      # get current ip address
      node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if hostname = (vm.ssh_info && vm.ssh_info[:host])
          `vagrant ssh roketi-mailserver1 -c "facter ipaddress"`.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
        end
      end

      # set Aliases
      if not aliases.to_s.empty?
        node.hostmanager.aliases = name.to_s + " " + aliases.to_s
      end

      # Run the hostmanager plugin
      node.vm.provision :hostmanager
    end

    # set Hostname
    node.vm.hostname =  "%s.#{domain}" % name.to_s

    # execute Puppet
    node.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet-data/hiera.yaml"
      puppet.manifests_path    = "puppet-data"
      puppet.module_path       = "puppet-modules"
    end
  end
end

