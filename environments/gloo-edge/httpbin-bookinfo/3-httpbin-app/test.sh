#!/bin/bash

# wait for bookinfo deployment
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment httpbin httpbin 10