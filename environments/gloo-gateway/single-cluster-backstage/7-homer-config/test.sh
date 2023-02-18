#!/bin/bash

ISTIO_REVISION="1-15"

echo 
echo "Installation complete:"
echo "A homepage has been exposed at the Gloo Gateway wildcard '*' host to simplify navigation"
echo "if running locally with K3d:" 
echo "access the dashboard at https://localhost"
echo
echo "If using LoadBalancer External-IP:"
echo "access the dashboard at https://$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo
echo "Additional details on hostname entries for this demo environment will be provided in the Welcome section, but is also described in the README section below:"
echo "https://github.com/solo-io/aoa-catalog/tree/main/environments/gloo-gateway/single-cluster-backstage#application-description"
echo
echo