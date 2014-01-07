# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2" 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--memory", 512]
	end
	
#	config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"
	config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box"
	config.vm.box = "saucy64-opscode"
	config.vm.hostname = "server.example.com"

	config.vm.network :private_network, ip: "10.33.33.33"
	config.vm.network :public_network
		
	config.vm.provision :shell, :inline => <<SCRIPT
#!/bin/bash
if ! which chef-client; then
	apt-get install -y curl
	curl -L https://www.opscode.com/chef/install.sh | bash
fi
SCRIPT
	
end
