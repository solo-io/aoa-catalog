#!/bin/bash

echo 
echo "Installation complete:"
echo "A homepage has been exposed at the Gloo Gateway wildcard '*' host to simplify navigation"
echo "if running locally with K3d:" 
echo "access the dashboard at https://localhost/solo"
echo
echo "If using LoadBalancer External-IP:"
echo "access the dashboard at https://$(kubectl --context ${mgmt_context} get svc -n istio-gateways --selector=istio=mgmt-ingressgateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].*}')/solo"
echo
echo "Additional details on hostname entries for this demo environment will be provided in the Welcome section, but is also described in the README section below:"
echo "https://github.com/solo-io/aoa-catalog/tree/main/environments"
echo
echo