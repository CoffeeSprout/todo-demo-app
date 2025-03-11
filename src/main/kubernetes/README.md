# Todo Demo App Kubernetes Deployment

This directory contains the Kubernetes manifests for deploying the Todo Demo Application to the `quarkus-k8s-barry` namespace.

## Quick Deployment

To deploy the application:

1. Make sure you have the correct kubeconfig:
   ```bash
   export KUBECONFIG=/path/to/your/kubeconfig
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```
   
3. Follow the prompts to update registry credentials if needed.

## Manual Deployment

If you prefer to deploy manually:

1. Create or update the registry secret:
   ```bash
   kubectl create secret docker-registry workshop-registry-secret \
     --docker-server=registry.hacknight043.coffeesprout.dev \
     --docker-username=your-username \
     --docker-password=your-password \
     --docker-email=your-email \
     --namespace=quarkus-k8s-barry \
     --dry-run=client -o yaml > registry-secret.yaml
   ```

2. Apply all manifests:
   ```bash
   kubectl apply -f .
   ```

## Accessing the Application

Once deployed, the application will be available at:
https://todo-barry.hacknight043.coffeesprout.dev

## Kubernetes Resources

The application includes the following resources:

- **deployment.yaml**: Main application deployment
- **service.yaml**: Service for accessing the deployment
- **configmap.yaml**: Configuration for the application
- **cloudnativepg-database.yaml**: PostgreSQL database using CloudNative PG operator
- **ingress.yaml**: Ingress for external access
- **registry-secret.yaml**: Secret for pulling images from private registry
- **network-policy.yaml**: Network security policies
- **hpa.yaml**: Horizontal Pod Autoscaler for scaling
- **pod-disruption-budget.yaml**: Availability during maintenance
- **service-monitor.yaml**: Prometheus monitoring configuration
- **logging-config.yaml**: Structured logging configuration

## Cleanup

To remove the deployment:
```bash
kubectl delete -f .
```