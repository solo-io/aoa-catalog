#!/bin/bash

# wait for completion of app install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment tier-1-app-a ns-1 10 ${cluster_context}
