#!/bin/bash

# wait for bookinfo deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment productpage-v1 bookinfo-v1 10
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment productpage-v1 bookinfo-v2 10