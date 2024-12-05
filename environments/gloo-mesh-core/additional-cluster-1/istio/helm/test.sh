#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-24 istio-gateways 10 ${cluster_context}