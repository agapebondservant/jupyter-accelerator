kubectl get secret YOUR_DATASOURCE-app-user-db-secret -ndata-samples-w04-s005 -oyaml | sed 's/namespace: .*/namespace: YOUR_SESSION_NAMESPACE/' | kubectl apply -nYOUR_SESSION_NAMESPACE -f -
cat jupyter-deployment.yaml | yq -y '.spec.template.spec.containers[0].volumeMounts += [{"mountPath":"/etc/jupyterhub/bindings","name":"YOUR_DATASOURCE"}] | .spec.template.spec.volumes += [{"name":"pginstance-1","secret":{"secretName":"YOUR_DATASOURCE-app-user-db-secret"}}]' > tmp.yaml
mv tmp.yaml jupyter-deployment.yaml
kubectl apply -f jupyter-deployment.yaml