#!/bin/bash

#kubeadm init --apiserver-advertise-address=kmaster.wayuslatan.com:8080 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

kubeadm init --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

#mkdir /home/vagrant/.kube
#cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
#chown -R vagrant:vagrant /home/vagrant/.kube

mkdir -p $HOME/.kube
echo "yes" | sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo export KUBECONFIG=/etc/kubernetes/admin.conf

su - vagrant -c "kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml"

kubeadm token create --print-join-command > /joincluster.sh
