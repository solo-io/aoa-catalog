#!/bin/bash

echo "wave description:"
echo "istiod and ingress gateway deployments"

if [ "${environment_overlay}" == "ocp" ] ; then 
     oc --context ${cluster_context} adm policy add-scc-to-group anyuid system:serviceaccounts:istio-system
     oc --context ${cluster_context} adm policy add-scc-to-group anyuid system:serviceaccounts:istio-gateways
     oc --context ${cluster_context} adm policy add-scc-to-group anyuid system:serviceaccounts:gm-iop-1-14
  fi
