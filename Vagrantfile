# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "generic/ubuntu1804"

  # Create 2 nodes
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      # Configure memory and cpus for virtual box
      node.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
      end
      # Set private network address to 192.168.33.100 + i
      node.vm.network :private_network, ip: "192.168.33.1#{i}"
      node.vm.provision :shell, :path => "bootstrap.sh"
      # Now do submodule / Virtual host specific setups
      # run through submodule configs for both nodes
      submodconfigArray = Dir['**/submodconfig.sh']
      submodconfigArray.each {
        |fname|
        node.vm.provision :shell, :path => fname
      }
      # finally do any post processing after submodules are configured
      node.vm.provision :shell, :path => "postboot.sh"
      # and set the synced_folder for access to the source
      config.vm.synced_folder "../", "/Development/GeniusTokens/"
    end
  end

end
