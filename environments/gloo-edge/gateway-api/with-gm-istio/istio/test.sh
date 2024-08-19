#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istiod-1-23 istio-system 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-23 istio-eastwest 10 ${cluster_context}