#!/bin/bash

until kubectl --context ${cluster_context} -n gloo-mesh wait --for condition=established crd/kubernetesclusters.admin.gloo.solo.io > /dev/null 2>&1; do sleep 10; done

# wait for gloo mesh mgmt server
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-mesh-mgmt-server gloo-mesh 10 ${cluster_context}
