#!/bin/bash

# wait for completion of helloworld install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment helloworld-v1 helloworld 10 ${cluster_context}