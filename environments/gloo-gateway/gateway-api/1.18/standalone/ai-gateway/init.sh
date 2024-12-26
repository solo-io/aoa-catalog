#!/bin/bash

echo "wave description:"
echo "deploy ai-gateway"

echo "this demo requires the following API keys configured in the vars.env, if not provided the script will prompt for them:"
echo "openai_api_key"
echo "claude_api_key"
echo "google_api_key"
echo "mistral_api_key"
echo

# check to see if llm key variables were passed through, if not prompt for keys
if [[ ${openai_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your OpenAI API key:"
    read openai_api_key
fi

if [[ ${claude_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your Anthropic API key:"
    read claude_api_key
fi

if [[ ${google_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your Google Gemini API key:"
    read google_api_key
fi

if [[ ${mistral_api_key} == "" ]]
  then
    # provide license key
    echo "Key not found in env.var file, please provide your Mistral API key:"
    read mistral_api_key
fi

# check OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        BASE64_openai_api_key=$(echo -n "${openai_api_key}" | base64 -w 0)
        BASE64_claude_api_key=$(echo -n "${claude_api_key}" | base64 -w 0)
        BASE64_google_api_key=$(echo -n "${google_api_key}" | base64 -w 0)
        BASE64_mistral_api_key=$(echo -n "${mistral_api_key}" | base64 -w 0)
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        BASE64_openai_api_key=$(echo -n "${openai_api_key}" | base64)
        BASE64_claude_api_key=$(echo -n "${claude_api_key}" | base64)
        BASE64_google_api_key=$(echo -n "${google_api_key}" | base64)
        BASE64_mistral_api_key=$(echo -n "${mistral_api_key}" | base64)
else
        echo unknown OS type
        exit 1
fi

kubectl create namespace ai-chatbot

kubectl apply --context ${cluster_context} -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ai-chatbot-keys
  namespace: ai-chatbot
type: Opaque
data:
  openai-api-key: ${BASE64_openai_api_key}
  claude-api-key: ${BASE64_claude_api_key}
  google-api-key: ${BASE64_google_api_key}
  mistral-api-key: ${BASE64_mistral_api_key}
EOF