#!/bin/bash

# wait for completion of kubeinvaders install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment kubeinvaders kubeinvaders 10 ${cluster_context}