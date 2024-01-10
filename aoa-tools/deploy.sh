#!/bin/bash
#set -e

############################################################
# Defaults
install_k3d=false
install_colima=false
install_argo=true
export SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


# Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

####################### Functions ##########################

help() {
    # Display Help
    echo "aoa-catalog installer."
    echo
    echo "Syntax: installer [-f|-i|-h|--colima]"
    echo
    echo "commands:"
    echo "deploy     deploys an environment with the specified path"
    echo "destroy    destroys an environment with the specified path"
    echo
    echo "options:"
    echo "-f     path to environment files"
    echo "-i     install infra"
    echo "-h     print help"
    echo
    echo "additional flags:"
    echo "--skip-argo  skip argo installation"
    echo "--colima   execute colima-install.sh script instead of k3d-install.sh"
}

pre_install() {
    check_env
    source_env_vars

    echo "------------------------------------------------------------"
    echo "--------------   AoA Installer - Pre-install   -------------"
    echo "Environment: $env"
    echo "Install infra: $install_k3d"
    echo "Install argo: $install_argo"
    check_git
    echo ""
    echo "Github Account: $github_username"
    echo "Repo: $repo_name"
    echo "Branch: $target_branch"
    echo "Automatic Sync: $parent_app_sync"
    echo "------------------------------------------------------------"

    echo "Continue? [y/N]"

    read -r should_continue
    if [[ ${should_continue} =~ ^([yY])$ ]]; then
        echo ""
    else
        exit 0
    fi
}

check_env() {
    if [[ ${env} == "" || ! -d "$env" ]]; then
        # provide vars file
        printf "${RED}Error: env folder not found, please use -f to choose a valid env folder.${NO_COLOR}\n"
        help
        exit 1
    fi

    # Normalize path
    cd "$env" || exit
    env=$(pwd)
}

check_git()
{

   echo "-------------  Git Validation In Progress  -----------------"
   if [[ "$github_username$target_branch$repo_name" != "" ]]
   then
      printf "${YELLOW}Warning: github_username and/or target_branch and/or repo_name  ${NO_COLOR}\n"
      printf "${YELLOW}has/have been passed in the vars.env, skipping Git validation${NO_COLOR}"      
      return      
   fi 

   cd ${env}
   # Check if valid git repo 
   is_valid_git_repo=$(git rev-parse --is-inside-work-tree) > /dev/null 2>&1
   if [[ ${is_valid_git_repo} != true ]]
   then
      echo "Error: ${env} is not a valid git repo."
      exit 1
   fi 
   # Check if branch is in sync with remote
   git remote update > /dev/null 2>&1 
   local_changes=$(git status -uno -u -s)
   remote_hash=$(git ls-remote --head --exit-code origin $(git branch --show-current) | cut -f 1)
   local_hash=$(git rev-parse $(git branch --show-current))

   if [[ ${local_changes} != "" ]] || [[ ${remote_hash} != ${local_hash} ]]
   then
      printf "${YELLOW}Warning: the AoA files local changes are not in sync with the   ${NO_COLOR}\n"
      printf "${YELLOW}Git remote branch, make sure to push your local changes.${NO_COLOR}"
   else
      printf "${GREEN}Git Validation - Success ${NO_COLOR}"
   fi 

   origin=$(git remote get-url origin)  
   if [[ $( echo "$origin" | grep git@github.com) != "" ]]
   then
      # shh repo
      BASE=$(echo $origin | sed -e "s+git@github.com:++g") 
   elif [[ $( echo "$origin" | grep https://github.com) != "" ]]
   then 
      # http repo
      BASE=$(echo $origin | sed -e "s+https://github.com/++g" | sed -e "s+.git++g")   
   fi
   IFS='/' read -ra ADDR <<< "$BASE"
   github_username=${ADDR[0]}
   repo_name=${ADDR[1]}
   target_branch=$(git branch --show-current)
   echo ""
}

source_env_vars(){
cd $env
tmp_env=$env
source vars.env && export $(sed '/^#/d' vars.env | cut -d= -f1)
unset env
export env=$tmp_env
unset tmp_env

}

install_k3d()
{
   check_env
   echo "Deploying infra..."

   if [[ ${install_colima} == false ]]; then
       source $SCRIPT_DIR/tools/k3d-install.sh

       if [ -d "$env/.infra" ]
       then
          cd $env/.infra
          for i in $(ls | sort -n); do 
                create-k3d-cluster $(cat $i | yq .metadata.name) ${i}
          done      
       fi 
   else
       source $SCRIPT_DIR/tools/colima-install.sh
   fi
}


destroy_infra()
{
    check_env
    echo "Destroying infra..."

    if [[ ${install_colima} == true ]]; then
        colima delete --force
        rm ~/.kube/config
    elif [[ ${install_colima} == false ]]; then
        if [ -d "$env/.infra" ]; then
            cd $env/.infra
            for i in $(ls | sort -n); do 
                k3d cluster delete $(cat $i | yq .metadata.name) ${i}
                kubectl config delete-context $(cat $i | yq .metadata.name)
            done      
        fi 
    fi
}



#destroy_infra()
#{
#   check_env
#   echo "Destroying infra..."
#
#   if [ -d "$env/.infra" ]
#   then
#      cd $env/.infra
#      for i in $(ls | sort -n); do 
#            delete-k3d-cluster $(cat $i | yq .name) ${i}
#      done      
#      fi 
#}


install_argo()
{
   check_env
   echo "Deploying argo..."
   cd $SCRIPT_DIR/bootstrap-argocd

   $SCRIPT_DIR/bootstrap-argocd/install-argocd.sh insecure-rootpath ${cluster_context}

   $SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}
   cd $env

}


parse_opt()
{

# Get the options
 while getopts "f:hi-:" option; do
    case $option in
      f) # env
         env=${OPTARG};;
      i) # infra
         install_k3d=true;;
      h) # display Help
         help
         exit;;
      -) # long options
         case "${OPTARG}" in
           colima) # --colima logic
             install_colima=true;;
           skip-argo) # --skip-argo logic
             install_argo=false;;
           *) # handle other long options
             echo "Invalid option: --${OPTARG}"
             help
             exit;;
         esac;;
      \?) # Invalid option
         echo "Error: Invalid option"
         help
         exit;;
    esac
  done

}

deploy()
{

############################################################
parse_opt $@
pre_install

if [[ ${install_k3d} == true ]]
then
   install_k3d
fi 

if [[ ${install_argo} == true ]]
then
   install_argo
fi 

cd $env
git_root="$(git rev-parse --show-toplevel)/"
export env_path=$(echo $PWD | sed -e "s+$git_root++g")


### If the cluster_context is not specified, simply use the default context.
if [[ ${cluster_context} == "" ]]
then
  export cluster_context=`kubectl config current-context`
  if [[ ${cluster_context} == "" ]]
  then
    echo "You do not have a curent kubernetes cluster.  Please create one."
    exit 1
  fi
  echo "No context specified. Using default context of ${cluster_context}"
fi

# Read catalog.yaml
catalog_content=$(cat catalog.yaml)

waves_count=$(echo "$catalog_content" | yq ".waves | length")

# Function to execute pre/post deploy scripts
execute_scripts() {
  local script_type=$1
  local count=$2

  for ((s = 0; s < $count; s++)); do
    script_location=$(echo "$catalog_content" | yq ".waves[$c].scripts.$script_type[$s]")
    normalized_script_location=$(eval echo $script_location)

    [[ -f "${git_root}${normalized_script_location}" ]] && ${git_root}/${normalized_script_location}
  done
}

for ((c = 0; c < $waves_count; c++)); do
  wave_name=$(echo "$catalog_content" | yq -r ".waves[$c].name")
  wave_name="${wave_name:-$c}"

  wave_location=$(echo "$catalog_content" | yq -r ".waves[$c].location")
  normalized_wave_location=$(eval echo $wave_location)

  # Start wave
  echo "Starting $wave_name"

  # Execute pre deploy scripts
  pre_script_count=$(echo "$catalog_content" | yq ".waves[$c].scripts.pre_deploy | length")
  execute_scripts pre_deploy $pre_script_count

  # Deploy aoa wave application
  $SCRIPT_DIR/tools/configure-wave.sh ${normalized_wave_location} ${wave_name} ${cluster_context} ${github_username} ${repo_name} ${target_branch} ${parent_app_sync}

  # Execute post deploy scripts
  post_script_count=$(echo "$catalog_content" | yq ".waves[$c].scripts.post_deploy | length")
  execute_scripts post_deploy $post_script_count
done

echo "END."
}

destroy()
{
   parse_opt $@
   check_env
  
   echo "------------------------------------------------------------"
   echo "--------------   AoA Installer - Env Destroy   -------------"
   echo "The following environemnt will be destroyed: $env"

   echo "Continue? [y/N]"

   read should_continue
   if [[ ${should_continue} =~ ^([yY])$ ]]
   then
      echo ""
   else
      exit 0
   fi

   destroy_infra
}

######################## Main ##############################

case $1 in
deploy)
    deploy "${@:2}"
    ;;

destroy)
    destroy "${@:2}"
    ;;

*)
    help
    ;;
esac
