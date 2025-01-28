#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} = "-h" || ${1:-} = "--help" ]]; then
	echo "Starts Colima and K3s"
	echo ""
	echo "Usage: colima delete --force && $0"
fi

# new
colima start --cpu 6 --memory 16 \
  --profile=${cluster_context} \
  --vm-type=vz \
  --kubernetes \
  --kubernetes-version v1.31.2+k3s1 \
  --k3s-arg "--disable=traefik"

# Add node labels
kubectl label nodes colima-${cluster_context} topology.kubernetes.io/region=us-west
kubectl label nodes colima-${cluster_context} topology.kubernetes.io/zone=us-west-1

# change context
kubectl config rename-context colima-${cluster_context} ${cluster_context}