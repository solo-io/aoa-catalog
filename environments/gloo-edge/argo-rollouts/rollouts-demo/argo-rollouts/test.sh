#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argo-rollouts argo-rollouts 10 ${cluster_context}