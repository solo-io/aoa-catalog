#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-22 istio-gateways 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway istio-gateways 10 ${cluster_context}
