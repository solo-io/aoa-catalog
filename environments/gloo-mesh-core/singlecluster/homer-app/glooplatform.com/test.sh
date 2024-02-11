#!/bin/bash

ISTIO_REVISION="1-20"

echo 
echo "Installation complete:"
echo "A homepage has been exposed to simplify navigation"
echo "access the dashboard at https://demo.admin.gmc.glooplatform.com/solo"
echo
echo "If using LoadBalancer External-IP:"
echo "access the dashboard at https://$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo