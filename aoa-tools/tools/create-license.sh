#!/bin/bash
#set -e

# Function to prompt user for input if the variable is not provided
prompt_user_input() {
    local variable_name=$1
    local prompt_message=$2

    if [[ -z ${!variable_name} ]]; then
        read -p "${prompt_message}: " user_input
        eval "${variable_name}=${user_input}"
    fi
}

# Input variables with default values
LICENSE_KEY=${1:-""}
cluster_context=${2:-"mgmt"}

# Prompt user for input if variables are not provided
prompt_user_input LICENSE_KEY "Please provide your Gloo Mesh Enterprise License Key"

# Check OS type and encode the license key accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64 -w 0)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64 | tr -d '[:space:]')
else
    echo "Unknown OS type"
    exit 1
fi

# Create namespace for Gloo Mesh
kubectl create ns gloo-mesh --context "${cluster_context}"

# Apply license keys as a Kubernetes secret
kubectl apply --context "${cluster_context}" -f - <<EOF
apiVersion: v1
data:
  gloo-gateway-license-key: ${BASE64_LICENSE_KEY}
  gloo-mesh-license-key: ${BASE64_LICENSE_KEY}
  gloo-network-license-key: ${BASE64_LICENSE_KEY}
  gloo-trial-license-key: ${BASE64_LICENSE_KEY}
kind: Secret
metadata:
  name: gloo-license
  namespace: gloo-mesh
type: Opaque
EOF
