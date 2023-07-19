source .env
cat > $1 <<- EOF
namespace: ${JUPYTER_NAMESPACE:-"default"}
image: ${JUPYTER_REGISTRY_USERNAME}/jupyter-package-repo:${JUPYTER_CURRENT_VERSION}
version: ${JUPYTER_CURRENT_VERSION:-"1.0.0"}
base_domain: ${JUPYTER_BASE_DOMAIN:-"tanzumlai.com"}
container_repo_user: ${JUPYTER_REGISTRY_USERNAME}
EOF