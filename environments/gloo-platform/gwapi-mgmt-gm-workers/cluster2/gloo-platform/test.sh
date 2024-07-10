#!/bin/bash


# wait for gloo mesh agent
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-mesh-agent gloo-mesh 10 ${cluster_context}

# wait for gloo mesh addons
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment ext-auth-service gloo-mesh-addons 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment rate-limiter gloo-mesh-addons 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment redis gloo-mesh-addons 10 ${cluster_context}

