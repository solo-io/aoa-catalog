#!/bin/bash

# wait for rollouts-demo success
until kubectl argo rollouts status --timeout 300s rollouts-demo -n rollouts-demo --context ${cluster_context} 2> /dev/null; do sleep 2; done