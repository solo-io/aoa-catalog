#!/bin/bash

# wait for completion of frontend install
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment frontend web-ui 10 ${cluster_context}

# echo port-forward commands
echo 
echo "access argocd dashboard:"
echo "kubectl port-forward svc/argocd-server -n argocd 9999:443 --context ${cluster_context}"
echo
echo "navigate to http://localhost:9999/argo in your browser for argocd"
echo
echo "username: admin"
echo "password: solo.io"