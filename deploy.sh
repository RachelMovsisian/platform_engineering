#!/bin/bash

read -p "Enter namespace to deploy (e.g. prod): " NAMESPACE

echo "Adding Helm repo bitnami..."
helm repo add bitnami https://charts.bitnami.com/bitnami

echo "Updating Helm repos..."
helm repo update

echo "Creating namespace '$NAMESPACE' if it doesn't exist..."
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"

echo "Installing Kafka chart in namespace '$NAMESPACE'..."
helm install my-release bitnami/kafka -f kafka-values-"$NAMESPACE".yaml --namespace "$NAMESPACE"

echo "Creating ArgoCD application in namespace '$NAMESPACE'..."
argocd app create my-app \
  --repo https://github.com/RachelMovsisian/platform_engineering.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace "$NAMESPACE" \
  --sync-policy automated
  --helm-values-file values-${NAMESPACE}.yaml

echo "Deployment to namespace '$NAMESPACE' completed."

