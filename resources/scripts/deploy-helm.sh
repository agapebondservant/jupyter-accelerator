#!/bin/sh

set -e

ytt -f resources/archived/jupyter-httpproxy.yaml \
    -f resources/archived/jupyter-volume-deployment.yaml \
    -f resources/archived/values.yaml | kubectl apply -n ${JUPYTER_NAMESPACE} -f -

kubectl create secret docker-registry jupyter-pull-secret \
--namespace=$JUPYTER_NAMESPACE \
--docker-server=${JUPYTER_REGISTRY_SERVER} \
--docker-username=${JUPYTER_REGISTRY_USERNAME} \
--docker-password=${JUPYTER_REGISTRY_PASSWORD} \
--dry-run -o yaml | kubectl apply -f -

helm upgrade --cleanup-on-fail \
--install my-jupyter jupyterhub/jupyterhub \
--namespace ${JUPYTER_NAMESPACE} \
--create-namespace \
--values resources/archived/jupyterhub-config.yaml

