#!/bin/bash

echo "wave description:"
echo "deploy kagent"

helm upgrade -i kagent-crds oci://ghcr.io/kagent-dev/kagent/helm/kagent-crds \
    --namespace kagent \
    --create-namespace \
    --version 0.3.9

helm upgrade -i kagent oci://ghcr.io/kagent-dev/kagent/helm/kagent \
    --namespace kagent \
    --create-namespace \
    --skip-crds \
    --version 0.3.9 \
    --set providers.openAI.apiKey=$openai_api_key