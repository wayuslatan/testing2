#!/bin/bash

sudo route add default gw 192.168.2.1
sudo route del default dev enp0s3

sudo apt-get -y update
sudo apt -y update
sudo apt-get -y upgrade

systemctl stop ufw
systemctl disable ufw

apt-get -y install nano
apt-get -y install tree

sed -i '/swap/d' /etc/fstab
swapoff -a

apt-get -y install openssh-server
service sshd start

cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config.backup
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service ssh restart
echo -e "ansibleadmin\nansibleadmin" | passwd root

sudo apt-get -y update
sudo apt-get -y install software-properties-common
echo 'y' | sudo apt-add-repository ppa:ansible/ansible
sudo apt-get -y update
sudo apt-get -y install ansible

cp /etc/ansible/ansible.cfg /etc/ansible/backup.ansible.cfg
sudo sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg

#default inventory file /etc/ansible/hosts

#cat <<EOT >> /etc/nginx/conf.d/test-app1-lb.conf
#xxx
#EOT