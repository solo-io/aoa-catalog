#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment petstore-dev petstore 5
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment petstore-prod petstore 5