# Improving Application Reliability in Kubernetes

## Objective
In this exercise, you'll enhance the reliability of a Quarkus application in Kubernetes. You'll work with horizontal pod autoscaling, pod disruption budgets, configure high-availability database, and add monitoring capabilities.

## What's Missing
Several reliability components need to be configured:

1. **Database High Availability**:
   - The `cloudnativepg-database.yaml` file needs configuration for high availability
   - You need to set the appropriate number of instances for redundancy
   - Resource limits need to be properly configured

2. **Horizontal Pod Autoscaler (HPA)**:
   - The autoscaling metrics in `hpa.yaml` need proper configuration
   - Stabilization windows need tuning to prevent scaling thrashing

3. **Pod Disruption Budget (PDB)**:
   - The `pod-disruption-budget.yaml` needs configuration to maintain availability during maintenance

4. **Metrics Monitoring**:
   - The `service-monitor.yaml` needs proper configuration for Prometheus metrics collection

## Steps to Complete

1. Edit `src/main/kubernetes/deploy.sh` to set your namespace and participant name

2. Configure high availability database:
   - Edit `src/main/kubernetes/cloudnativepg-database.yaml` to set appropriate instance count
   - Configure resource limits suitable for a production environment

3. Configure Horizontal Pod Autoscaler:
   - Edit `src/main/kubernetes/hpa.yaml` to set proper CPU and memory utilization thresholds
   - Configure scaling behavior with appropriate stabilization windows

4. Configure Pod Disruption Budget:
   - Edit `src/main/kubernetes/pod-disruption-budget.yaml` to ensure availability during cluster maintenance
   - Choose between `minAvailable` and `maxUnavailable` settings

5. Configure ServiceMonitor:
   - Edit `src/main/kubernetes/service-monitor.yaml` to set up proper metrics collection
   - Set appropriate scraping intervals and paths

6. Deploy and test your application:
   ```bash
   ./src/main/kubernetes/build-container.sh
   ./src/main/kubernetes/deploy.sh
   ```

## Reference Information

### Database High Availability
- For production, typically run 3+ instances (1 primary, 2+ replicas)
- For development/testing, 1-2 instances may be sufficient
- Documentation: https://cloudnative-pg.io/documentation/current/architecture/

### Autoscaling Settings
- CPU utilization targets: 50-70% is generally recommended
- Memory utilization targets: 70-80% is generally recommended
- Scale-up should be more aggressive than scale-down
- Documentation: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

### Pod Disruption Budget
- `minAvailable` ensures a minimum number of pods are always available
- `maxUnavailable` limits how many pods can be down at once
- Documentation: https://kubernetes.io/docs/concepts/workloads/pods/disruptions/

### Prometheus Monitoring
- Quarkus exposes metrics at: `/q/metrics`
- Recommended scrape interval: 15s for production monitoring
- Documentation: https://prometheus-operator.dev/docs/user-guides/getting-started/

## Helpful Commands
```bash
# View database cluster status
kubectl get clusters.postgresql.cnpg.io -n YOUR_NAMESPACE

# Check HPA status and current metrics
kubectl get hpa -n YOUR_NAMESPACE
kubectl describe hpa YOURNAME-todo-demo-app-hpa -n YOUR_NAMESPACE

# Check PDB status
kubectl get pdb -n YOUR_NAMESPACE

# Verify metrics being collected
kubectl port-forward -n YOUR_NAMESPACE deploy/YOURNAME-todo-demo-app 8080:8080
# Then in another terminal: curl http://localhost:8080/q/metrics
```

Good luck!