# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# All Vagrant configuration is done here. The most common configuration
	# options are documented and commented below. For a complete reference,
	# please see the online documentation at vagrantup.com.

	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "debian/contrib-buster64"

	config.vm.hostname = "acc-vagrant"

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine. In the example below,
	# accessing "localhost:8080" will access port 80 on the guest machine.

	# Uses 8081 instead to lessen risk of a conflict (especially if someone is using mw-vagrant at the same time)
	config.vm.network "forwarded_port", guest: 80, host: 8081

	# If true, then any SSH connections made will enable agent forwarding.
	# Default value: false
	# config.ssh.forward_agent = true

	config.vm.provision :shell, path: 'install-puppet.sh'
	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = [:guest, '/vagrant/puppet/manifests']
		puppet.manifest_file = "default.pp"

		# Use empty module path to avoid an extra mount.
    	# See --modulepath below
		puppet.module_path = []

		puppet.environment_path = [:guest, '/vagrant/puppet/environments']
		puppet.environment = 'vagrant'

		puppet.options = [
			'--modulepath', '/vagrant/puppet/modules'
		]
	end

	config.vm.provision "shell", inline: "/usr/sbin/service apache2 restart", run: "always"
end
