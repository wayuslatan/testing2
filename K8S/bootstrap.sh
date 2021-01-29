#!/bin/bash

sudo route add default gw 192.168.2.1
sudo route del default dev enp0s3

sudo apt-get remove docker docker-engine docker.io containerd runc 2> /dev/null
sudo apt-get -y update
sudo apt -y update
sudo apt-get -y upgrade

sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt -y update
sudo apt-get -y update

apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -y update
sudo apt-get -y update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

usermod -aG docker vagrant

apt-get -y install nano
apt-get -y install tree

systemctl enable docker >/dev/null 2>&1
systemctl start docker

systemctl stop ufw
systemctl disable ufw

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net/bridge/bridge-nf-call-ip6tables = 1
net/bridge/bridge-nf-call-iptables = 1
net/bridge/bridge-nf-call-arptables = 1
EOF
sysctl --system >/dev/null 2>&1

sed -i '/swap/d' /etc/fstab
swapoff -a

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -y
apt-get install -y kubelet kubeadm kubectl

systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo -e "kubeadmin\nkubeadmin" | passwd root

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc