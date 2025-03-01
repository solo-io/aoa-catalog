#!/bin/bash

# wait for rollouts demo ui success
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argo-rollouts-dashboard rollouts-demo 10