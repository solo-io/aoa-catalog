#!/bin/bash

echo "wave description:"
echo "deploying gloo-operator"

kubectl create namespace gloo-system --context ${cluster_context}