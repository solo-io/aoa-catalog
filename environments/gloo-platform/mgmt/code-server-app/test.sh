#!/bin/bash

# wait for completion of code-server install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment code-server code-server 10 ${cluster_context}