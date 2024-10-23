#!/bin/bash

# wait for deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment portal-frontend gloo-system 10