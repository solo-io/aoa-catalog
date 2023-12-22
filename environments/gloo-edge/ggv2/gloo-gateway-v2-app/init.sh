#!/bin/bash

echo "wave description:"
echo "deploy gloo gateway v2"

# argocd repo server check
echo "checking that argocd-repo-server is ready before deploying wave"
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-repo-server argocd 5