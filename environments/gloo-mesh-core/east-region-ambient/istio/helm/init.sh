#!/bin/bash

echo "wave description:"
echo "istiod and ingress gateway deployments"

# install Kubernetes Gateway CRDs
echo "installing Kubernetes Gateway CRDs"
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.0.0" | kubectl apply -f -; }