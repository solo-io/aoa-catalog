#!/bin/bash

until kubectl argo rollouts status --timeout 300s echo-rollout -n echo --context ${cluster_context} 2> /dev/null; do sleep 2; done