#!/bin/bash

# wait for istio-eastwest ztunnel to be created successfully
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwest istio-gateways 10 ${cluster_context}

# configure peering link
until [ "${SVC}" != "" ]; do
  SVC=$(kubectl --context ${peering_context} -n istio-gateways get svc --selector=gateway.networking.k8s.io/gateway-name=istio-eastwest -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')
  echo waiting for istio east-west LoadBalancer IP to be detected on the peering cluster
  echo LoadBalancer IP found: $SVC
  sleep 2
done

kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  annotations:
    gateway.istio.io/service-account: istio-eastwest
    gateway.istio.io/trust-domain: ${peering_context}
  labels:
    topology.istio.io/network: ${peering_context}
  name: istio-remote-peer-${peering_context}
  namespace: istio-system
spec:
  addresses:
  - type: IPAddress
    value: ${SVC}
  gatewayClassName: istio-remote
  listeners:
  - name: cross-network
    port: 15008
    protocol: HBONE
    tls:
      mode: Passthrough
  - name: xds-tls
    port: 15012
    protocol: TLS
    tls:
      mode: Passthrough
EOF