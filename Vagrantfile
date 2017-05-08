# -*- mode: ruby -*-
# vi: set ft=ruby :

# Inspired by:
# https://github.com/spiritix/vagrant-php7

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  # Network configuration:
  config.vm.network "private_network", ip: "192.168.100.100"

  config.vm.synced_folder ".", "/vagrant",
    create: true,
    id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  # Run this shell script when setting up the machine:
  config.vm.provision :shell, path: "bootstrap.sh"

end
