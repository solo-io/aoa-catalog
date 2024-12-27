#!/bin/bash

echo "wave description:"
echo "istiod and ingress gateway deployments"

# install Kubernetes Gateway CRDs
echo "installing Kubernetes Gateway CRDs"
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml; }
