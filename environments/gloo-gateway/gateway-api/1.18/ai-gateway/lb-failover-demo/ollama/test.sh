#!/bin/bash

# wait for ollama qwen deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment ollama-qwen gloo-system 10