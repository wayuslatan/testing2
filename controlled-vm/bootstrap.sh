#!/bin/bash

sudo route del default dev enp0s3

apt-get -y install openssh-server
service sshd start

cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config.backup
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service ssh restart
echo -e "initpassword\ninitpassword" | passwd root

#cat <<EOT >> /etc/nginx/conf.d/test-app1-lb.conf
#xxx
#EOT