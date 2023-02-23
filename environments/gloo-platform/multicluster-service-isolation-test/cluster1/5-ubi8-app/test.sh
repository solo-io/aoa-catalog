#!/bin/bash

# wait for completion of bookinfo install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment productpage-v1 bookinfo-frontends 10 ${cluster_context}