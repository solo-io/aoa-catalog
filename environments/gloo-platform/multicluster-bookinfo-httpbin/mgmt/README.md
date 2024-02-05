# Environment Description
The `gloo-platform/multicluster-bookinfo-httpbin/mgmt` environment deploys the mgmt cluster control plane for a multi-cluster Gloo Platform demo, with Istio exposing admin applications on the cluster. This environment can be used in conjunction with `gloo-platform/multicluster-bookinfo-httpbin/cluster1` and `gloo-platform/multicluster-bookinfo-httpbin/cluster2` to demonstrate cluster onboarding, secure cross-cluster communication, failover, and other mesh-focused use cases

### What this deploys
When applied alone, the control plane is deployed and configured with the `ops-team`, `httpbin`, and `bookinfo` workspaces, no workload applications are deployed on the `mgmt` cluster itself. Applications are deployed and onboarded to the multi-cluster mesh when workload clusters `cluster1` and `cluster2` are deployed.

### Multi-Cluster Architecture Diagram
When applied with `cluster1` and `cluster2` environments, here is a high level diagram of the architecture

![High Level Architecture](../.images/gloo-platform-multicluster-bookinfo-httpbin-full-arch-1a.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.28

## Environment description
- base:
    - gloo mesh 2.5.0
    - istio 1.20.2-solo (Helm)
    - revision: 1-20
- ilcm:
    - gloo mesh 2.5.0
    - istio 1.20.2-solo (ILCM)
    - revision: 1-20

## Application description

The RouteTables for applications exposed in this demo are defining non-wildcard hosts which follow the pattern `<app>.glootest.com`. You can map these hostnames to your gateway IP address in your DNS service of choice (i.e. Route53, Cloudflare), or you can follow the methods below to modify your `/etc/hosts` locally depending on your cluster LoadBalancer configuration.

On the `mgmt` cluster gateway:
- Homer Link Dashboard at `https://localhost` or `https://<LB Address>`
- Grafana at `https://grafana.glootest.com`
- ArgoCD at `https://argocd.glootest.com/argo`
    - argocd credentials:
    - user: admin
    - password: solo.io
- Gloo Mesh UI at `https://gmui.glootest.com`

On the `cluster1` cluster gateway (at 8443 if using k3d LB integration) When deployed with `cluster1`
- httpbin at `https://httpbin.glootest.com:8443/get`
    - application lives on `cluster1` and `cluster2` and is exposed by the gateway on `cluster1`
- bookinfo at `https://bookinfo.glootest.com:8443/productpage`
    - application lives on `cluster1` and `cluster2` and is exposed by the gateway on `cluster1`

On the `cluster2` cluster gateway (at 8444 if using k3d LB integration) When deployed with `cluster2`
- httpbin at `https://httpbin.glootest.com:8444/get`
    - application lives on `cluster1` and `cluster2` and is exposed by the gateway on `cluster1`
- bookinfo at `https://bookinfo.glootest.com:8444/productpage`
    - application lives on `cluster1` and `cluster2` and is exposed by the gateway on `cluster1`

To access applications, follow the methods below:

#### Method 1 - LoadBalancer External-IP

Discover your gateway IP address
```
ISTIO_REVISION=1-20
GATEWAY_IP=$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].*}')

echo ${GATEWAY_IP}
```

Modify /etc/hosts on your local machine (this will require sudo privileges), or configure DNS to point to your Ingress Gateway IP
```
cat <<EOF | sudo tee -a /etc/hosts
${GATEWAY_IP} argocd.glootest.com gmui.glootest.com grafana.glootest.com httpbin.glootest.com bookinfo.glootest.com
EOF
```

#### Method 2 - K3d LB Integration
modify /etc/hosts on your local machine (this will require sudo privileges)
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd.glootest.com gmui.glootest.com grafana.glootest.com httpbin.glootest.com bookinfo.glootest.com
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
ISTIO_REVISION=1-20
kubectl port-forward -n istio-gateways svc/istio-ingressgateway-${ISTIO_REVISION} 8443:443 --context <cluster_name>
```
access the ingress gateway at https://localhost:8443


Note: For routes that are configured with a specific host, pass in the Host header using curl `-H "Host: <host>` or add the following entry into your /etc/hosts when using this method
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd.glootest.com gmui.glootest.com grafana.glootest.com httpbin.glootest.com bookinfo.glootest.com
EOF
```