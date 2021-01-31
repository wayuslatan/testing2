#!/bin/bash

#kubeadm init --apiserver-advertise-address=kmaster.wayuslatan.com:8080 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

#for flannel
kubeadm init --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

#for calico
#kubeadm init --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

#mkdir /home/vagrant/.kube
#cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
#chown -R vagrant:vagrant /home/vagrant/.kube

mkdir -p $HOME/.kube
echo "yes" | sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo export KUBECONFIG=/etc/kubernetes/admin.conf

#kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

kubeadm token create --print-join-command > /joincluster.sh

#-----------------------For metallb---------------------------------------#
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
#--------------------------------------------------------------------------#
