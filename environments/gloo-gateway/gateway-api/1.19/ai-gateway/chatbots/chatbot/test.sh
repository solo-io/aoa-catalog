#!/bin/bash

# wait for gloo chatbot deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment general-chat-deployment ai-chatbot 10