#!/bin/bash

echo "[TASK 1] add new default routing, delete routing on eth0"
sudo route add default gw 192.168.2.1
sudo route del default dev enp0s3

echo "[TASK 2] Update System"
sudo apt-get -y update
sudo apt -y update
sudo apt-get -y upgrade

echo "[TASK 3] Turnoff Firewall"
systemctl stop ufw
systemctl disable ufw

echo "[TASK 2] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

apt -y install nginx
systemctl enable nginx

nginx -t #check configuration
systemctl reload nginx