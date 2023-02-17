#!/bin/bash

ISTIO_REVISION="1-15"

echo 
echo "installation complete:"
echo
echo "To access applications, follow the methods below:"
echo 
echo "Method 1 - LoadBalancer External-IP: modify /etc/hosts on your local machine (this will require sudo privileges)"
echo "cat <<EOF | sudo tee -a /etc/hosts"
echo "$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].ip}') argocd-local.glootest.com gmui-local.glootest.com"
echo "EOF"
echo
echo "Method 2 - K3d LB Integration: modify /etc/hosts on your local machine (this will require sudo privileges)"
echo "cat <<EOF | sudo tee -a /etc/hosts"
echo "localhost argocd-local.glootest.com gmui-local.glootest.com"
echo "EOF"
echo
echo "access argocd at https://argocd-local.glootest.com/argo"
echo "access Gloo Mesh UI at https://gmui-local.glootest.com"
echo
echo "Method 3: use port-forwarding"
echo "alternatively, access argocd using port-forward command:" 
echo "kubectl port-forward svc/argocd-server -n argocd 9999:443"
echo
echo "argocd credentials:"
echo "user: admin"
echo "password: solo.io"
echo
echo "access argocd at https://localhost:9999/argo"
echo 
echo
echo "access gloo mesh ui using port-forward command:" 
echo "kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context mgmt"
echo
echo "access gloo mesh ui at https://localhost:8090"
echo 