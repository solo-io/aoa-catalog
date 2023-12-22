#!/bin/bash

# wait for gloo edge deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment glood-gloo-gateway-v2 gloo-system 10
