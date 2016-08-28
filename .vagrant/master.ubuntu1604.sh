#!/bin/bash -vfx

#########
# Specify ansible repository and domain here
#########
ANSIBLE_REPO=git@github.com:himate/infrastructure.git
REPO_DOMAIN=github.com


########
# Vagrant box init
########
# Disable interactive mode
sudo mv -v /etc/apt/apt.conf.d/70debconf /root/etc-apt-apt.conf.d-70debconf.bak
sudo dpkg-reconfigure debconf -f noninteractive -p critical

# Disable cloud init
echo 'datasource_list: [ None ]' | sudo -s tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
sudo dpkg-reconfigure -f noninteractive cloud-init

# Uninstall unused software
sudo apt-get purge chef chef-zero puppet puppet-common landscape-client landscape-common -y

# Update everything
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y

# Install locales
sudo apt-get install language-pack-en -y



######
# Ansible
######
# Install Ansible
sudo apt-get install -y software-properties-common git python-dev python-pip libyaml-dev libssl-dev libffi-dev
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7BB9C367
sudo apt-get update
sudo pip install paramiko PyYAML Jinja2 httplib2 six
sudo apt-get install -y ansible

######
# Repo
######
# Accept repo certificate and clone /srv
mkdir -p ~/.ssh
touch ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
sleep 5 # give some time to network
ssh-keyscan -H ${REPO_DOMAIN} | tee --append ~/.ssh/known_hosts 
sudo rm -rf /etc/ansible
git clone ${ANSIBLE_REPO} /tmp/ansible
sudo mv /tmp/ansible /etc/ansible
cd /etc/ansible
sudo git submodule init
sudo git submodule update
sudo chown -R ubuntu:root /etc/ansible


######
# Hosts
######
sudo echo "10.10.11.11 himate-management" >> /etc/hosts
sudo echo "10.10.11.12 himate-app-test" >> /etc/hosts


######
# Wrap up
######
# Reboot
sudo reboot
