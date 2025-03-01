#!/bin/bash

# wait for enclosed deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment enclosed-deployment enclosed 10