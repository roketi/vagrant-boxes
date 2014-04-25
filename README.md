# Roketi Vagrant Boxes


## Requirements

* SSH
* GIT
* LXC
* Vagrant
    * http://www.vagrantup.com/downloads.html
* Vagrant Plugins

```
vagrant plugin install vagrant-cachier
vagrant plugin install hostmanager
vagrant plugin install vagrant-lxc
```


## Usage

```
vagrant up
vagrant provision
vagrant halt
vagrant destroy 
```


## Puppet

- Modules in puppet-modules
- Data in puppet-data/<hostname>.yaml

