#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-operator-1-21 gm-iop-1-21 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istiod-1-21 istio-system 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-21 istio-gateways 10 ${cluster_context}
#./tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-21 istio-eastwest 10 ${cluster_context}