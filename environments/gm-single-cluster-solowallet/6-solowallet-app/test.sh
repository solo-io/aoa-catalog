#!/bin/bash

# wait for completion of bank-demo install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment frontend bank-demo 10 ${cluster_context}