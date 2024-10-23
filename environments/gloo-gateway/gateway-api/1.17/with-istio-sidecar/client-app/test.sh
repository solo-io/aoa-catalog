#!/bin/bash

# wait for client deployments
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment in-mesh-client-deployment client 10
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment not-in-mesh-client-deployment client 10