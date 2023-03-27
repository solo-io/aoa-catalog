#!/bin/bash

echo "wave description:"
echo "deploy and register gloo-mesh agent and addons"

# check to see if gloo_mesh_version variable was passed through, if not prompt for it
if [[ ${gloo_mesh_version} == "" ]]
  then
    # provide gloo_mesh_version variable
    echo "Please provide the gloo_mesh_version to use (i.e. 2.2.6):"
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
  METRICS=$(kubectl --context ${mgmt_context} -n gloo-mesh get svc gloo-metrics-gateway -o jsonpath='{.status.loadBalancer.ingress[0].*}')
  echo waiting for gloo mesh metrics gateway LoadBalancer IP to be detected
  sleep 2
done

kubectl apply --context ${mgmt_context} -f- <<EOF
apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: cluster1
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
  name: gm-enterprise-agent-cluster1
  namespace: argocd
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-mesh
  source:
    repoURL: 'https://storage.googleapis.com/gloo-mesh-enterprise/gloo-mesh-agent'
    targetRevision: ${gloo_mesh_version}
    chart: gloo-mesh-agent
    helm:
      valueFiles:
        - values.yaml
      parameters:
        - name: cluster
          value: 'cluster1'
        - name: relay.serverAddress
          value: '${SVC}:9900'
        - name: relay.authority
          value: 'gloo-mesh-mgmt-server.gloo-mesh'
        - name: relay.clientTlsSecret.name
          value: 'gloo-agent-tls-cert'
        - name: relay.clientTlsSecret.namespace
          value: 'gloo-mesh'
        - name: rate-limiter.enabled
          value: 'false'
        - name: ext-auth-service.enabled
          value: 'false'
        # enabled for future vault integration
        - name: istiodSidecar.createRoleBinding
          value: 'true'
        # legacy metrics pipeline
        - name: legacyMetricsPipeline.enabled
          value: 'false'  
        # otel
        - name: metricscollector.enabled
          value: 'true'
        - name: metricscollectorCustomization.disableCertGeneration
          value: 'true'
        - name: metricscollector.config.exporters.otlp.endpoint
          value: '${METRICS}:4317'
        - name: 'metricscollector.extraVolumes[0].name'
          value: 'root-ca'
        - name: 'metricscollector.extraVolumes[0].secret.defaultMode'
          value: '420'
        - name: 'metricscollector.extraVolumes[0].secret.secretName'
          value: 'gloo-metrics-gateway-tls-secret'
        - name: 'metricscollector.extraVolumes[1].configMap.items[0].key'
          value: 'relay'
        - name: 'metricscollector.extraVolumes[1].configMap.items[0].path'
          value: 'relay.yaml'
        - name: 'metricscollector.extraVolumes[1].configMap.name'
          value: 'gloo-metrics-collector-config'
        - name: 'metricscollector.extraVolumes[1].name'
          value: 'metrics-configmap'
        # set requests/limits    
        #- name: metricscollector.resources.requests.cpu
        #  value: '500m'   
        #- name: metricscollector.resources.requests.memory
        #  value: '"1Gi"'   
        #- name: metricscollector.resources.limits.cpu
        #  value: '2'   
        #  - name: metricscollector.resources.limits.memory
        #  value: '2Gi'        
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
    syncOptions:
    - Replace=true
    - ApplyOutOfSyncOnly=true
  project: default
EOF