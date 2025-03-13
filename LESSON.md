# Kubernetes Deployment - Starter Exercise

## Objective
In this exercise, you will learn how to deploy a basic Quarkus application to Kubernetes with proper health checks and ingress configuration. You'll need to complete several configuration files to ensure your application is reliable, accessible, and properly monitored.

## What's Missing
Several critical components have placeholders in the Kubernetes configuration files:

1. In `src/main/kubernetes/deployment.yaml`:
   - Health probes (readiness, liveness, and startup) have empty values
   - You need to configure these probes with correct paths, ports, and timing parameters
   - Note: The security contexts (pod and container level) are already properly configured, so you don't need to modify them

2. In `src/main/kubernetes/ingress.yaml`:
   - The ingress controller class is missing
   - TLS/SSL certificate management configuration is incomplete
   - HAProxy timeout settings for reliability have empty values

## Steps to Complete

1. Edit `src/main/kubernetes/deploy.sh` to set your namespace and participant name
   - Change the values for `NAMESPACE` and `PARTICIPANT` variables

2. Edit `src/main/kubernetes/deployment.yaml` to:
   - Configure health probes (readiness, liveness, and startup) with correct values
   - Set appropriate timing parameters for each probe type

3. Edit `src/main/kubernetes/ingress.yaml` to:
   - Add the correct ingress controller class
   - Configure TLS/SSL with cert-manager
   - Add appropriate HAProxy timeouts for reliability

4. Build your container image:
   ```bash
   ./src/main/kubernetes/build-container.sh
   ```

5. Deploy your application:
   ```bash
   ./src/main/kubernetes/deploy.sh
   ```

6. Verify your deployment is working:
   - Check that pods are running with no restarts
   - Verify the application is accessible via the ingress URL

## Success Criteria
- Your application should be accessible at: `https://todo-YOURNAME.hacknight043.coffeesprout.dev`
- The pods should be in a "Running" state with no restarts
- Health checks should be passing successfully

## Reference Information

### Health Probe Endpoints
- Readiness endpoint: `/q/health/ready`
- Liveness endpoint: `/q/health/live`
- Read about Quarkus health: https://quarkus.io/guides/smallrye-health
- Kubernetes probe documentation: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

### Security Context Values
- Pod should run as non-root
- Container should run as user ID 185 (jboss)
- Container should have read-only root filesystem
- All Linux capabilities should be dropped

### Ingress Configuration
- Ingress controller: `haproxy`
- Cert-manager cluster issuer: `letsencrypt-staging`
- HAProxy Ingress documentation: https://github.com/haproxytech/kubernetes-ingress/blob/master/documentation/README.md
- Cert-manager documentation: https://cert-manager.io/docs/configuration/

## Helpful Commands
```bash
# Check pod status
kubectl get pods -n YOUR_NAMESPACE

# Check logs if there are issues
kubectl logs -n YOUR_NAMESPACE deploy/YOURNAME-todo-demo-app

# Check the ingress configuration
kubectl get ingress -n YOUR_NAMESPACE

# Describe the pod to check for issues
kubectl describe pod -n YOUR_NAMESPACE -l app=todo-demo-app

# Check health endpoints directly (replace POD_NAME and NAMESPACE)
kubectl port-forward pod/POD_NAME 8080:8080 -n NAMESPACE
# Then in another terminal:
curl http://localhost:8080/q/health/live
curl http://localhost:8080/q/health/ready
```

## Further Reading
- Kubernetes Probes: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
- Ingress Controllers: https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
- HAProxy Timeouts: https://www.haproxy.com/blog/the-four-essential-sections-of-an-haproxy-configuration/

Good luck!