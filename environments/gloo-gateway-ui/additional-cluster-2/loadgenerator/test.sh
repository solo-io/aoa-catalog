#!/bin/bash

# wait for completion of httpbin install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment bookinfo-loadgen loadgen 10 ${cluster_context}

