#!/bin/sh

set -e

ytt --ignore-unknown-comments \
-f resources/archived/values.yaml \
-f resources/archived/jupyterhub-config-update.yaml \
-f resources/archived/jupyterhub-config-overlay.yaml | \
  helm upgrade --cleanup-on-fail \
  --install my-jupyter jupyterhub/jupyterhub \
  --namespace ${JUPYTER_NAMESPACE} \
  --create-namespace \
  --values -

