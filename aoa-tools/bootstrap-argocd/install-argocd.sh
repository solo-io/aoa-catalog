#!/bin/bash

INSTALL_TYPE=${1:-"default"} # default/insecure/insecure-rootpath
CONTEXT=${2}

echo "Beginning installation on context ${CONTEXT}...."

# Create argocd namespace
kubectl --context "${CONTEXT}" create namespace argocd

# Deploy argocd silently
until kubectl --context "${CONTEXT}" apply -k "${INSTALL_TYPE}/" > /dev/null 2>&1; do
  echo "Installing argocd. Please wait..."
  sleep 2
done

# Set the default password for the admin user
# Bcrypt(password)=$2a$10$79yaoOg9dL5MO8pn8hGqtO4xQDejSEVNWAGQR268JHLdrCw6UCYmy
# Password: solo.io
kubectl --context "${CONTEXT}" -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$79yaoOg9dL5MO8pn8hGqtO4xQDejSEVNWAGQR268JHLdrCw6UCYmy",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}' > /dev/null 2>&1

# Create argo app-of-apps project
kubectl apply --context "${CONTEXT}" -f- <<EOF
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: app-of-apps
  namespace: argocd
spec:
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  destinations:
  - namespace: '*'
    server: '*'
  sourceRepos:
  - '*'
EOF
