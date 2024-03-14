#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment vegeta-ns-1 ns-1 10 ${cluster_context}

