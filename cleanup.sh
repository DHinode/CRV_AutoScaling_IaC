#!/bin/bash
set -e

echo "🧼 Cleaning up Kubernetes resources..."

# Delete deployments
kubectl delete deployment frontend backend redis --ignore-not-found

# Delete services
kubectl delete service frontend backend redis --ignore-not-found

# Delete configmap used for frontend env injection
kubectl delete configmap frontend-config --ignore-not-found

echo "📦 Reloading Docker image into Minikube to avoid full rebuild..."
minikube image load dhinode/my-react-app:latest

echo "✅ Cleanup complete. You're ready to redeploy!"
echo "👉 Run: ./deploy-all.sh --skip-build"
