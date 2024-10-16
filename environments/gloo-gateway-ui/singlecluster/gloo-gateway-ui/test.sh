#!/bin/bash

until kubectl --context ${cluster_context} -n gloo-system wait --for condition=established crd/kubernetesclusters.admin.gloo.solo.io > /dev/null 2>&1; do sleep 10; done

kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: mgmt
  namespace: gloo-system
spec:
  clusterDomain: cluster.local
EOF

# wait for gloo mesh mgmt server
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-system-mgmt-server gloo-system 10 ${cluster_context}

