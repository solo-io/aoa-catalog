#!/bin/bash
#set -e

# Function to prompt user for input if the variable is not provided
prompt_user_input() {
    local variable_name=$1
    local prompt_message=$2
    local default_value=$3

    if [[ -z ${!variable_name} ]]; then
        read -p "${prompt_message}: " user_input
        # Use the default value if the user doesn't provide any input
        eval "${variable_name}=${user_input:-${default_value}}"
    fi
}

# Input variables with default values
path=${1:-""}
wave_name=${2:-""}
cluster_context=${3:-""}
github_username=${4:-""}
repo_name=${5:-""}
target_branch=${6:-""}
parent_app_sync=${7:-""}

# Prompt user for input if variables are not provided
prompt_user_input wave_name "Please provide the wave name " ""
prompt_user_input cluster_context "Please provide the cluster context to use (i.e. mgmt, cluster1, cluster2)" ""
prompt_user_input github_username "Please provide the GitHub username to use (i.e. solo-io)" ""
prompt_user_input repo_name "Please provide the repo name to use (i.e. aoa-catalog)" ""
prompt_user_input target_branch "Please provide the target branch to use (i.e. HEAD)" ""
prompt_user_input parent_app_sync "Please provide the parent_app_sync to use (true/false)" ""

# Apply ArgoCD Application configuration
kubectl --context "${cluster_context}" apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wave-${wave_name}-aoa
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io/solo-io
spec:
  project: app-of-apps
  source:
    repoURL: https://github.com/${github_username}/${repo_name}/
    targetRevision: ${target_branch}
    path: ${path}
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: ${parent_app_sync}
      selfHeal: ${parent_app_sync}
    retry:
      limit: 2
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m0s
EOF
