#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway istio-system 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh ds ztunnel istio-system 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh ds istio-cni-node kube-system 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-20 istio-eastwest 10 ${cluster_context}