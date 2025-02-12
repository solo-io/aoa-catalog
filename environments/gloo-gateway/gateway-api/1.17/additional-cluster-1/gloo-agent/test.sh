#!/bin/bash

# check to see if gloo_mesh_version variable was passed through, if not prompt for it
if [[ ${gloo_mesh_version} == "" ]]
  then
    # provide gloo_mesh_version variable
    echo "Please provide the gloo_mesh_version to use (i.e. v2.8.0-beta0-2025-02-11-main-4392e21f7c):"
    read gloo_mesh_version
fi

# discover gloo mesh endpoint with kubectl
until [ "${SVC}" != "" ]; do
  SVC=$(kubectl --context ${mgmt_context} -n gloo-system get svc gloo-mesh-mgmt-server -o jsonpath='{.status.loadBalancer.ingress[0].*}' | sed 's/ VIP//g' | sed 's/VIP //g')
  echo waiting for gloo mesh management server LoadBalancer IP to be detected
  sleep 2
done

# discover gloo mesh metrics endpoint with kubectl
until [ "${METRICS}" != "" ]; do
  METRICS=$(kubectl --context ${mgmt_context} -n gloo-system get svc gloo-telemetry-gateway -o jsonpath='{.status.loadBalancer.ingress[0].*}' | sed 's/ VIP//g' | sed 's/VIP //g')
  echo waiting for gloo mesh metrics gateway LoadBalancer IP to be detected
  sleep 2
done

kubectl apply --context ${mgmt_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: ${cluster_context}
  namespace: gloo-system
  labels:
    roottrust: shared
spec:
  clusterDomain: cluster.local
EOF

# create agent issuer and agent cert
kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: relay-root-ca
  namespace: gloo-system
spec:
  ca:
    secretName: relay-root-ca
---
kind: Certificate
apiVersion: cert-manager.io/v1
metadata:
  name: gloo-agent
  namespace: gloo-system
spec:
  commonName: gloo-agent
  dnsNames:
    # Must match the cluster name used in the helm chart install
    - "${cluster_context}"
  # 1 year life
  duration: 8760h0m0s
  issuerRef:
    group: cert-manager.io
    kind: Issuer
    name: relay-root-ca
  renewBefore: 8736h0m0s
  secretName: gloo-agent-tls-cert
  usages:
    - digital signature
    - key encipherment
    - client auth
    - server auth
  privateKey:
    algorithm: "RSA"
    size: 4096
EOF

# register clusters to gloo mesh with helm
kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gloo-platform-helm
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io/solo-io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-system
  project: default
  source:
    chart: gloo-platform
    helm:
      skipCrds: true
      values: |
        common:
            adminNamespace: "gloo-system"
            cluster: ${cluster_context}
        global: {}
        glooAgent:
            enabled: true
            insecure: true
            relay:
                serverAddress: "${SVC}:9900"
        glooAnalyzer:
            enabled: true

    repoURL: https://storage.googleapis.com/gloo-platform-dev/platform-charts/helm-charts
    targetRevision: v2.8.0-beta0-2025-02-11-main-4392e21f7c
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
  - resources-finalizer.argocd.argoproj.io/solo-io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-system
  project: default
  source:
    chart: gloo-platform
    helm:
      skipCrds: true
      values: |
        common:
            adminNamespace: "gloo-system"
            cluster: ${cluster_context}
        telemetryCollector:
            enabled: true
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
        telemetryCollectorCustomization:
            skipVerify: true

    repoURL: https://storage.googleapis.com/gloo-platform-dev/platform-charts/helm-charts
    targetRevision: v2.8.0-beta0-2025-02-11-main-4392e21f7c
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  # ignore the self-signed certs that are being generated automatically
  ignoreDifferences:
  - group: v1
    kind: Secret
EOF

# wait for gloo mesh agent
$SCRIPT_DIR/tools/wait-for-rollout.sh deployment gloo-mesh-agent gloo-system 10 ${cluster_context}

