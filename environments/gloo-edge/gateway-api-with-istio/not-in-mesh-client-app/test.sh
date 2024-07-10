#!/bin/bash

# wait for bookinfo deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment not-in-mesh-client-deployment client 10