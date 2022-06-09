kubectl apply -f datasource-secrets.yaml
kubectl apply -f jupyter-deployment.yaml -nYOUR_SESSION_NAMESPACE
kubectl apply -f jupyter-deployment-service-binding.yaml -nYOUR_SESSION_NAMESPACE