#!/bin/sh 

# Prerequisites
# add git.example.com gloo.example.com backstage.example.com 127.0.0.1 to your /etc/hosts 

# ENV needed 
export GLOO_VERSION=2.4.0
export MGMT=mgmt
export LICENSE_KEY=$GLOO_MESH_LICENSE_KEY


INSTALL_ROOT_DIR=$PWD
helm repo add gloo-platform https://storage.googleapis.com/gloo-platform/helm-charts
helm repo update

# Gloo Mesh 
helm install gloo-platform-crds gloo-platform/gloo-platform-crds --kube-context $MGMT \
   --namespace=gloo-mesh \
   --create-namespace \
   --version $GLOO_VERSION

helm install gloo-platform gloo-platform/gloo-platform --kube-context $MGMT \
   --namespace gloo-mesh \
   --version $GLOO_VERSION \
   --values ./gloo/mgmt.yaml \
   --set licensing.glooGatewayLicenseKey=$LICENSE_KEY


# Waiting for Istio to be ready 
echo "waiting for Istio pods"
while [[ $(kubectl get pods -A -l app=istio-ingressgateway -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo  "" && sleep 10; done
echo "Istio Ready"


# Gitlab 
kubectl apply -f $INSTALL_ROOT_DIR/gitlab/gitlab.yaml 
kubectl apply -f $INSTALL_ROOT_DIR/gitlab/istio.yaml 

# Wait for gitlab to be ready 
echo "waiting for git.example.com to be ready " 
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://git.example.com/users/sign_in)" != "200" ]]; do sleep 5 ; echo -n "." ; done'
echo "Gitlab Ready"


# Creating gitlab Token 
cd ./gitlab 
./create_token.sh
./create_runner.sh 

# Intial project 
curl --request POST --header "PRIVATE-TOKEN: solo-token-123" \
     --header "Content-Type: application/json" --data '{
        "name": "infra", "description": "infra", "visibility": "public", "initialize_with_readme": "true"}' \
     --url "http://git.example.com/api/v4/projects/"

# Backstage 
cd $INSTALL_ROOT_DIR/backstage 
yarn install 
yarn dev
cd $INSTALL_ROOT_DIR
