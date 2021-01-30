#!/bin/bash

#echo "[TASK 1] Update /etc/hosts file"
#cat >>/etc/hosts<<EOF
#192.168.2.100 kmaster.wayuslatan.com kmaster
#192.168.2.101 kslave1.wayuslatan.com kslave1
#192.168.2.102 kslave2.wayuslatan.com kslave2
#EOF

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

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

#export KUBECONFIG=/etc/kubernetes/admin.conf

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo -e "kubeadmin\nkubeadmin" | passwd root

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config.backup

#sed -i 's/old-text/new-text/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service ssh restart

docker login -u wayuslatan -p Parn.5907123

mkdir /etc/systemd/system/docker.service.d
cat <<EOT >> docker.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
EOT

systemctl daemon-reload
systemctl restart docker.service

#agent labels: docker-agent
#agnt name: docker
#agent image: benhall/dind-jenkins-agent:v2
#agent -> container setting -> volume: /var/run/docker.sock:/var/run/docker.sock

#export KUBECONFIG=/etc/kubernetes/admin.conf

#kubectl create -f /mnt/kubenetes/test1-deployment/jenkins/jenkins-service.yml
#kubectl create -f /mnt/kubernetes/test1-deployment/jenkins/fabric8-rbac.yml
#kubectl create -f /mnt/kubernetes/test1-deployment/jenkins/jenkins-deployment.yml
