# Environment Description
The `istio/basic-demo` environment deploys cert-manager, Istio (with revisions), Istio sample add-ons, httpbin, and the homer link dashboard.

![High Level Architecture](.images/istio-basic-demo.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-2` (gke), `m5.large` (aws) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment description
- base:
    - istio 1.22.3 (Helm)
    - revision: 1-22

## Application description

The RouteTables for applications exposed in this demo are defining wildcard hosts. When used with K3d integration, the applications will be exposed at `localhost:80` and `localhost:443`

Applications Exposed using this demo:
- Homer Dashboard at `https://<GATEWAY_IP>.com` or `https://localhost` if using K3d LB integration
- ArgoCD at `https://localhost/argo`
    - argocd credentials:
    - user: admin
    - password: solo.io
- Grafana at `https://localhost/grafana`
- Kiali at `https://localhost/kiali`
- Prometheus at `https://localhost/prometheus`
- Jaeger at `https://localhost/jaeger`
- httpbin at `https://localhost`