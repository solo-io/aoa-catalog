#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo "A homepage has been exposed at the Gloo Gateway wildcard '*' host to simplify navigation"
echo "if running locally with K3d:" 
echo "access the dashboard at http://localhost/solo"
echo
echo "If using LoadBalancer External-IP:"
echo "access the dashboard at https://homer.glootest.com/solo"
echo