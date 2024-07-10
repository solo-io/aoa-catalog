#!/bin/bash

# wait for bookinfo deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment productpage-v1 bookinfo 10