#!/bin/sh

helm uninstall my-jupyter -n $JUPYTER_NAMESPACE

# delete all pods and pvcs associated with jupyterhub
kubectl delete pod -l app=jupyterhub -n ${JUPYTER_NAMESPACE}
kubectl delete pvc -l app=jupyterhub -n ${JUPYTER_NAMESPACE}

