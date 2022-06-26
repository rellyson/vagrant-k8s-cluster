#!/bin/sh

# Script variables
CPLANE_IP="192.168.50.2"
HOSTNAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

# Init kubeadm configs
sudo kubeadm config images pull
sudo kubeadm init --apiserver-advertise-address=$CPLANE_IP --apiserver-cert-extra-sans=$CPLANE_IP \
     --pod-network-cidr=$POD_CIDR --node-name "$HOSTNAME" --ignore-preflight-errors Swap

# Create and copy kube config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config