#!/bin/bash

echo "wave description:"
echo "deploy gloo gateway v2"

# argocd repo server check
echo "checking that argocd-repo-server is ready before deploying wave"
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-repo-server argocd 5

# apply the gateway api CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

# create gloo-system namespace
kubectl create namespace gloo-system