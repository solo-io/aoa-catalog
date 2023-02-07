#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment petstore-v1 default 5
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment petstore-v2 default 5