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

cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config.backup
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service ssh restart

echo -e "ansibleadmin\nansibleadmin" | passwd root