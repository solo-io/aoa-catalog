#!/bin/bash

# wait for gloo mesh agent
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-mesh-agent gloo-system 10 ${cluster_context}

