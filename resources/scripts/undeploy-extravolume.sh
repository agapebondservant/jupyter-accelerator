#!/bin/sh

kubectl delete -n ${JUPYTER_NAMESPACE} -f resources/archived/jupyterhub-extravolume.yaml
