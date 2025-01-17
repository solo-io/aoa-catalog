#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwest istio-gateways 10 ${cluster_context}