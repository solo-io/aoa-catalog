#!/bin/bash

echo "wave description:"
echo "istiod and ingress gateway deployments"

kubectl create ns istio-system --context ${cluster_context}