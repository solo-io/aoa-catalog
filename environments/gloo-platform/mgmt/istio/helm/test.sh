#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-18 istio-gateways 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-18 istio-eastwest 10 ${cluster_context}