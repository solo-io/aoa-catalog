#!/bin/bash

if [ "${environment_overlay}" == "ilcm" ] || [ "${environment_overlay}" == "ilcm-m1" ]; then 
     echo ""
  else 
     #$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-16 istio-gateways 10 ${cluster_context}
     $SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-16 istio-gateways 10 ${cluster_context}
  fi

