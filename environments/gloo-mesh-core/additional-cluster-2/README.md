# Environment Description
The `gloo-mesh-core/additional-cluster-2` environment bootstraps an additional workload cluster to the Gloo Mesh control plane configured in the `gloo-mesh-core/singlecluster` environment.

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28
- `gloo-mesh-core/singlecluster` already configured with the context name `mgmt`

## Environment descriptions
- base:
    - gloo mesh v2.8.0-beta0-2025-01-28-main-e6540ca8d8
    - istio 1.22.3-patch1-solo (Helm)
    - revision: 1-22
- lifecyclemanager:
    - gloo mesh v2.8.0-beta0-2025-01-28-main-e6540ca8d8
    - istio 1.22.3-patch1-solo (ILM)
    - revision: 1-22