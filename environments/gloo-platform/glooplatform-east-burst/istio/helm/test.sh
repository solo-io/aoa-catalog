#!/bin/bash

if [ "${environment_overlay}" == "ilcm" ] ; then 
     echo ""
  else 
     #$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-18 istio-gateways 10 ${cluster_context}
     $SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-18 istio-gateways 10 ${cluster_context}
  fi

