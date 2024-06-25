#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment httpbin-blue httpbin-blue 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment httpbin-green httpbin-green 10 ${cluster_context}