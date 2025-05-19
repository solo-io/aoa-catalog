#!/bin/bash

set -e  # Exit on any error
set -o pipefail  # Catch errors in pipelines

# Define cluster contexts
CLUSTER1="cluster1"
CLUSTER2="cluster2"

# Ensure necessary tools are installed
for cmd in kubectl helm; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is not installed. Please install it and rerun the script."
        exit 1
    fi
done

echo "Starting interactive Istio multicluster failover demo..."

echo
read -p "Step 1: Port forward tier-1-app-a on $CLUSTER1. Press Enter to proceed..."
kubectl port-forward svc/tier-1-app-a -n ns-1 8080:8080 --context "$CLUSTER1" >/dev/null 2>&1 &
PORT_FORWARD_PID=$!
echo "Port forwarding started. Application accessible at http://localhost:8080/ns-1"

echo
read -p "Step 2: Scale down tier-2-app-a on $CLUSTER1 to test failover. Press Enter to proceed..."
kubectl scale deploy/tier-2-app-a-v1 -n ns-1 --replicas 0 --context "$CLUSTER1"
sleep 2
kubectl get deploy -n ns-1 --context "$CLUSTER1"
echo "tier-2-app-a scaled down on $CLUSTER1. The application should still be alive with no errors."

echo
echo "Step 3: Open a new terminal tab and run the following command to check logs on $CLUSTER2:"
echo "kubectl logs -n ns-1 deploy/tier-2-app-a-v1 -f --context \"$CLUSTER2\""
read -p "Press Enter to proceed once you have checked the logs..."

echo
read -p "Step 4: Scale tier-2-app-a back up on $CLUSTER1. Press Enter to proceed..."
kubectl scale deploy/tier-2-app-a-v1 -n ns-1 --replicas 1 --context "$CLUSTER1"
sleep 2
kubectl get deploy -n ns-1 --context "$CLUSTER1"
echo "tier-2-app-a scaled back up on $CLUSTER1."

echo
echo "Step 5: Open a new terminal tab and run the following command to check logs on $CLUSTER1:"
echo "kubectl logs -n ns-1 deploy/tier-2-app-a-v1 -f --context \"$CLUSTER1\""
read -p "Press Enter to proceed once you have verified traffic recovery..."

echo
read -p "Step 6: Cleanup and end demo. Press Enter to proceed..."

# Kill the port-forwarding process
if ps -p $PORT_FORWARD_PID > /dev/null; then
  kill $PORT_FORWARD_PID >/dev/null 2>&1
  echo "Port forwarding process terminated."
fi
