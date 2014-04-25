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
vagrant up --provider=lxc
vagrant provision (required due to some Host/Domainname related Bugs)
vagrant halt
vagrant destroy 
```


## Servers

- Panel (vagrant ssh roketi-panel, panel.example.net)
- Webserver 1 (vagrant ssh roketi-webserver1, www.example.net)
- Mailserver 1 (vagrant ssh roketi-mailserver1, mail.example.net)-


## Puppet

- Modules in puppet-modules
- Data in puppet-data/<hostname>.yaml

