#!/bin/bash

echo "wave description:"
echo "deploying gloo-operator"

kubectl create namespace gloo-system --context ${cluster_context}

# Install Gateway API CRDs
echo "installing Gateway API CRDs"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml