#!/bin/bash

ISTIO_REVISION="1-16"

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-${ISTIO_REVISION} istio-gateways 10 ${cluster_context}