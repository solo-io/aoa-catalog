#!/bin/bash

echo "wave description:"
echo "istiod and ingress gateway deployments"

kubectl create ns istio-system --context ${cluster_context}
kubectl apply -f $SCRIPT_DIR/shared-root-trust-secret.yaml --context ${cluster_context}