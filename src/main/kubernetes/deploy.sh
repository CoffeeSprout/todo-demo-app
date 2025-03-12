#!/bin/bash

# Deployment script for Todo Demo App using Kustomize
# Variables must be manually set before running this script

# These placeholder values MUST be changed before running
NAMESPACE="CHANGE_ME_TO_YOUR_NAMESPACE"
PARTICIPANT="CHANGE_ME_TO_YOUR_NAME"

# Container image settings
REGISTRY="registry.hacknight043.coffeesprout.dev"
IMAGE_NAME="todo-demo-app"
IMAGE_TAG="latest"

# Check if variables have been changed from placeholder values
if [[ "$NAMESPACE" == "CHANGE_ME_TO_YOUR_NAMESPACE" || "$PARTICIPANT" == "CHANGE_ME_TO_YOUR_NAME" ]]; then
  echo "ERROR: You must edit this script to set your namespace and participant name!"
  echo "Open deploy.sh in a text editor and change the NAMESPACE and PARTICIPANT variables."
  exit 1
fi

echo "Deploying Todo Demo App for participant '$PARTICIPANT' to namespace '$NAMESPACE'..."

# Verify we can access the namespace
if ! kubectl get pods -n $NAMESPACE > /dev/null 2>&1; then
  echo "ERROR: Cannot access namespace $NAMESPACE!"
  echo "Make sure your kubeconfig is properly set up with: export KUBECONFIG=/path/to/your/kubeconfig"
  echo "Or verify that the namespace exists with: kubectl create namespace $NAMESPACE"
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
    --namespace=$NAMESPACE \
    --dry-run=client -o yaml > registry-secret.yaml
  
  kubectl apply -f registry-secret.yaml
  echo "Registry credentials updated."
fi

# Check if kustomization.yaml exists
if [ ! -f "kustomization.yaml" ]; then
  echo "ERROR: kustomization.yaml not found in the current directory!"
  exit 1
fi

# Update kustomization.yaml with participant information
echo "Updating kustomization.yaml with your settings..."

# Create a temporary file (compatible with both Linux and macOS)
TMP_FILE=$(mktemp)

# Replace namespace placeholder
cat kustomization.yaml | sed "s/CHANGE_ME_TO_YOUR_ASSIGNED_NAMESPACE/$NAMESPACE/g" > "$TMP_FILE"
cat "$TMP_FILE" > kustomization.yaml

# Replace participant placeholder
cat kustomization.yaml | sed "s/PARTICIPANT_NAME/$PARTICIPANT/g" > "$TMP_FILE"
cat "$TMP_FILE" > kustomization.yaml

# Clean up
rm "$TMP_FILE"

echo "kustomization.yaml updated with namespace '$NAMESPACE' and participant '$PARTICIPANT'."

# Apply using Kustomize
echo "Applying Kubernetes manifests using Kustomize..."
kubectl apply -k .

# Wait for deployment
echo "Waiting for deployment to complete..."
kubectl rollout status deployment/$PARTICIPANT-todo-demo-app -n $NAMESPACE

# Provide deployment status and information
echo "✅ Deployment complete!"
echo "🌐 Application will be available at: https://todo-$PARTICIPANT.hacknight043.coffeesprout.dev"
echo "🔄 It may take a minute or two for the application to become fully available."
echo ""
echo "📦 Container image: $REGISTRY/$PARTICIPANT/$IMAGE_NAME:$IMAGE_TAG"

# Provide cleanup instructions
echo ""
echo "To tear down all resources when you're done:"
echo "kubectl delete -k ."
