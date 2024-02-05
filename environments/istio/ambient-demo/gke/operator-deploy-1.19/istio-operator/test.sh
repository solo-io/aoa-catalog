#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-operator istio-operator 10 ${cluster_context}
