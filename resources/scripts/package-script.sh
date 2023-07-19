source .env

# Login to the container registry
echo $JUPYTER_REGISTRY_PASSWORD | docker login registry-1.docker.io --username=$JUPYTER_REGISTRY_USERNAME --password-stdin

# Generate directories
rm -rf package-contents package-repo
mkdir -p package-contents/.imgpkg package-contents/config package-repo/packages/jupyter.tanzu.vmware.com package-repo/.imgpkg

# Copy required files
helm template jupyterhub bitnami/jupyterhub \
--set hub.adminUser=${JUPYTERHUB_USER} \
--set hub.password=${JUPYTERHUB_PASSWORD} -n ${JUPYTER_NAMESPACE} | sed '/namespace:/d' > resources/jupyter-deployment.yaml
cp resources/jupyter-deployment.yaml package-contents/config
cp resources/jupyter-httpproxy.yaml package-contents/config
cp resources/jupyter-values-schema.yaml package-contents/config
cp resources/jupyter-metadata.yaml package-repo/packages/jupyter.tanzu.vmware.com

# Generate ImagesLock to record images in the package content:
kbld -f package-contents/config/ --imgpkg-lock-output package-contents/.imgpkg/images.yml

# Publish the imgpkg bundle for the package content repo to the Docker registry:
imgpkg push -b ${JUPYTER_REGISTRY_USERNAME}/jupyter-package-content:${JUPYTER_CURRENT_VERSION} -f package-contents/

# Generate the Package CR from the schema:
envsubst < resources/jupyter-package-template.in.yaml > resources/jupyter-package-template.yaml
ytt -f package-contents/config/jupyter-values-schema.yaml --data-values-schema-inspect -o openapi-v3 > resources/schema-openapi.yaml
sed -i '.bak' '/object/d' resources/schema-openapi.yaml
ytt -f resources/jupyter-package-template.yaml  --data-value-file openapi=resources/schema-openapi.yaml -v version="${JUPYTER_CURRENT_VERSION}" > package-repo/packages/jupyter.tanzu.vmware.com/${JUPYTER_CURRENT_VERSION}.yaml
rm -f resources/schema-openapi.yaml.bak

# Generate ImagesLock to record images in the package repo:
kbld -f package-repo/packages --imgpkg-lock-output package-repo/.imgpkg/images.yml

# Publish the imgpkg bundle for the package repo to the Docker registry:
imgpkg push -b ${JUPYTER_REGISTRY_USERNAME}/jupyter-package-repo:${JUPYTER_CURRENT_VERSION} -f package-repo/
