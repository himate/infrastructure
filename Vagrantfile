# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Import current PK in ssh-agent
system('.vagrant/ssh/agent.sh')

host_prefix = 'himate'

boxes = {

  ######
  # Ansible server
  ######
  'ansible' => {
    dist: 'ubuntu/xenial64',
    mem:  1024,
    ip: '10.10.11.10',
    copy: [ '~/.gitconfig', '.vagrant/ssh/local.dev.private.key', '.vagrant/ssh/local.dev.public.key' ],
    exec: [ '.vagrant/ssh/ubuntu1604.deploy.local.dev.keys.sh', '.vagrant/ansible.ubuntu1604.sh' ],
  },

  ######
  # Management
  ######
  'dockerhub' => { 
    dist: 'ubuntu/xenial64',
    mem: 2048,
    ip: '10.10.11.11',
    copy: [ '.vagrant/ssh/local.dev.public.key' ],
	exec: ['.vagrant/ssh/ubuntu1604.deploy.local.dev.keys.sh', '.vagrant/box.ubuntu1604.sh' ],
  },

  'jenkins' => { 
    dist: 'ubuntu/xenial64',
    mem: 2048,
    ip: '10.10.11.12',
    copy: [ '.vagrant/ssh/local.dev.public.key' ],
	exec: ['.vagrant/ssh/ubuntu1604.deploy.local.dev.keys.sh', '.vagrant/box.ubuntu1604.sh' ],
  },

  ######
  # Test
  ######
  'app-test' => { 
    dist: 'ubuntu/xenial64',
    mem: 2048,
    ip: '10.10.11.13',
    copy: [ '.vagrant/ssh/local.dev.public.key' ],
	exec: ['.vagrant/ssh/ubuntu1604.deploy.local.dev.keys.sh', '.vagrant/box.ubuntu1604.sh' ],
  },
}



Vagrant.configure(2) do |config|

  # enable tty allocation for provisioning
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.ssh.forward_agent = true

  # default hardware resources
  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = 1
	vb.memory = 1024
  end

  boxes.each do |name, box|
    hostname = "#{host_prefix}-#{name}"
    config.vm.define name, autostart: true do |host|
      host.vm.hostname = hostname
      host.vm.box = box[:dist]

	  # set custom network address
      host.vm.network 'private_network', ip: box[:ip]

	  # set custom settings
      config.vm.provider "virtualbox" do |vb|
	    if box.has_key?(:mem) then
          vb.memory = box[:mem]
		end
        
        if box.has_key?(:cpus) then
		  vb.cpus = box[:cpus]
		end
        
        vb.name = hostname
      end

	  # copy files to box
	  if box.has_key?(:copy) then
        box[:copy].each do |file|
          host.vm.provision 'file', source: file, destination: File.basename(file) 
        end
	  end

	  # execute scripts on box
	  if box.has_key?(:exec) then
	    box[:exec].each do |script|
          host.vm.provision 'shell', path: script 
		end
	  end
      
    end
  end
end
