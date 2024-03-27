# Changelog

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
