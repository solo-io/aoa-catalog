#!/bin/bash

echo 
echo "installation complete:"
echo
echo "To access applications, follow the methods below:"
echo 
echo "Method 1 - LoadBalancer External-IP: modify /etc/hosts on your local machine (this will require sudo privileges)"
echo "cat <<EOF | sudo tee -a /etc/hosts"
echo "$(kubectl -n gloo-system get service gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}') argocd-local.glootest.com bookinfo-local.glootest.com httpbin-local.glootest.com"
echo "EOF"
echo
echo "Method 2 - K3d LB Integration: modify /etc/hosts on your local machine (this will require sudo privileges)"
echo "cat <<EOF | sudo tee -a /etc/hosts"
echo "localhost argocd-local.glootest.com bookinfo-local.glootest.com httpbin-local.glootest.com"
echo "EOF"
echo
echo "access argocd at https://argocd-local.glootest.com/argo"
echo "access the bookinfo application at: https://bookinfo-local.glootest.com/productpage"
echo "access the httpbin application at: https://httpbin-local.glootest.com/get"
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