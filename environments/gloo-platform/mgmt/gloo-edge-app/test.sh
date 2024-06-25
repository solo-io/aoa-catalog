#!/bin/bash

# wait for gloo control plane deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo gloo-system 10

# wait for gloo proxy deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-proxy-https gloo-system 10