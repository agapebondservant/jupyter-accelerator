# Jupyter Utilities Accelerator
Utilities for deploying and extending JupyterHub notebooks.

* Install App Accelerator: (see https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-cert-mgr-contour-fcd-install-cert-mgr.html)
```
tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
tanzu package install accelerator -p accelerator.apps.tanzu.vmware.com -v 1.1.1 -n tap-install -f resources/app-accelerator-values.yaml
Verify that package is running: tanzu package installed get accelerator -n tap-install
Get the IP address for the App Accelerator API: kubectl get service -n accelerator-system
```

Publish Accelerators:
```
tanzu plugin install --local <path-to-tanzu-cli> all
tanzu acc create jupyter --git-repository https://github.com/agapebondservant/jupyter-accelerator.git --git-branch main
```

## Pre-requisites for Deployment
* Create an *.env* file with the properties indicated in *env-sample* (located in root directory).

* Set the environment variables:
```
source .env
```

## Building JupyterHub Package (skip if already built)
* Build the JupyterHub container:
```
docker build -t ${JUPYTER_REGISTRY_USERNAME}/jupyterhub-single-user .
docker push ${JUPYTER_REGISTRY_USERNAME}/jupyterhub-single-user
```

* Build the JupyterHub Package Repository:
```
resources/scripts/package-script.sh
```

## Deploying JupyterHub Package Repository
* Install the JupyterHub Package Repository:
```
tanzu package repository add jupyterhub-package-repository \
  --url ${JUPYTER_REGISTRY_USERNAME}/jupyter-package-repo:${JUPYTER_CURRENT_VERSION} \
  --namespace ${JUPYTER_NAMESPACE} \
  --create-namespace
```

Verify that the Jupyterhub package is available for install:
```
tanzu package available list jupyter.tanzu.vmware.com --namespace ${JUPYTER_NAMESPACE}
```

Generate a values.yaml file to use for the install - update as desired:
```
resources/scripts/generate-values-yaml.sh resources/jupyter-values.yaml #replace resources/jupyter-values.yaml with /path/to/your/values/yaml/file
```

Install via **tanzu cli**:
```
tanzu package install jupyterhub -p jupyter.tanzu.vmware.com -v 1.0.0 --values-file resources/jupyter-values.yaml --namespace ${JUPYTER_NAMESPACE}
```

Verify that the install was successful:
```
tanzu package installed get jupyterhub --namespace ${JUPYTER_NAMESPACE}
```

To uninstall:
```
tanzu package installed delete jupyterhub --namespace ${JUPYTER_NAMESPACE} -y
tanzu package repository delete jupyterhub-package-repository --namespace ${JUPYTER_NAMESPACE} -y
kubectl delete ns ${JUPYTER_NAMESPACE} || true
```

Finally, Jupyterhub should now be accessible at http://jupyterhub.${JUPYTER_BASE_DOMAIN}.