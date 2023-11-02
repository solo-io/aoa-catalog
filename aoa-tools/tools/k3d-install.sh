#!/usr/bin/env bash

create-k3d-cluster() {

  name=$1
  config=$2
  region=$3
  zone=$4

  if [ -z "$3" ]; then
    region=us-east-1
  fi

  # No longer used
  if [ -z "$4" ]; then
    zone=us-east-1a
  fi

  this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

  # docker network
  network=k3d-cluster-network

  # create docker network if it does not exist
  docker network create $network > /dev/null 2>&1 || true

  # k3d registry create k3d-registry

  k3d cluster create --wait --config $2

  # remove existing ones if they exist
  kubectl config delete-cluster $name > /dev/null 2>&1 || true
  kubectl config delete-user $name > /dev/null 2>&1 || true
  kubectl config delete-context $name > /dev/null 2>&1 || true

  kubectl config rename-context k3d-$name $name
}

delete-k3d-cluster(){
  name=$1

  network=k3d-cluster-network
  k3d cluster delete $name

  # because we renamed them we need to delete the names
  kubectl config delete-cluster $name > /dev/null 2>&1 || true
  kubectl config delete-user $name > /dev/null 2>&1 || true
  kubectl config delete-context $name > /dev/null 2>&1 || true

  docker network rm $network > /dev/null 2>&1 || true
} 