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
sudo cp $HOME/.kube/config /home/vagrant/config/config

# Set cluster metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Set Calico CNI resources
kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml
kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

# create a join script via kubeadm
kubeadm token create --print-join-command > /home/vagrant/config/join-cmd.sh