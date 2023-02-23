#!/bin/bash

if [ "${environment_overlay}" == "ocp" ] ; then 
     $SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-14 istio-gateways 10 ${cluster_context}
     #$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-14 istio-eastwest 10 ${cluster_context}
  else
     $SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway-1-15 istio-gateways 10 ${cluster_context}
     #$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-15 istio-eastwest 10 ${cluster_context}
  fi