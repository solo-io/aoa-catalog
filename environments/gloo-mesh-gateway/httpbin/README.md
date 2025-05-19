# Environment Description
The `gloo-gateway/httpbin` environment deploys the core components of a single cluster Gloo Platform demo, with httpbin deployed and exposed by Gloo Gateway

![High Level Architecture](.images/httpbin-arch-1a.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment descriptions
- base:
    - gloo mesh 2.7.3
    - istio 1.25.0-solo (Helm)
    - revision: main