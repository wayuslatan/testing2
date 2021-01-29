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

apt install nginx
systemctl enable nginx

cat <<EOT >> /etc/nginx/conf.d/test-app1-lb.conf
upstream test-app1-30001 {
	server 192.168.2.38:30001;
}

server{
	listen 80;
	location /vote{
		proxy_pass http://test-app1-30001/;
	}
}
EOT

cat <<EOT >> /etc/nginx/conf.d/test-app2-lb.conf
upstream test-app2-30002 {
	server 192.168.2.38:30002;
}

server{
	listen 80;
	location /result{
		proxy_pass http://test-app2-30002/;
	}
}
EOT

cat <<EOT >> /etc/nginx/conf.d/kibana1-lb.conf
upstream kibana1-30003 {
	server 192.168.2.38:30003;
}

server{
	listen 80;
	location /kibana{
		proxy_pass http://kibana1-30003/;
	}
}
EOT

cat <<EOT >> /etc/nginx/conf.d/jenkins-lb.conf
upstream jenkins-30004 {
	server 192.168.2.38:30004;
}

server{
	listen 80;
	location /jenkins{
		proxy_pass http://jenkins-30004/;
	}
}
EOT

nginx -t #check configuration
systemctl reload nginx