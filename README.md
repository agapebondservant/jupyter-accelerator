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
kubectl create ns ${JUPYTER_NAMESPACE} || true
tanzu package repository add jupyterhub-package-repository \
  --url ${JUPYTER_REGISTRY_USERNAME}/jupyter-package-repo:${JUPYTER_CURRENT_VERSION} \
  --namespace ${JUPYTER_NAMESPACE}
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
tanzu package install jupyterhub -p jupyter.tanzu.vmware.com -v ${JUPYTER_CURRENT_VERSION} --values-file resources/jupyter-values.yaml --namespace ${JUPYTER_NAMESPACE}
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

Finally, Jupyterhub should now be accessible at http://jupyter-${JUPYTER_NAMESPACE}.${JUPYTER_BASE_DOMAIN}. 
Login with credentials ${JUPYTERHUB_USER} / ${JUPYTERHUB_PASSWORD}.

## Deploying Jupyterhub via Helm Chart
* Build the JupyterHub container (skip if already built):
```
source .env
cd resources/archived
docker build -t ${JUPYTER_REGISTRY_USERNAME}/jupyterhub-single-user-helm:3.2.1 .
docker push ${JUPYTER_REGISTRY_USERNAME}/jupyterhub-single-user-helm:3.2.1
cd -
```

* Deploy the NFS Server (skip if already deployed):
```
source .env
resources/scripts/deploy-nfs-server.sh
```

* Set up registry credentials' secret (skip if already deployed):
```
source .env
tanzu secret registry add registry-credentials \
--username ${JUPYTER_REGISTRY_USERNAME} \
--password ${JUPYTER_REGISTRY_PASSWORD} \
--server ${JUPYTER_REGISTRY_SERVER} \
--export-to-all-namespaces --yes -n${JUPYTER_NAMESPACE}
```

* (Skip if already deployed): Set up an **extraVolume** which will aggregate all the **ServiceBindings** for this JupyterHub environment.
The volume will be mounted by a Deployment called **bkstg-aggregator**, 
which will serve as a ServiceBinding-compatible Workload and receptacle for all relevant **ServiceBindings**.
In turn, the JupyterHub environment will use a ReadWriteMany PVC to mount the volume from **bkstg-aggregator** and project the ServiceBindings locally.
```
resources/scripts/deploy-extravolume.sh
```

* Deploy JupyterHub:
```
source .env
resources/scripts/deploy-helm.sh
```

* The JupyterHub instance endpoint should be available here - might take up to a minute to load. (NOTE: Uses dummy authentication, so authenticate with any username/password):
```
export JUPYTERHUB_URL_INSTANCE=$(kubectl get svc --namespace ${JUPYTER_NAMESPACE} proxy-public -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
echo http://$JUPYTERHUB_URL_INSTANCE
```

* To uninstall:
```
source .env
resources/scripts/undeploy-helm.sh
resources/scripts/undeploy-nfs-server.sh
resources/scripts/undeploy-extravolume.sh
```