#!/bin/bash
set -e

# CONFIG
FRONTEND_DEPLOYMENT=frontend
FRONTEND_SERVICE=frontend
CONFIGMAP_NAME=frontend-config
BACKEND_SERVICE=backend
K8S_DIR=./k8s

# 🔧 Function to cleanup all Kubernetes resources
cleanup_k8s_resources() {
  if ! minikube status | grep -q "host: Running"; then
    echo "⚠️  Minikube is not running. Cannot clean Kubernetes resources."
    return
  fi

  echo "🧼 Cleaning up Kubernetes resources..."
  kubectl delete deployments --all --ignore-not-found
  kubectl delete services --all --ignore-not-found
  kubectl delete configmap --all --ignore-not-found
  kubectl delete hpa --all --ignore-not-found
  echo "✅ Kubernetes resources cleaned."
}

# 🆘 Show help
show_help() {
  echo "Usage: $0 [--clean] [--shutdown] [--help]"
  echo ""
  echo "  --clean      Delete all Kubernetes resources"
  echo "  --shutdown   Delete all resources and stop Minikube"
  echo "  --help       Show this help message"
  exit 0
}

# Parse arguments
CLEAN=false
SHUTDOWN=false

for arg in "$@"; do
  case "$arg" in
    --clean)
      CLEAN=true
      ;;
    --shutdown)
      CLEAN=true
      SHUTDOWN=true
      ;;
    --help)
      show_help
      ;;
    *)
      echo "❌ Unknown option: $arg"
      show_help
      ;;
  esac
done

# Execute cleanup if requested
if [ "$CLEAN" = true ]; then
  cleanup_k8s_resources
  if [ "$SHUTDOWN" = true ]; then
    echo "🛑 Stopping Minikube..."
    minikube stop
    echo "✅ Minikube stopped."
  fi
  exit 0
fi

# ✅ Deploy normally if no cleanup/shutdown
echo "🚀 Checking Minikube status..."
if ! minikube status | grep -q "host: Running"; then
  echo "⚠️  Minikube is not running. Starting Minikube..."
  minikube start
else
  echo "✅ Minikube is already running."
fi

echo "🧪 Checking if metrics-server is enabled..."
if ! minikube addons list | grep -q 'metrics-server.*enabled'; then
  echo "⚙️  Enabling metrics-server..."
  minikube addons enable metrics-server
else
  echo "✅ metrics-server is already enabled."
fi

echo "📄 Applying Kubernetes manifests (App)..."
kubectl apply -f $K8S_DIR/frontend-configmap.yml
kubectl apply -f $K8S_DIR/frontend-deployment.yml
kubectl apply -f $K8S_DIR/frontend-service.yml
kubectl apply -f $K8S_DIR/backend-deployment.yml
kubectl apply -f $K8S_DIR/backend-service.yml
kubectl apply -f $K8S_DIR/db-deployment.yml
kubectl apply -f $K8S_DIR/db-service.yml
kubectl apply -f $K8S_DIR/db-replica-hpa.yml
kubectl apply -f $K8S_DIR/backend-hpa.yml

echo "📈 Applying Monitoring stack (Prometheus + Grafana)..."
kubectl apply -f $K8S_DIR/prometheus-configmap.yml
kubectl apply -f $K8S_DIR/prometheus-deployment.yml
kubectl apply -f $K8S_DIR/prometheus-service.yml
kubectl apply -f $K8S_DIR/grafana-deployment.yml
kubectl apply -f $K8S_DIR/grafana-service.yml

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

echo -e "\e[1;31m🗿 It's loading, just a sec !\e[0m"
sleep 17

echo "✅ Deployment complete!"
echo "🌍 Frontend:     http://$MINIKUBE_IP:30080"
echo "📊 Grafana:      http://$MINIKUBE_IP:30030"
echo "📡 Prometheus:   http://$MINIKUBE_IP:30090"
