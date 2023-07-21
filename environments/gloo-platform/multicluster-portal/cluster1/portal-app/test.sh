#!/bin/bash

#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment pets-rest-api petstore 5 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment tracks-rest-api tracks 5 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment portal-frontend httpbin 5 ${cluster_context}