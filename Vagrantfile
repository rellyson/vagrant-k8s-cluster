# Variables definition.
NUM_NODES=2
NETWORK_IP_PREFIX="192.168.50."
NETWORK_IP_SUFIX=2

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_check_update = true
  config.ssh.forward_agent = true

  config.vm.define "control_plane" do |cp|
    cp.vm.hostname = "control-plane"
    cp.vm.network "private_network", ip: NETWORK_IP_PREFIX + "#{NETWORK_IP_SUFIX}"
    cp.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end
    cp.vm.network "forwarded_port", guest: 10250, host: 10250
    cp.vm.synced_folder "./shared/", "/home/vagrant/config/"
    cp.vm.provision "shell", path: "./scripts/shared_setup.sh"
    cp.vm.provision "shell", path: "./scripts/cplane_setup.sh"
  end
 
  (1..NUM_NODES).each do |i|
    config.vm.define "node_0#{i}" do |node|
      node.vm.hostname = "node0#{i}"
      node.vm.network "private_network", ip: NETWORK_IP_PREFIX + "#{NETWORK_IP_SUFIX + i}"
      node.vm.provider "virtualbox" do |vb|
          vb.cpus = 1
      end
      node.vm.synced_folder "./shared/", "/home/vagrant/config/"
      node.vm.provision "shell", path: "./scripts/shared_setup.sh"
      node.vm.provision "shell", path: "./scripts/nodes_setup.sh"
    end
  end
end