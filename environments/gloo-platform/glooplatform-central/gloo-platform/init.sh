#!/bin/bash

echo "wave description:"
echo "deploy and register gloo-mesh agent and addons"

# check to see if gloo_mesh_version variable was passed through, if not prompt for it
if [[ ${gloo_mesh_version} == "" ]]
  then
    # provide gloo_mesh_version variable
    echo "Please provide the gloo_mesh_version to use (i.e. 2.5.3):"
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
            deploymentOverrides:
                spec:
                    template:
                        metadata:
                            annotations:
                                prometheus.io/port: '9091'
                  
    repoURL: https://storage.googleapis.com/gloo-platform/helm-charts
    targetRevision: 2.5.3
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
            #replicaCount: 1
            #mode: deployment
            mode: daemonset
            service: 
              type: ClusterIP
            podLabels:
              istio.io/rev: 1-19
            podAnnotations:
              proxy.istio.io/config: '{ "holdApplicationUntilProxyStarts": true }'
            image:
              pullPolicy: IfNotPresent
              repository: gcr.io/gloo-mesh/gloo-otel-collector
              tag: 2.5.3
            config:
                exporters:
                    otlp:
                        endpoint: "${METRICS}:4317"
            resources:
                limits:
                    cpu: 1
                    memory: 2Gi
                requests:
                    cpu: 128m
                    memory: 768Mi
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
        #telemetryCollectorCustomization:
        #    extraProcessors:
        #      batch/istiod:
        #        send_batch_size: 10000
        #        timeout: 10s
        #      filter/istiod:
        #        metrics:
        #          include:
        #            match_type: regexp
        #            metric_names:
        #              - "pilot.*"
        #              - "process.*"
        #              - "go.*"
        #              - "container.*"
        #              - "envoy.*"
        #              - "galley.*"
        #              - "sidecar.*"
        #              - "istio_build.*"
        #              - ".*proxy_latency.*"
        #    extraPipelines:
        #      metrics/istiod:
        #        receivers:
        #        - prometheus
        #        processors:
        #        - memory_limiter
        #        - batch/istiod
        #        - filter/istiod
        #        exporters:
        #        - otlp
                  
    repoURL: https://storage.googleapis.com/gloo-platform/helm-charts
    targetRevision: 2.5.3
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  # ignore the self-signed certs that are being generated automatically    
  ignoreDifferences:
  - group: v1
    kind: Secret
EOF