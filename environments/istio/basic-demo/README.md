# Environment Description
The `istio/basic-demo` environment deploys cert-manager, Istio (with revisions), Istio sample add-ons, httpbin, and the homer link dashboard.

![High Level Architecture](.images/istio-basic-demo.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-2` (gke), `m5.large` (aws) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.25

## Environment description
- base:
    - istio 1.16.2-solo (Helm)
    - revision: 1-16

## Application description

The RouteTables for applications exposed in this demo are defining non-wildcard hosts which follow the pattern `<app>-local.glootest.com`. You can map these hostnames to your gateway IP address in your DNS service of choice (i.e. Route53, Cloudflare), or you can follow the methods below to modify your `/etc/hosts` locally depending on your cluster LoadBalancer configuration.

Applications Exposed using this demo:
- Homer Dashboard at `https://<GATEWAY_IP>.com` or `https://localhost` if using K3d LB integration
- ArgoCD at `https://argocd-local.glootest.com/argo`
    - argocd credentials:
    - user: admin
    - password: solo.io
- Grafana at `https://grafana-local.glootest.com/grafana`
- Kiali at `https://kiali-local.glootest.com`
- Prometheus at `https://prometheus-local.glootest.com`
- httpbin at `https://httpbin-local.glootest.com`

To access applications, follow the methods below:

#### Method 1 - LoadBalancer External-IP

Discover your gateway IP address
```
ISTIO_REVISION=1-16
GATEWAY_IP=$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo ${GATEWAY_IP}
```

Modify /etc/hosts on your local machine (this will require sudo privileges), or configure DNS to point to your Ingress Gateway IP
```
cat <<EOF | sudo tee -a /etc/hosts
${GATEWAY_IP} argocd-local.glootest.com grafana-local.glootest.com kiali-local.glootest.com prometheus-local.glootest.com httpbin-local.glootest.com
EOF
```

#### Method 2 - K3d LB Integration
modify /etc/hosts on your local machine (this will require sudo privileges)
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd-local.glootest.com grafana-local.glootest.com kiali-local.glootest.com prometheus-local.glootest.com httpbin-local.glootest.com
EOF
```

#### Method 3: use port-forwarding

To access argocd using port-forward command:
```
kubectl port-forward svc/argocd-server -n argocd 9999:443 --context <cluster_name>
```
access argocd at https://localhost:9999/argo



To access gloo mesh ui using port-forward command:
```
kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context <cluster_name>
```
access gloo mesh ui at https://localhost:8090"



To access Istio Ingress Gateway using port-forward command:
```
ISTIO_REVISION=1-16
kubectl port-forward -n istio-gateways svc/istio-ingressgateway-${ISTIO_REVISION} 8443:443 --context <cluster_name>
```
access the ingress gateway at https://localhost:8443


Note: For routes that are configured with a specific host, pass in the Host header using curl `-H "Host: <host>` or add the following entry into your /etc/hosts when using this method
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd-local.glootest.com grafana-local.glootest.com kiali-local.glootest.com prometheus-local.glootest.com httpbin-local.glootest.com
EOF
```