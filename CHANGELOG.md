Notable changes:

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