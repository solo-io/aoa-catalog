#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} = "-h" || ${1:-} = "--help" ]]; then
	echo "Starts Colima and K3s"
	echo ""
	echo "Usage: colima delete --force && $0"
fi

# new
colima start --cpu 6 --memory 16 \
  --vm-type=vz \
  --kubernetes \
  --network-address \
  --k3s-arg "--disable=traefik"

# Setup colima for ssh capability
printf "=== Installing socat\n"
colima ssh -- sudo apt install -y socat

# Add node labels
kubectl label nodes colima topology.kubernetes.io/region=us-west
kubectl label nodes colima topology.kubernetes.io/zone=us-west-1

# change context
kubectl config rename-context colima ${cluster_context}