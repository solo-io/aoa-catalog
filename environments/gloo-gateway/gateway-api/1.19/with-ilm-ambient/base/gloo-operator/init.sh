#!/bin/bash

echo "wave description:"
echo "deploying gloo-operator"

kubectl create namespace gloo-system --context ${cluster_context}

# Install Gateway API CRDs
echo "installing Gateway API CRDs"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

helm upgrade -i gloo-operator oci://us-docker.pkg.dev/solo-public/gloo-operator-helm/gloo-operator \
--version "0.2.3" -n gloo-system --kube-context "$context" --create-namespace \
--set manager.env.SOLO_ISTIO_LICENSE_KEY=$gloo_mesh_license_key