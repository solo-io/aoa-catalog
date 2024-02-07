#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment homer-portal homer-portal 10 ${cluster_context}

echo 
echo "Installation complete:"
echo "A homepage has been exposed to simplify navigation"
echo "access the dashboard at https://demo.gmc.glooplatform.com/solo"
echo