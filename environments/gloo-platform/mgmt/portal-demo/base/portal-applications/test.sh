#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment backstage backstage 10 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment portal-frontend external-portal 5 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment pets-rest-api petstore 5 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment tracks-rest-api tracks 5 ${cluster_context}
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment httpbin httpbin 5 ${cluster_context}