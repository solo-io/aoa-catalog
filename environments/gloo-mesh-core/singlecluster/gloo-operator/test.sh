#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-operator gloo-system 10 ${cluster_context}