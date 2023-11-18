#!/usr/bin/env bash

# Function to create a k3d cluster
create-k3d-cluster() {
  local name=$1
  local config=$2
  local region=${3:-us-east-1}
  local zone=${4:-us-east-1a}

  # No longer used
  if [ -z "$4" ]; then
    zone=us-east-1a
  fi

  this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

  # Docker network
  network=k3d-cluster-network

  # Create Docker network if it does not exist
  docker network create "$network" > /dev/null 2>&1 || true

  # k3d registry create k3d-registry

  # Create k3d cluster
  k3d cluster create --wait --config "$2"

  # Remove existing ones if they exist
  kubectl config delete-cluster "$name" > /dev/null 2>&1 || true
  kubectl config delete-user "$name" > /dev/null 2>&1 || true
  kubectl config delete-context "$name" > /dev/null 2>&1 || true

  kubectl config rename-context "k3d-$name" "$name"
}

# Function to delete a k3d cluster
delete-k3d-cluster(){
  local name=$1

  network=k3d-cluster-network
  k3d cluster delete "$name"

  # Because we renamed them, we need to delete the names
  kubectl config delete-cluster "$name" > /dev/null 2>&1 || true
  kubectl config delete-user "$name" > /dev/null 2>&1 || true
  kubectl config delete-context "$name" > /dev/null 2>&1 || true

  docker network rm "$network" > /dev/null 2>&1 || true
}
