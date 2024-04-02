# Environment Description
The `gloo-mesh-core/additional-cluster-2` environment bootstraps an additional workload cluster to the Gloo Mesh control plane configured in the `gloo-mesh-core/singlecluster` environment.

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28
- `gloo-mesh-core/singlecluster` already configured with the context name `mgmt`

## Environment descriptions
- base:
    - gloo mesh 2.5.5
    - istio 1.20.4-solo (Helm)
    - revision: 1-20
- lifecyclemanager:
    - gloo mesh 2.5.5
    - istio 1.20.4-solo (ILM)
    - revision: 1-20