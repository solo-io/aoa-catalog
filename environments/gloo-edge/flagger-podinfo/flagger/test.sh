#!/bin/bash

# wait for bookinfo deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment flagger gloo-system 10