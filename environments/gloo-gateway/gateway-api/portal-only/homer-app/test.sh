#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo
echo "The applications featured in this demo are hosted under the *.gwapi.glooplatform.com domain"
echo
echo "When using K3d locally with the -i flag, add the entries below to your /etc/hosts file:"
echo "127.0.0.1 argocd.gwapi.glooplatform.com homer.gwapi.glooplatform.com solo-dev-portal.gwapi.glooplatform.com api.gwapi.glooplatform.com tracks.gwapi.glooplatform.com openlibrary.gwapi.glooplatform.com"
echo 
echo "Otherwise, map the hostnames above to your Load Balancer IP address using your DNS solution of choice (i.e. etc/hosts, CloudFlare, Route53, etc.)"
echo
echo "A homepage has been exposed to simplify navigation, access the dashboard at https://homer.gwapi.glooplatform.com/solo"
echo