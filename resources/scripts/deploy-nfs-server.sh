#!/bin/sh

set -e

helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts

helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version v4.5.0

kubectl create ns storage || true

kubectl apply -n storage -f resources/archived/nfs/nfs-server.yaml

kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=csi-driver-nfs -n kube-system