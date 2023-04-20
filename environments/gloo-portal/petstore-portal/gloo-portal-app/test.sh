#!/bin/bash

# wait for gloo portal deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-portal-controller gloo-portal 5
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-portal-admin-server gloo-portal 5
