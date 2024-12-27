#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo "A homepage has been exposed using Gloo Gateway to simplify navigation. All hostnames in this environment use *.glootest.com"
echo
echo "If running locally, you will need to add the following entries to your /etc/hosts file:"
echo "127.0.0.1 argocd.glootest.com homer.glootest.com httpbin.glootest.com bookinfo.glootest.com client.glootest.com" 
echo
echo "If using LoadBalancer External-IP, map the hostnames above to your Load Balancer IP address using your DNS solution of choice (i.e. etc/hosts, CloudFlare, Route53, etc.)"
echo "Discovering Load Balancer IP..."
echo "Load Balancer IP: https://$(kubectl --context ${mgmt_context} get svc -n gloo-system --selector=gloo=kube-gateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')/solo"
echo
echo "access the dashboard at https://homer.glootest.com/solo"
echo
echo "Additional details for this demo environment will be provided in the Welcome section!"