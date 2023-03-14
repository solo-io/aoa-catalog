#!/bin/bash

until kubectl --context ${cluster_context} -n gloo-mesh wait --for condition=established crd/kubernetesclusters.admin.gloo.solo.io ; do sleep 10; done

kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: mgmt
  namespace: gloo-mesh
spec:
  clusterDomain: cluster.local
EOF

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment ext-auth-service gloo-mesh-addons 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment rate-limiter gloo-mesh-addons 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment redis gloo-mesh-addons 10 ${cluster_context}

