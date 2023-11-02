# Environment Description
The `gloo-edge/argo-rollouts/rollouts-demo` environment deploys Gloo Edge along with the Argo Rollouts controller and an example rollout demo

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.25

## Overlay description
- base:
    - Gloo Edge Enterprise 1.15.6