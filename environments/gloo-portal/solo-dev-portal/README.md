# Environment Description
The `gloo-portal/solo-dev-portal` environment deploys a Gloo Edge, Gloo Portal, and a Solo.io branded Portal displaying the httpbin and petstore applications along with configured Portal OIDC authentication, pre-configured user(s), and Try It Now! capabilities with Usage Plans

![High Level Architecture](.images/gloo-edge-solo-dev-portal-arch-1a.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23 and 1.24

- Wave 1 - Deploy and Configure Gloo Edge Enterprise
- Wave 2 - Deploys Gloo Portal
- Wave 3 - Deploys Portal Applications
    - httpbin
    - petstore-dev
    - petstore-prod
- Wave 3 - Configures Solo Dev Portal CRDs

## Overlay description
- base:
    - Gloo Edge Enterprise 1.12.14
    - Gloo Portal 1.2.9

## Application description

The RouteTables for applications exposed in this demo are defining non-wildcard hosts which follow the pattern `<app>-local.glootest.com`. You can map these hostnames to your gateway IP address in your DNS service of choice (i.e. Route53, Cloudflare), or you can follow the methods below to modify your `/etc/hosts` locally depending on your cluster LoadBalancer configuration.

Applications Exposed using this demo:
- ArgoCD at `https://argocd-local.glootest.com/argo`
    - argocd credentials:
    - user: admin
    - password: solo.io
- Solo Dev Portal at `https://portal-local.glootest.com/get`

To access applications, follow the methods below:

#### Method 1 - LoadBalancer External-IP

Discover your gateway IP address
```
GATEWAY_IP=$(kubectl -n gloo-system get service gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo ${GATEWAY_IP}
```

Modify /etc/hosts on your local machine (this will require sudo privileges), or configure DNS to point to your Gateway IP
```
cat <<EOF | sudo tee -a /etc/hosts
${GATEWAY_IP} argocd-local.glootest.com api-local.glootest.com apidev-local.glootest.com portal-local.glootest.com
EOF
```

#### Method 2 - K3d LB Integration
modify /etc/hosts on your local machine (this will require sudo privileges)
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd-local.glootest.com api-local.glootest.com apidev-local.glootest.com portal-local.glootest.com
EOF
```

#### Method 3: use port-forwarding

access argocd directly using port-forward command:
```
kubectl port-forward svc/argocd-server -n argocd 9999:443
```
access argocd at https://localhost:9999/argo




To access the gateway using port-forward command:
```
kubectl port-forward -n gloo-system svc/gateway-proxy 8443:443 --context <cluster_name>
```
access the gateway at https://localhost:8443


Note: For routes that are configured with a specific host, pass in the Host header using curl `-H "Host: <host>` or add the following entry into your /etc/hosts when using this method
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd-local.glootest.com api-local.glootest.com apidev-local.glootest.com portal-local.glootest.com
EOF
```