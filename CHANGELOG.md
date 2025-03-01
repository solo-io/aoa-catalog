Notable changes:

(9-24-24)
---
Update environment to
Gloo Platform v2.6.0
  - set `glooInsightsEngine.enabled: true` in helm values
  - configure gloo analyzer in helm values
Istio
- update version from 1.22.0-solo to 1.23.0-solo
- update revision label from 1-22 to 1-23

Environment Changes:
- update k3d config examples in .infra to `rancher/k3s:v1.28.7-k3s1` and fix naming
- Deprecate portal-demo and cleanup homer portal links
- Deprecate clickhouse and related otel collector extensions 
- Deprecate mesh-factory-app and mesh-factory-config
- Deprecate gitlab-app
- Deprecate ai-gateway-config from gloo-platform/mgmt
- Deprecate openai-app from gloo-platform/glooplatform-central
- Deprecate public-ui route for Gloo Mesh UI since it is always public now
- Deprecate extauthpolicies for Gloo Mesh UI since it is always public now
- Deprecate Mario demo
- Deprecate Descheduler
- Rename gloo-edge to gloo-gateway
- add gateway-api/portal-only environment

GKE 1.29.1-gke.1589020
ArgoCD 2.10.10

(5-29-24)
---
Update environment to
Gloo Platform v2.5.7
- `telemetryCollectorCustomization.pipelines.logs/istio_access_logs` is now `logs/portal`
Istio
- update version from 1.20.4-solo to 1.22.0-solo
- update revision label from 1-20 to 1-22
- update `istio-base` and `istiod` chart ignoreDifferences with the following
```bash
ignoreDifferences:     
  - group: admissionregistration.k8s.io                                                              
    kind: ValidatingWebhookConfiguration
    jsonPointers:                                                                                    
    - /webhooks/0/failurePolicy
```
GKE 1.29.1-gke.1589020
ArgoCD 2.10.10

(1-31-24)
---
Update environment to
Gloo Platform v2.4.7
Istio 1.20.2-solo
GKE 1.28.3-gke.1118000