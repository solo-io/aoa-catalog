#!/bin/bash

seconds=0
OUTPUT=0

# Example rollout would be deployments/<deployment_name>
rollout_type=$1
rollout_name=$2
namespace=$3
period=$4
context=$5

# If the context is not specified, use the default context
if [[ ${context} == "" ]]; then
  context=$(kubectl config current-context)
  if [[ ${context} == "" ]]; then
    echo "You do not have a current Kubernetes cluster. Please create one."
    exit 1
  fi
  echo "No context specified. Using current context of ${context}"
fi

while [ "$OUTPUT" -ne 1 ]; do
  OUTPUT=$(kubectl get ${rollout_type}/${rollout_name} -n ${namespace} --context ${context} 2>/dev/null | grep -c ${rollout_name})
  seconds=$((seconds + ${period}))
  printf "Waiting %s seconds for %s %s to come up.\n" "${seconds}" "${rollout_type}" "${rollout_name}"
  sleep ${period}
  kubectl rollout status ${rollout_type}/${rollout_name} -n ${namespace} --context ${context}
done
