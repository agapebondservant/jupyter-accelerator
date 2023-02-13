kubectl apply -f resources/archived/datasource-secrets.yaml
kubectl apply -f resources/archived/jupyter-deployment.yaml -njupyterhub
kubectl apply -f resources/archived/jupyter-deployment-service-binding.yaml -njupyterhub