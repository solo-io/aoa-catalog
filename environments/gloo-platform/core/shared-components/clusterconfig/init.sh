#!/bin/bash

echo "wave description:"
echo "namespaces, configmaps, secrets"

# argocd repo server check
echo "checking that argocd-repo-server is ready before deploying wave"
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-repo-server argocd 5

# create license
$SCRIPT_DIR/tools/create-license.sh "${license_key}" "${cluster_context}"