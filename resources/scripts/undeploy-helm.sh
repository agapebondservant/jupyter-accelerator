#!/bin/sh

helm uninstall my-jupyter -n $JUPYTER_NAMESPACE
ytt -f resources/archived/jupyter-httpproxy.yaml \
    -f resources/archived/jupyter-volume-deployment.yaml \
    -f resources/archived/values.yaml | kubectl delete -n ${JUPYTER_NAMESPACE} -f -

