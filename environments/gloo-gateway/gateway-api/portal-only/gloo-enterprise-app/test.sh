#!/bin/bash

# wait for gloo edge deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo gloo-system 10
