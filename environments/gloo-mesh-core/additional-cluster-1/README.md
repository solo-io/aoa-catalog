# Environment Description
The `gloo-mesh-core/additional-cluster-1` environment bootstraps an additional workload cluster to the Gloo Mesh control plane configured in the `gloo-mesh-core/singlecluster` environment.

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28
- `gloo-mesh-core/singlecluster` already configured with the context name `mgmt`

## Environment descriptions
- base:
    - gloo mesh 2.7.0-beta1-2024-12-04-main-8c0e0d52b7
    - istio 1.22.3-patch1-solo (Helm)
    - revision: 1-22
- lifecyclemanager:
    - gloo mesh 2.7.0-beta1-2024-12-04-main-8c0e0d52b7
    - istio 1.22.3-patch1-solo (ILM)
    - revision: 1-22