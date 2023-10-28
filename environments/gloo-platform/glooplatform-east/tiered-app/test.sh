#!/bin/bash

# wait for completion of app install
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment httpbin httpbin 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment friendly-guy-v1 ns-1 10 ${cluster_context}
