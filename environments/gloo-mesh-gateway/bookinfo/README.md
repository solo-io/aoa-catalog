# Environment Description
The `gloo-gateway/backstage-bookinfo-httpbin` environment deploys the core components of a single cluster Gloo Platform demo, with the bookinfo deployed and exposed by Gloo Gateway

![High Level Architecture](.images/bookinfo-arch-1a.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment descriptions
- base:
    - gloo mesh 2.6.9
    - istio 1.24.2-solo (Helm)
    - revision: main