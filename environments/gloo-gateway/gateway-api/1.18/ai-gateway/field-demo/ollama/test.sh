#!/bin/bash

# wait for ollama qwen deployment
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment ollama-qwen ollama 10
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment ollama-deepseek ollama 10

echo "navigate to the following directory to run through AI gateway demos:"
echo "cd environments/gloo-gateway/gateway-api/1.18/ai-gateway/field-demo/demos"
echo
