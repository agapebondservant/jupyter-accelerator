#!/bin/sh

set -e

kubectl apply -n ${JUPYTER_NAMESPACE} -f resources/archived/jupyterhub-extravolume.yaml
