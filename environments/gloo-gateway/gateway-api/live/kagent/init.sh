#!/bin/bash

echo "wave description:"
echo "deploy kagent"

helm upgrade -i kagent oci://ghcr.io/kagent-dev/kagent/helm/kagent \
    --namespace kagent \
    --create-namespace \
    --version 0.1.11 \
    --set openai.apiKey=$OPENAI_API_KEY