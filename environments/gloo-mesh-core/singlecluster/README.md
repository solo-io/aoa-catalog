# Environment Description
The `gloo-mesh-core/singlecluster` environment deploys the core components of a single cluster Gloo Mesh Core demo, with the online-boutique demo application deployed.

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment descriptions
- base:
    - gloo mesh 2.5.0
    - istio 1.20.2-solo (Helm)
    - revision: 1-20
- lifecyclemanager:
    - gloo mesh 2.5.0
    - istio 1.20.2-solo (ILM)
    - revision: 1-20