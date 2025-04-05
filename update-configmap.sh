#!/bin/bash

BACKEND_SERVICE_NAME=backend
CONFIGMAP_NAME=frontend-config
FRONTEND_DEPLOYMENT=frontend

MINIKUBE_IP=$(minikube ip)
BACKEND_PORT=$(kubectl get svc $BACKEND_SERVICE_NAME -o jsonpath='{.spec.ports[0].nodePort}')
FULL_URL="http://$MINIKUBE_IP:$BACKEND_PORT"

echo "➡️ Updating REACT_APP_API_URL to: $FULL_URL"

kubectl create configmap $CONFIGMAP_NAME \
  --from-literal=REACT_APP_API_URL="$FULL_URL" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl rollout restart deployment $FRONTEND_DEPLOYMENT

echo "✅ Frontend restarted. Access at: http://$MINIKUBE_IP:30080"
