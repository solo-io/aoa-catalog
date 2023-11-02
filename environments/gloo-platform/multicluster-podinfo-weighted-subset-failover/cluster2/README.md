# Environment Description
The `gloo-platform/multicluster-podinfo-weighted-subset-failover/cluster2` environment deploys the `cluster2` worker for a multi-cluster Gloo Platform demo, which deploys Istio with ingress gateways, Bookinfo, httpbin, and configures the Gloo Mesh Agent to communicate with the Gloo Mesh Control Plane served by the `multicluster-podinfo-weighted-subset-failover/mgmt` environment

![High Level Architecture](../.images/gloo-platform-multicluster-podinfo-weighted-subset-failover-full-arch-1a.png)