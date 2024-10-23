# Changelog

0.4.4 (8-8-24)
---
- update istio helm chart version to 1.22.3 across all environments
- update istio images to 1.22.3-patch1-solo across all environments

0.4.3 (7-30-24)
---
- update istio to 1.22.1-patch0-solo
- update gloo-edge/gateway-api istio environments to use 1.22.1-patch0-solo instead of upstream

0.4.2 (7-29-24)
---
- add gloo-edge/gateway-api/oss environment. uses gloo oss 1.18.0-beta9

0.4.1 (7-25-24)
---
- add argocd login details to homer dashboard
- update gloo-platform-helm chart across all environments to use 2.7.0-beta0-2024-10-16-puertomontt-gg-env-500a30fe59
- remove sidecar injection for Gloo Mesh UI in all environments
- Fixed issues with Gloo Mesh UI when using GG + GM in a single cluster setup in gloo-edge/gateway-api/with-gm-istio environment
- Fixed issues with Gloo Mesh UI when using GG + GM in a three cluster setup in gloo-platform/gwapi-mgmt-gm-workers environment

0.4.0 (7-16-24)
---
- Update gloo-edge/gateway-api environments to use official 1.17.0 release

0.3.18 (7-15-24)
---
- comment out ai gateway workloads in gloo-edge/gateway-api/with-gm-istio to simplify troubleshooting

0.3.17 (7-15-24)
---
- enable access logs for https gateway in gloo-edge/gateway-api environments
- configure JWT validation as a VirtualHostOption (gateway-level) but disable for homer dashboard, argo, client and LLM proxy routes
- update JWT certs used in demo to match the examples in gloo-mesh-use-cases/gloo-gateway repo from the docs (https://github.com/solo-io/gloo-mesh-use-cases/tree/main/gloo-gateway/jwt)
- add httpbin AuthorizationPolicy example to gloo-edge/gateway-api/with-istio and gloo-edge/gateway-api/with-gm-istio 
- testing GG + GM in a single cluster setup in gloo-edge/gateway-api/with-gm-istio environment (WIP)
- testing GG + GM in a three cluster setup in gloo-platform/gwapi-mgmt-gm-workers environment (WIP)
- fix links in homer dashboard in gloo-edge/gateway-api/with-istio and gloo-edge/gateway-api/with-gm-istio

0.3.16 (7-10-24)
---
- update gloo-edge/gateway-api and gloo-edge/gateway-api-with-istio to use 1.17.0-rc5
- restructure gateway-api environments to gloo-edge/gateway-api/standalone and gloo-edge/gateway-api/with-istio
- add config for multiple route policies to gloo-edge/gateway-api environments (commented out - fix coming in 1.18.0-beta2-bmain-4f950f1 or later)

0.3.15 (7-9-24)
---
- enforce strict mtls using peer authentication policy for bookinfo and httpbin applications in gloo-edge/gateway-api-with-istio environment
- add client curl application to demonstrate mtls successful when a client in the mesh calls a service in the mesh in gloo-edge/gateway-api-with-istio environment
- add client curl application to demonstrate mtls enforcement when a client not in the mesh calls a service in the mesh in gloo-edge/gateway-api-with-istio environment

0.3.14 (7-9-24)
---
- generate ai-chatbot api key secret from environment variables in env.vars in gloo-edge/gateway-api environment, otherwise prompt for openai, claude, gemini, and mistral api keys
- add gloo-edge/gateway-api-with-istio environment which is a variation of gloo-edge/gateway-api that includes an istio `1-22` revision based installation and configures bookinfo and httpbin as services in the mesh. This requires adding additional istio integration config in the gloo gateway helm chart

0.3.13 (7-8-24)
---
- Apply api-key auth to bookinfo example in gloo-edge/gateway-api
- Add JWT virtualhostoption to gateway in gloo-edge/gateway-api (commented out to demonstrate manually)
- Update homer portal in gloo-edge/gateway-api

0.3.12 (7-5-24)
---
- restructure gloo-edge/gateway-api for easier portability between branches

0.3.11 (7-5-24)
---
- restructure gloo-edge/gateway-api for easier portability between branches

0.3.10 (7-5-24)
---
- update gloo-edge/gateway-api to 1.17.0-rc4
- disable default gateway-proxy in gloo-edge/gateway-api
- configure parent/delegate routes for httpbin app in gloo-edge/gateway-api
- configure active/preview for httpbin app in gloo-edge/gateway-api to demonstrate weighted destination routing
- add bookinfo app to gloo-edge/gateway-api environment

0.3.9 (6-25-24)
---
- update gloo-edge/gateway-api to 1.17.0-rc2

0.3.8 (6-24-24)
---
add general-chatbot and language-chatbot to gloo-edge/gateway-api environment
    - configurable environment variables for backend LLM endpoints and api-keys 
    - configure the system prompt using a configmap

0.3.7 (6-6-24)
---
- update root trust to be shared across all clusters
- add e/w gateway to mgmt cluster by default in all gloo-platform environments
- remove gloo-mesh-ui from the mesh in gloo-platform environments
- add httpbin app to mgmt cluster in gloo-platform/multicluster-bookinfo-httpbin environment
    - this allows us to demo priority failover by region when using labels such as `topology.kubernetes.io/region` set on the nodes
    - when using `-i` flag to install locally, the k3d config is labeled with the following mgmt (us-west), cluster1 (us-central), cluster2 (us-east)
- update httpbin VirtualDestination to select all workload clusters and apply `failover: "true"` label
- add FailoverPolicy and OutlierDetectionPolicy to httpbin app in gloo-platform/multicluster-bookinfo-httpbin environment. The localityMappings are configured to show the following:
    - from us-central, prioritize failover to us-east first then us-west
    - from us-east, prioritize failover to us-central first then us-west

0.3.6 (6-6-24)
---
- enable okta extauth for httpbin app in gloo-edge/gateway-api environment
- update homer portal welcome tile instructions in gloo-edge/gateway-api environment

0.3.5 (6-5-24)
---
- update all environments to use gloo-platform 2.5.7
- update all environments to use istio 1.22.0-solo
- update environments to use revision 1-22
- set ignoreDifferences for failurePolicy vwc
- add multicluster failover for reviews in gloo-platform/multicluster-bookinfo-httpbin environment
- simplify httpbin routetable in gloo-platform/multicluster-bookinfo-httpbin environment
- remove not-in-mesh deployment in gloo-platform/multicluster-bookinfo-httpbin environment
- update installation completion output for gloo-edge/gateway-api environment

0.3.4 (5-30-24)
---
- update gloo-edge/gatweay-api to 1.17.0-beta3
- pin colima to v1.29.5+k3s1
- set domain-qualified `/solo-io` finalizer name `resources-finalizer.argocd.argoproj.io/solo-io` to ArgoCD Applications
    - Fixes this warning: 
    ```
    Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name to avoid accidental conflicts with other finalizer writers
    ```

0.3.3 (5-21-24)
---
- update helloworld-rollout example in gloo-gateway/progressive-delivery-argo-rollouts to use parent/child delegate route tables

0.3.2 (5-21-24)
---
- update ArgoCD to 2.10.10

0.3.1 (5-15-24)
---
- add gloo-edge/gateway-api environment
- update istio/basic-demo to use upstream 1.22.0
- enable l4-policy and l7-policy for istio/ambient-demo/uniform-apps environment

0.3.0 (5-14-24)
---
- update istio/ambient-demo to 1.22.0

0.2.15 (5-1-24)
---
- update istio/ambient-demo to 1.22.0-beta.0

0.2.14 (4-22-24)
---
- update gloo-edge environments to 1.16.6

0.2.13 (4-5-24)
---
- config fixes for NLB settings in gloo-edge environments

0.2.12 (4-4-24)
---
- update argocd to 2.9.10

0.2.11 (4-4-24)
---
- remove pointers to OCP as these are unused/untested
- add AWS NLB annotations example to `gloo-edge` and `gloo-portal` environments

0.2.10 (4-3-24)
---
- update to Gloo Platform 2.5.5

0.2.9 (3-27-24)
---
- Update istio/ambient-demo environment to use upstream Ambient profiles, simplifying configuration

0.2.8 (3-27-24)
---
- revert back to `1.20.4-solo` Istio images and `1-20` revision tag due to [#49685](https://github.com/istio/istio/issues/49685)

0.2.7 (3-21-24)
---
- upgrade Gloo Platform to 2.5.4
- upgrade Istio to 1.21.0-solo using 1-21 revision tag
- update access token validation to use remoteJwks in gloo-gateway/int-ext-portal
- update missing parameter in gloo portal extAuth server helm config
- archive gloo-platform/multicluster-portal-k3d environment

0.2.6 (3-14-24)
---
- update /istio/ambient-demo environment to 1.21.0 
    - Support for any CNI now available upstream
    - This makes it possible to test ambient an ambient environment locally on k3d or colima+k3s using the `-i` or `-i --colima` flag
- update istio/ambient-demo with a few new variations
    - `/core` -
    - `/random-generated-apps` - non-uniform applications with cross namespace communication. Default is across 5 namespaces
    - `/uniform-apps` - isolated applications per-namespace with the pattern A > B1/B2 > C1. Default is across 5 namespaces
    - `/gke` - this environment configures the `/uniform-apps` but with GKE specific requirements for ambient mesh (additional values in `istio-cni` and `ztunnels` deployed in kube-system)
- replace bombardier loadgenerator with vegeta, which allows loadgen client to do dns caching
- remove the operator deployment method in istio/ambient-demo as it is no longer supported

0.2.5 (2-16-24)
---
- bump cert-manager version to v1.14.2

0.2.4 (2-7-24)
---
- fix homer dashboard in `gloo-mesh-core/additional-cluster-1` and `gloo-mesh-core/additional-cluster-2`

0.2.3 (2-7-24)
---
- Add an online-boutique application to gloo-mesh-core/singlecluster environment
- Add gloo-mesh-core/additional-cluster-1 environment which also configures the online-boutique app
- Add gloo-mesh-core/additional-cluster-2 environment which configures the bookinfo app
- Update prereqs in readme to support k8s 1.23-1.28

0.2.2 (2-5-24)
---
- separate gloo-platform-portal into own chart to separate lifecycle
- move existing istio/ambient-demo to istio/ambient-demo/gke/operator-deploy-1.19. this environment serves as a working reference for the Istio Operator deploy with ambient profile using 1.19.6. Ambient profile has been deprecated in 1.20 in favor of Helm or istioctl
- add istio/ambient-demo/gke/helm-deploy-1.20 to use [Helm based install](https://istio.io/latest/docs/ops/ambient/install/helm-installation/) since support for Istio Operator ambient profile was removed in 1.20

0.2.1 (1-30-24)
---
- update certs to match [docs](https://docs.solo.io/gloo-mesh-enterprise/latest/setup/prod/certs/relay/byo/openssl/#step-4-install-the-gloo-management-server-and-agent)


0.2.0 (1-24-24)
---
- update main to Gloo Platform 2.5.x
- update to Istio 1.20.2-solo and 1-20 revision tag
- add `gloo-mesh-core/singlecluster` environment

0.1.17 (1-11-24)
---
- pin bombardier image tag to `alpine/bombardier:v1.2.5`

0.1.16 (1-10-24)
---
- add colima install script at `aoa-tools/tools/colima-install.sh`
- add colima as an additional infra option for local deployments. an additional --colima flag can be used in conjunction with -i in order to deploy colima + k3s instead of k3d + docker.
- rename `install_infra` function in `deploy.sh` to `install_k3d`
- fixed destroy function to destroy both colima and k3d options

0.1.15 (12-29-23)
---
- bump from Gloo Platform 2.4.4 > 2.4.7
    - required fix from #13158 to resolve issues with gloo mesh portal demo environments
    - required additional kustomization patches for gloo-gateway/int-ext-portal. specifying destination namespace in the forwardTo is needed for portal discovery

0.1.14 (12-27-23)
---
- update homer image to ably77/homer:0.1.0 (adds glooy logo)
- add --context to homer output command: 
```
echo "access the dashboard at https://$(kubectl --context ${cluster_context} -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].*}')/solo"
```

0.1.13 (12-18-23)
---
- update rollouts-ui-dashboard to `quay.io/argoproj/kubectl-argo-rollouts:v1.6.4`

0.1.12 (12-7-23)
---
- Specify `${mgmt_context}` cluster context for in the `gloo-platform/core/shared-components/homer-config/test.sh` to properly output the correct LB URL of the mgmt istio ingressgateway for the homer dashboard.
- Specify `${cluster_context}` for in the `gloo-gateway/core/homer-config/test.sh` to ensure the correct LB URL of the istio ingressgateway for the homer dashboard.

0.1.11 (12-4-23)
---
- switch back to using otel daemonset instead of deployment in gloo-platform environments

0.1.10 (12-4-23)
---
- remove OTEL tracing from default gloo-platform/core environment to fix later
- remove Istio revision label from `gloo-mesh` namespace in `gloo-platform` environments as it is not required in most setups where Gloo Platform management components are in a cluster where Istio is not deployed

0.1.9 (12-1-23)
---
- remove the number suffix after each wave (i.e. wave-0-clusterconfig to wave-clusterconfig). This helps allows us to re-order the waves more easily. It is assumed that the `catalog.yaml` list will run in descending order.
- update the wait command for Gloo Platform CRDs in `core/gloo-platform/test.sh` to run silently

0.1.8 (11-30-23)
---
- Add upstream istio/ambient-demo environment to catalog
- Update homer portal to use official helm chart specified in (Using Helm)[https://github.com/bastienwirtz/homer#using-helm]

0.1.7 (11-26-23)
---
- update rotated portal-demo okta cert-keys

0.1.6 (11-22-23)
---
- configure upstream istio grafana dashboards to be editable
- configure anonymous grafana users to have edit permissions in `gloo-gateway`, `gloo-platform` and `istio` environments so that users can see the underlying queries when doing a demo or exploring around

0.1.5 (11-21-23)
---
- provide section on `catalog.yaml` in the README
- add note on `lb-discovery` in the README
- add AWS NLB annotation `service.beta.kubernetes.io/aws-load-balancer-type: "nlb"` to `gloo-gateway`, `gloo-platform`, and `istio` environments by default to work OOTB with EKS deployments
- (alpha) add `lb-discovery` overlay to `homer-app` in select gloo-gateway environments
    - Valid for: `core`, `onlineboutique`, `progressive-delivery-argo-rollouts`, and `solowallet`
    - Configuring the `catalog.yaml` to use the homer app `lb-discovery` overlay is useful in Cloud environments where wildcard hosts are used so that the homer dashboard links reflect the LB hostname or IP.
    - Environments where Ext Auth capabilities are demonstrated cannot also have homer-app `lb-discovery`. Use `glootest.com` overlay instead which uses a stable hostname. This applies to `gloo-gateway/bookinfo`, `gloo-gateway/httpbin`, and `gloo-gateway/int-ext-portal`.

An example `catalog.yaml` below shows an example where the default localhost `homer-app` commented out and the lb-discovery `homer-app` uncommented. The homer dashboard configuration is managed by the `pre_deploy` init script where the $LB_ADDRESS is discovered and injected
```
  # Uncomment to use localhost for link dashboard (k3d)
  #- name: homer-app
  #  location: $env_path/homer-app/localhost
  #  scripts:
  #    pre_deploy: 
  #    -  $env_path/homer-app/localhost/init.sh
  #    post_deploy:
  #    -  $env_path/homer-app/localhost/test.sh 
  # Uncomment to use LB Discovery for link dashboard (Cloud)
  - name: homer-app
    location: $env_path/homer-app/lb-discovery
    scripts:
      pre_deploy: 
      -  $env_path/homer-app/lb-discovery/init.sh
      post_deploy:
      -  $env_path/homer-app/lb-discovery/test.sh 
```

0.1.4 (11-20-23)
---
- update homer test.sh LB discovery to work for AWS and GCP LBs (hostname or IP)

0.1.3 (11-20-23)
---
aoa-tools:
- refactor aoa-tools scripts
    - refactor all tools scripts to be more user-friendly, handle default values better, and include comments for clarity
    - refactor `install-argocd.sh` to run the argo install silently

- Refactor main deploy.sh script
    - add `--skip-argocd` flag
    - The content of catalog.yaml is read once and stored in the variable catalog_content.
    - The logic for creating wave_name is simplified.
    - Common logic for executing scripts is extracted into the execute_scripts function.
    - The loops for pre and post deploy scripts are combined to avoid duplication.
    - Other small readability improvements

readme:
- Update README.md

gloo-edge:
- create `gloo-edge/shared-components` to reuse components across demo environments
- expose OOTB Gloo Edge grafana dashboards and link in homer dashboard

0.1.2 (11-16-23)
---
- update gloo-portal/solo-dev-portal to use gloo-portal 1.3.3
- update gloo-edge/argo-rollouts canary example service names to match blog. stable/canary > active/preview


0.1.1 (11-13-23)
---
- update onlineboutique images to us-central1-docker.pkg.dev/field-engineering-us/online-boutique builds in `environments/gloo-platform/multicluster-onlineboutique`
- validate all `gloo-platform` environments (localhost / hostname ) working locally with k3d on x86 and M1 Macbook Pro
- update gloo-edge and gloo-portal environments to latest versions
    - gloo-edge/argo-rollouts to 1.15.7
    - gloo-edge/httpbin-bookinfo to 1.15.7
    - gloo-edge/flagger-podinfo to 1.15.7
    - gloo-portal/solo-dev-portal to gloo edge 1.15.7
- add homer portal to gloo-edge/httpbin-bookinfo to simplify navigation


0.1.0 (11-10-23)
---
- add clickhouse portal analytics to `gloo-gateway/int-ext-portal`
- migrate from istio samples grafana to grafana helm chart for gloo-gateway and gloo-platform environments
- add gloo platform ops dashboard to gloo-gateway and gloo-platform environments
- set istio before gloo-platform in catalog.yaml for gloo-gateway environments so that gloo-mesh-addons start up with istio-proxy sidecars
- set istio before gloo-platform in catalog.yaml for gloo-platform environments so that gloo-mesh-addons start up with istio-proxy sidecars
- update onlineboutique images to `us-central1-docker.pkg.dev/field-engineering-us/online-boutique` builds in `environments/gloo-gateway`
- validate all `gloo-gateway` environments (localhost / hostname / ILM overlays) working locally with k3d on x86 and M1 Macbook Pro
