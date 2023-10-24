#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo "A homepage has been exposed at the Istio Gateway wildcard '*' host to simplify navigation"
echo
echo "If using LoadBalancer External-IP:"
echo "access the dashboard at https://$(kubectl -n istio-gateways get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].*}')/solo"
echo
echo "Additional details on hostname entries for this demo environment will be provided in the Welcome section, but is also described in the README section below:"
echo "https://github.com/solo-io/aoa-catalog/tree/main/environments"
echo
echo