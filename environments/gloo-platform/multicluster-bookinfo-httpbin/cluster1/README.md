# Environment Description
The `gloo-platform/multicluster-bookinfo-httpbin/cluster1` environment deploys the `cluster1` worker for a multi-cluster Gloo Platform demo, which deploys Istio with ingress gateways, Bookinfo, httpbin, and configures the Gloo Mesh Agent to communicate with the Gloo Mesh Control Plane served by the `multicluster-bookinfo-httpbin/mgmt` environment

![High Level Architecture](../.images/gloo-platform-multicluster-bookinfo-httpbin-full-arch-1a.png)