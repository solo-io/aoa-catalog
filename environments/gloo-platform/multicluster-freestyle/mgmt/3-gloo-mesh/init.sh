#!/bin/bash

echo "wave description:"
echo "deploy and register gloo-mesh agent and addons"

if [ "${environment_overlay}" == "ocp" ] ; then 
     oc --context ${cluster_context} adm policy add-scc-to-group anyuid system:serviceaccounts:gloo-mesh-addons
     oc --context ${cluster_context} adm policy add-scc-to-group nonroot system:serviceaccounts:gloo-mesh-prometheus
  fi