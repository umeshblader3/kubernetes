#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log

echo "[TASK 3] Install the Calico Operator to cluster"
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

echo "[TASK 4] Create the manifest in order to install Calico"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

echo "[TASK 5] Generate and save cluster join command to /root/joincluster.sh"
kubeadm token create --print-join-command > /root/joincluster.sh
