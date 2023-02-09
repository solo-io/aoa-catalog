#!/bin/bash

echo "wave description:"
echo "namespaces, configmaps, secrets"
sleep 5

# create license
$SCRIPT_DIR/tools/create-license.sh "${license_key}" "${cluster_context}"