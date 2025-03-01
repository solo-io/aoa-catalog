#!/bin/bash

# wait for gloo chatbot deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment betterchatgpt-deployment ai-chatbot 10