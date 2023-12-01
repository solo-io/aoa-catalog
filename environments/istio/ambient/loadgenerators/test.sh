#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment plow-ns-1 istio-system 10 ${cluster_context}

