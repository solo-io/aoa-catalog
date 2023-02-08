#!/bin/bash
#set -e

############################################################
# Defaults
install_infra=false
export SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
environment_overlay="base"


#Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

############################################################

############################################################
# Help                                                     #
############################################################
help()
{
   # Display Help
   echo "AoA installer."
   echo
   echo "Syntax: installer [-f|-o|-i|-h]"
   echo "options:"
   echo "-f     path to AoA files"
   echo "-o     overlay"   
   echo "-i     install infra"
   echo "-h     print help"
   echo
}

pre_install()
{

check_env
source_env_vars

echo "------------------------------------------------------------"
echo "--------------   AoA Installer - Pre-install   -------------"
echo "Environemnt: $env"
echo "Install infra: $install_infra"
echo "Overlay: $environment_overlay"
check_git
echo ""
echo "Github Account: $github_username"
echo "Repo: $repo_name"
echo "Branch: $target_branch"
echo "------------------------------------------------------------"

echo "Continue? [y/N]"

read should_continue
if [[ ${should_continue} =~ ^([yY])$ ]]
  then
   echo ""
  else
   exit 0
fi
   
}

check_env()
{
  if [[ ${env} == "" ]] || [ ! -d "$env" ]
  then
    # provide vars file
    printf "${RED}Error: env folder not found, please use -f to choose a valid env folder.${NO_COLOR}\n"
    help
    exit 1
   fi

   #normalize path 
   cd $env
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
      printf "${YELLOW}Git remote branch!${NO_COLOR}"
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

# check to see if environment overlay variable was passed through, if not prompt for it
if [[ ${environment_overlay} == "" ]]
  then
    # provide environment overlay
    echo "Please provide the environment overlay to use (i.e. prod, dev):"
    read environment_overlay
fi

}

install_infra()
{
   check_env
   echo "Deploying infra..."
   source $SCRIPT_DIR/tools/k3d-install.sh

   if [ -d "$env/.infra" ]
   then
      cd $env/.infra
      for i in $(ls | sort -n); do 
            create-k3d-cluster $(cat $i | yq .name) ${i}
      done      
      fi 
}

############################################################
# Get the options
while getopts "f:o:hi" option; do
   case $option in
      h) # display Help
         help
         exit;;
      f) # env
         env=${OPTARG};;
      i) # infra
         install_infra=true;;
      o) # overlay
         environment_overlay=${OPTARG};;
     \?) # Invalid option
         echo "Error: Invalid option"
         help
         exit;;
   esac
done

pre_install

if [[ ${install_infra} == true ]]
then
   install_infra
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

# install argocd
#TODO: refactor the install-argocd.sh to no relay on cd
cd $SCRIPT_DIR/bootstrap-argocd
if [ "${environment_overlay}" == "ocp" ] ; then 
     $SCRIPT_DIR/bootstrap-argocd/install-argocd.sh insecure-rootpath-ocp ${cluster_context}
  else
     $SCRIPT_DIR/bootstrap-argocd/install-argocd.sh insecure-rootpath ${cluster_context}
  fi

# wait for argo cluster rollout
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}

cd $env
# deploy app of app waves
for i in $(ls | sort -n); do 
  if [[ ${i:0:1}  == "." ]] || [[ ${i} == "vars.env" ]] || [[ ${i} == "README.md" ]]
  then
      continue
  fi 

  echo "starting ${i}"
  # run init script if it exists
  [[ -f "${i}/init.sh" ]] && ${i}/init.sh 
  # deploy aoa wave
  $SCRIPT_DIR/tools/configure-wave.sh ${env_path} ${i} ${environment_overlay} ${cluster_context} ${github_username} ${repo_name} ${target_branch}
  # run test script if it exists
  [[ -f "${i}/test.sh" ]] && ${i}/test.sh
done

echo "END."

