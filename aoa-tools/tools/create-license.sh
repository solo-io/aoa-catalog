#!/bin/bash
#set -e

# replace the parameter below with your designated cluster context
# note that the character '_' is an invalid value
#
# please use `kubectl config rename-contexts <current_context> <target_context>` to
# rename your context if necessary
LICENSE_KEY=${1:-""}
cluster_context=${2:-mgmt}

# check to see if license key variable was passed through, if not prompt for key
if [[ ${LICENSE_KEY} == "" ]]
  then
    # provide license key
    echo "Please provide your Gloo Mesh Enterprise License Key:"
    read LICENSE_KEY
fi

# check OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64 -w 0)
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64)
else
        echo unknown OS type
        exit 1
fi

# license stuff
kubectl create ns gloo-mesh --context ${cluster_context}

kubectl apply --context ${cluster_context} -f - <<EOF
apiVersion: v1
data:
  gloo-gateway-license-key: ${BASE64_LICENSE_KEY}
  gloo-mesh-license-key: ${BASE64_LICENSE_KEY}
  gloo-network-license-key: ${BASE64_LICENSE_KEY}
  gloo-trial-license-key: ${BASE64_LICENSE_KEY}
kind: Secret
metadata:
  name: license-keys
  namespace: gloo-mesh
type: Opaque
EOF