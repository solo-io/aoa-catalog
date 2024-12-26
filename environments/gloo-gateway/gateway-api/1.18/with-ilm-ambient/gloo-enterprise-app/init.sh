#!/bin/bash

echo "wave description:"
echo "deploy gloo edge"

# argocd repo server check
echo "checking that argocd-repo-server is ready before deploying wave"
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-repo-server argocd 5

# check to see if license key variable was passed through, if not prompt for key
if [[ ${license_key} == "" ]]
  then
    # provide license key
    echo "Please provide your Gloo Edge Enterprise License Key:"
    read license_key
fi

# check OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        BASE64_license_key=$(echo -n "${license_key}" | base64 -w 0)
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        BASE64_license_key=$(echo -n "${license_key}" | base64)
else
        echo unknown OS type
        exit 1
fi

# license stuff
kubectl create ns gloo-system --context ${cluster_context}

kubectl apply --context ${cluster_context} -f - <<EOF
apiVersion: v1
data:
  license-key: ${BASE64_license_key}
kind: Secret
metadata:
  labels:
    app: gloo
    gloo: license
  name: license
  namespace: gloo-system
type: Opaque
EOF