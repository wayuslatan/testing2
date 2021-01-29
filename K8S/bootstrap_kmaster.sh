#!/bin/bash

kubeadm init --apiserver-advertise-address=192.168.2.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

sudo export KUBECONFIG=/etc/kubernetes/admin.conf

su - vagrant -c "kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml"

kubeadm token create --print-join-command > /joincluster.sh
