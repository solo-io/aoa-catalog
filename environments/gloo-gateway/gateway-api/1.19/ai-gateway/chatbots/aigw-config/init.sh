#!/bin/bash

echo "wave description:"
echo "deploy ai-gateway"

echo "this demo requires the following API keys configured in the vars.env, if not provided the script will prompt for them:"
echo "openai_api_key"
echo "anthropic_api_key"
echo

# check to see if llm key variables were passed through, if not prompt for keys
if [[ ${openai_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your OpenAI API key:"
    read openai_api_key
fi

# check to see if llm key variables were passed through, if not prompt for keys
if [[ ${anthropic_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your OpenAI API key:"
    read anthropic_api_key
fi

kubectl create secret generic openai-secret -n gloo-system \
--from-literal="Authorization=Bearer $openai_api_key" \
--dry-run=client -oyaml | kubectl apply -f -

kubectl create secret generic anthropic-secret -n gloo-system \
--from-literal="Authorization=Bearer $anthropic_api_key" \
--dry-run=client -oyaml | kubectl apply -f -