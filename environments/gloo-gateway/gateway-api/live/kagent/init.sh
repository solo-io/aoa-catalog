#!/bin/bash

echo "wave description:"
echo "deploy ai-gateway"

echo "this demo requires the following API keys configured in the vars.env, if not provided the script will prompt for them:"
echo "openai_api_key"

# check to see if llm key variables were passed through, if not prompt for keys
if [[ ${openai_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your OpenAI API key:"
    read openai_api_key
fi

kubectl create secret generic kagent-openai -n kagent \
  --from-literal="OPENAI_API_KEY=$openai_api_key" \
  --dry-run=client -oyaml | kubectl apply -f -

helm upgrade -i kagent oci://ghcr.io/kagent-dev/kagent/helm/kagent \
    --namespace kagent \
    --create-namespace \
    --version 0.1.11 \
    --set openai.secretName="kagent-openai"