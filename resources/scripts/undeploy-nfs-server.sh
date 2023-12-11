#!/bin/sh

helm uninstall csi-driver-nfs --namespace kube-system
kubectl delete -n storage -f resources/archived/nfs/nfs-server.yaml
kubectl delete ns storage