#!/bin/bash
set -e

# CONFIG
FRONTEND_DEPLOYMENT=frontend
FRONTEND_SERVICE=frontend
CONFIGMAP_NAME=frontend-config
BACKEND_SERVICE=backend

echo "📄 Applying Kubernetes manifests..."
kubectl apply -f TME7/k8s/frontend-configmap.yml
kubectl apply -f TME7/k8s/frontend-deployment.yml
kubectl apply -f TME7/k8s/frontend-service.yml
kubectl apply -f TME7/k8s/backend-deployment.yml
kubectl apply -f TME7/k8s/backend-service.yml
kubectl apply -f TME7/k8s/db-deployment.yml
kubectl apply -f TME7/k8s/db-service.yml

echo "🌐 Getting backend service info..."
MINIKUBE_IP=$(minikube ip)
BACKEND_PORT=$(kubectl get svc $BACKEND_SERVICE -o jsonpath='{.spec.ports[0].nodePort}')
FULL_URL="http://$MINIKUBE_IP:$BACKEND_PORT"
echo "➡️ Injecting REACT_APP_API_URL: $FULL_URL"

kubectl create configmap $CONFIGMAP_NAME \
  --from-literal=REACT_APP_API_URL="$FULL_URL" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "♻️ Restarting frontend deployment to apply new config..."
kubectl rollout restart deployment $FRONTEND_DEPLOYMENT

echo "✅ Deployment complete!"
echo "🌍 Your frontend is available at: http://$MINIKUBE_IP:30080"
