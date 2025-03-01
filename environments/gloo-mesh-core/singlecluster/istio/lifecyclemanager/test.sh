#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-operator-1-20 gm-iop-1-20 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istiod-1-20 istio-system 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-20 istio-gateways 10 ${cluster_context}
#./tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-20 istio-eastwest 10 ${cluster_context}