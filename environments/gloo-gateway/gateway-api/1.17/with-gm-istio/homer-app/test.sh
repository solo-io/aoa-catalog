#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo
echo "The applications featured in this demo are hosted under the *.glootest.com domain"
echo
echo "When using K3d locally with the -i flag, add the entries below to your /etc/hosts file:"
echo "127.0.0.1 bookinfo.glootest.com client.glootest.com gmui.glootest.com homer.glootest.com httpbin.glootest.com"
echo 
echo "Otherwise, map the hostnames above to your Load Balancer IP address using your DNS solution of choice (i.e. etc/hosts, CloudFlare, Route53, etc.)"
echo
echo "A homepage has been exposed to simplify navigation, access the dashboard at https://homer.glootest.com/solo"
echo