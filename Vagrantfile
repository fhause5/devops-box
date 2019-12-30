Vagrant.configure(2) do |config|
	config.vm.define "centos7" do |centos7|
		centos7.vm.box = "centos/7"
		centos7.vm.hostname = "centos7"
		config.disksize.size = '60GB'
		centos7.vm.network "public_network",
			use_dhcp_assigned_default_route: true
			centos7.vm.provision "shell", path: "scripts/install.sh"
			centos7.vm.provider "virtualbox" do |v|
			v.name = "centos7"
			v.memory = 2048
			v.cpus = 2
	  end
	end
	config.vm.define "ubuntu16" do |ubuntu16|
		ubuntu16.vm.box = "ubuntu/xenial64"
		ubuntu16.vm.hostname = "ubuntu16"
		config.disksize.size = '50GB'
		ubuntu16.vm.network "public_network",
			use_dhcp_assigned_default_route: true
			centos7.vm.provision "shell", path: "scripts/install.sh"
			centos7.vm.provider "virtualbox" do |v|
			v.name = "ubuntu16"
			v.memory = 2048
			v.cpus = 2
	  end
	end
end
