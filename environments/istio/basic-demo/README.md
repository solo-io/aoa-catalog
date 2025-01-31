# Environment Description
The `istio/basic-demo` environment deploys cert-manager, Istio (with revisions), Istio sample add-ons, httpbin, and the homer link dashboard.

![High Level Architecture](.images/istio-basic-demo.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-2` (gke), `m5.large` (aws) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment description
- base:
    - istio 1.24.2 (Helm)
    - revision: main