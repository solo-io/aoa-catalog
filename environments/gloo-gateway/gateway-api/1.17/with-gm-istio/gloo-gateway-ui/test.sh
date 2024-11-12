#!/bin/bash

until kubectl --context ${cluster_context} -n gloo-mesh wait --for condition=established crd/kubernetesclusters.admin.gloo.solo.io > /dev/null 2>&1; do sleep 10; done

kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: mgmt
  namespace: gloo-system
spec:
  clusterDomain: cluster.local
EOF
