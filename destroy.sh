#!/bin/bash

read -p "Enter namespace to destroy (e.g. prod): " NAMESPACE

echo "Deleting ArgoCD application..."
argocd app delete my-app --yes

echo "Uninstalling Kafka release from namespace '$NAMESPACE'..."
helm uninstall my-release --namespace "$NAMESPACE"

echo "Deleting namespace '$NAMESPACE'..."
kubectl delete namespace "$NAMESPACE"

echo "Cleanup completed for namespace '$NAMESPACE'."
