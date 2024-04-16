#!/bin/bash

echo "wave description:"
echo "deploy and register gloo-mesh agent and addons"

# check to see if gloo_mesh_version variable was passed through, if not prompt for it
if [[ ${gloo_mesh_version} == "" ]]
  then
    # provide gloo_mesh_version variable
    echo "Please provide the gloo_mesh_version to use (i.e. TARGET_REVISION):"
    read gloo_mesh_version
fi

# discover gloo mesh endpoint with kubectl
until [ "${SVC}" != "" ]; do
  SVC=$(kubectl --context ${mgmt_context} -n gloo-mesh get svc gloo-mesh-mgmt-server -o jsonpath='{.status.loadBalancer.ingress[0].*}')
  echo waiting for gloo mesh management server LoadBalancer IP to be detected
  sleep 2
done

# discover gloo mesh metrics endpoint with kubectl
until [ "${METRICS}" != "" ]; do
  METRICS=$(kubectl --context ${mgmt_context} -n gloo-mesh get svc gloo-telemetry-gateway -o jsonpath='{.status.loadBalancer.ingress[0].*}')
  echo waiting for gloo mesh metrics gateway LoadBalancer IP to be detected
  sleep 2
done

kubectl apply --context ${mgmt_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: ${cluster_context}
  namespace: gloo-mesh
  labels:
    roottrust: shared
spec:
  clusterDomain: cluster.local
EOF

# register clusters to gloo mesh with helm
kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gloo-platform-helm
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-mesh
  project: default
  source:
    chart: gloo-platform
    helm:
      skipCrds: true
      values: |
        common:
            addonNamespace: "gloo-mesh-addons"
            adminNamespace: "gloo-mesh"
            cluster: ${cluster_context}
        global: {}
        glooAgent:
            enabled: true
            relay:
                serverAddress: "${SVC}:9900"
                clientTlsSecret:
                    name: gloo-agent-tls-cert
                    namespace: gloo-mesh
                # required to set to null in 2.4.x if providing server and client tls certificates
                tokenSecret:
                  key: null
                  name: null
                  namespace: null
                  
    repoURL: HELM_REPO
    targetRevision: TARGET_REVISION
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  # ignore the self-signed certs that are being generated automatically    
  ignoreDifferences:
  - group: v1
    kind: Secret
EOF

# deploy otel collector
kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gloo-platform-otel-collector
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-mesh
  project: default
  source:
    chart: gloo-platform
    helm:
      skipCrds: true
      values: |
        common:
            addonNamespace: "gloo-mesh-addons"
            adminNamespace: "gloo-mesh"
            cluster: ${cluster_context}
        telemetryCollector:
            enabled: true
            # uncomment to use deployment mode instead of daemonset
            #replicaCount: 1
            #mode: deployment
            #service: 
            #  type: ClusterIP
            #podLabels:
            #  istio.io/rev: 1-20
            #podAnnotations:
            #  proxy.istio.io/config: '{ "holdApplicationUntilProxyStarts": true }'
            image:
              pullPolicy: IfNotPresent
              repository: DOCKER_REPO/gloo-otel-collector
              tag: TARGET_REVISION
            config:
                exporters:
                    otlp:
                        endpoint: "${METRICS}:4317"
            extraVolumes:
                - name: root-ca
                  secret:
                    defaultMode: 420
                    secretName: gloo-telemetry-gateway-tls-secret
                - configMap:
                    items:
                        - key: relay
                          path: relay.yaml
                    name: gloo-telemetry-collector-config
                  name: telemetry-configmap
                - hostPath:
                      path: /var/run/cilium
                      type: DirectoryOrCreate
                  name: cilium-run
                  
    repoURL: HELM_REPO
    targetRevision: TARGET_REVISION
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  # ignore the self-signed certs that are being generated automatically    
  ignoreDifferences:
  - group: v1
    kind: Secret
EOF