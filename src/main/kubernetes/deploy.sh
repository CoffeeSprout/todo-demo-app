#!/bin/bash

# Simple deployment script for Todo Demo App
# Hardcoded for Barry's deployment in namespace quarkus-k8s-barry

echo "Deploying Todo Demo App to namespace quarkus-k8s-barry..."

# Verify we can access the namespace
if ! kubectl get pods -n quarkus-k8s-barry > /dev/null 2>&1; then
  echo "ERROR: Cannot access namespace quarkus-k8s-barry!"
  echo "Make sure your kubeconfig is properly set up with: export KUBECONFIG=/path/to/your/kubeconfig"
  exit 1
fi

# Update registry credentials if needed
read -p "Do you want to update registry credentials? (y/N): " update_creds
if [[ $update_creds == "y" || $update_creds == "Y" ]]; then
  read -p "Registry username: " username
  read -s -p "Registry password: " password
  echo  # Add a newline after password
  read -p "Email: " email
  
  # Create registry secret
  kubectl create secret docker-registry workshop-registry-secret \
    --docker-server=registry.hacknight043.coffeesprout.dev \
    --docker-username=$username \
    --docker-password=$password \
    --docker-email=$email \
    --namespace=quarkus-k8s-barry \
    --dry-run=client -o yaml > registry-secret.yaml
  
  echo "Registry credentials updated."
fi

# Apply all resources
echo "Applying Kubernetes manifests..."
kubectl apply -f configmap.yaml
kubectl apply -f registry-secret.yaml
kubectl apply -f cloudnativepg-database.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
kubectl apply -f hpa.yaml
kubectl apply -f network-policy.yaml
kubectl apply -f pod-disruption-budget.yaml
kubectl apply -f service-monitor.yaml
kubectl apply -f logging-config.yaml

# Wait for deployment
echo "Waiting for deployment to complete..."
kubectl rollout status deployment/todo-demo-app -n quarkus-k8s-barry

echo "✅ Deployment complete!"
echo "🌐 Application will be available at: https://todo-barry.hacknight043.coffeesprout.dev"
echo "🔄 It may take a minute or two for the application to become fully available."