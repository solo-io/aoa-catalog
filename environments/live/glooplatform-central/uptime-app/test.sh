#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment uptime uptime 10 ${cluster_context}