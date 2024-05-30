#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment openai-eli5-client-deployment ai-client 10 ${cluster_context}