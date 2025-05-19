#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istiod-main istio-system 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-main istio-eastwest 10 ${cluster_context}