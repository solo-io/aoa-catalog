# Changelog

0.8.7 (4-11-25)
---
- update gateway-api/1.18/portal-only demo to add OIDC and rate limiting

0.8.6 (4-2-25)
---
- update /gloo-platform environments to use gloo-platform 2.7.1
- update /gloo-mesh-gateway environments to use gloo-platform 2.7.1
- update /gloo-mesh-core environments to use gloo-platform 2.7.1
- update /istio environments to use istio 1.25.0
- update /gloo-gateway environments to use gloo-gateway 1.18.9
- update /gloo-gateway/oss environments to use OSS gloo-gateway 1.18.13
- configure `telemetryCollector.mode: deployment` for `/gateway-api/1.18/with-gm-istio-helm-sidecar` environment to visualize Gloo Gateway metrics in the main dashboard

0.8.5 (2-11-25)
---
- Formatting fixes and updates to AI gateway demo scripts in `gloo-gateway/gateway-api/1.18/ai-gateway/field-demo/demos`

0.8.4 (1-31-25)
---
- update /gloo-gateway environments to use gloo-gateway 1.18.3 / istio 1.24.2 / `main` as revision tag / gloo-platform 2.6.9 (where used)
- update /gloo-gateway/oss environments to use OSS gloo-gateway 1.18.6
- update /gloo-mesh-core environments to use gloo-platform 2.6.9 / istio 1.24.2 / `main` as revision tag
- update /gloo-mesh-gateway environments to use gloo-platform 2.6.9 / istio 1.24.2 / `main` as revision tag
- update /gloo-platform environments to use gloo-platform 2.6.9 / istio 1.24.2 / `main` as revision tag
- update /istio environments to use istio 1.24.2 / `main` as revision tag

0.8.3 (1-30-25)
---
- updates/fixes to gateway-api/1.18/with-ilm-ambient/multicluster environments
- add ambient multicluster failover demo script

0.8.2 (1-28-25)
---
- update gloo-operator to 0.1.0-rc.0 in gateway-api/1.18/with-ilm-ambient environments
- update gwapi crds to use v1.2.0 in all environments
- update colima-install.sh to use profiles which enables local multi-cluster installations
- update colima-install.sh to use k8s v1.31.2+k3s1
- minor fixes/updates in gateway-api/1.18/ai-gateway/field-demo environment

0.8.1 (1-21-25)
---
- configured a kustomize patch for `ServiceMeshController` to specify `cluster1` and `cluster2` in for network and cluster vars in the `gateway-api/1.18/with-ilm-ambient` environments
- split `/with-ilm-ambient` into singlecluster and multicluster overlays
- configure istio peering gateways in post script
- move observability tooling to istio/observability in the `/with-ilm-ambient` environments into it's own wave. This avoids an error condition where kiali and prometheus are ready before ILM has configured the Istio mesh
- note that in `gateway-api/1.18/with-ilm-ambient` environments the cacerts secret for shared root trust will need to be provided by the user. The init.sh script (found at gateway-api/1.18/with-ilm-ambient/cluster1/istio/init.sh) expects this secret to be under `/aoa-tools/shared-root-trust-secret.yaml`. Will find a longer term solution for this later

0.8.0 (1-16-25)
---
- deprecate gateway-api/1.17 in favor of gateway-api/1.18
- split gateway-api/1.18/with-ilm-ambient into /cluster1 and /cluster2 overlays to start testing multicluster peering
- fix auth policies in gateway-api/1.18/with-ilm-ambient/base/tiered-app to use wildcard as the trust domain instead of cluster.local. This is done because the trust domain for multicluster is configured to match the cluster name (e.g. cluster1 or cluster2)
- note that in `gateway-api/1.18/with-ilm-ambient` environments the cacerts secret for shared root trust will need to be provided by the user. The init.sh script (found at gateway-api/1.18/with-ilm-ambient/cluster1/istio/init.sh) expects this secret to be under `/aoa-tools/shared-root-trust-secret.yaml`. Will find a longer term solution for this later

0.7.10 (1-14-25)
---
- update kiali configmap to include ilm-v3 "gloo" revision label in `gateway-api/1.18/with-ilm-ambient` environment. This gets rid of warnings in the kiali UI

0.7.9 (1-13-25)
---
- update gloo-operator to 0.1.0-beta.2 in gateway-api/1.18/with-ilm-ambient environment
- configure gateway-api/1.18/with-ilm-ambient to enforce L7 auth policies

0.7.8 (12-27-24)
---
- Updated a few more areas where LB discovery was not using selectors

0.7.7 (12-27-24)
---
- update all `demo-script.sh` in ai-gateway/field-demo/demos to use label selectors when discovering the LB address, this makes it consistent with the rest of aoa-catalog

0.7.6 (12-27-24)
---
- Update /istio environments to 1.23.4
- Update /gateway-api/1.17/with-istio-helm-ambient environment to 1.23.4
- Update /gateway-api/1.18/with-istio-helm-ambient environment to 1.23.4
- Update Gateway API CRDs from experimental 0.6.1 to stable 1.2.0 for ambient environments
- Move all ambient components to `istio-system` and add `ResourceQuota` for GKE deployments. Previously istio-cni and ztunnel were deployed in `kube-system` namespace
- Add `/gateway-api/1.18/with-istio-helm-ambient/gke` overlay to support GKE deployments for this environment
- Previously any LB discovery was done with the following `-o jsonpath='{.items[*].status.loadBalancer.ingress[0].*}'` which for certain cloud providers (GKE and AWS) picks up additional fields. This now has been changed to `-o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}'` which should capture all LB address formats

0.7.5 (12-26-24)
---
- Cleanup of unused environments/overlays
- Replace youtube video of deployment in main readme with updated asciinema version

0.7.4 (12-26-24)
---
- change system/user prompts to focus on LLMs in ai-gateway/field-demo/demos
- migrated gateway-api/1.17/with-istio-ambient environment to gateway-api/1.18/with-istio-helm-ambient
- migrated gateway-api/1.17/standalone environment to 1.18
- migrated gateway-api/1.17/argo-rollouts environment to 1.18
- migrated gateway-api/1.17/with-istio-sidecar environment to gateway-api/1.18/with-istio-helm-sidecar
- migrated gateway-api/1.17/with-gm-istio environment to gateway-api/1.18/with-gm-istio-helm-sidecar
- testing ILMv3 in gateway-api/1.18/with-ilm-ambient environment
    - seeing some issues with L7 waypoint auth policies
- add `aoa-tools/find-hostnames.sh` to simplify discovery of hostnames used in a particular environment. To use this script run `aoa-tools/find-hostnames.sh <environment-path`. Note this only works with environments that use GWAPI and `HTTPRoutes`

0.7.3 (12-23-24)
---
- update gloo-gateway/1.18/oss to 1.18.2
- update gloo-gateway/1.18/portal-only to 1.18.1
- add ai-gateway/field-demo that includes all scripted demos under /demos directory
    - auth-and-rl-demo
    - lb-failover-demo
    - prompt-management-demo
    - semantic-cache-demo
- remove previously separated AI gateway demo environments in favor of ai-gateway/field-demo

0.7.2 (12-5-24)
---
- add 1.18/ai-gateway/lb-failover-demo environment to demonstrate traffic shifting and resiliency
- add 1.18/ai-gateway/auth-and-rl-demo environment to demonstrate JWT Auth, RBAC, and Rate Limiting based on Token count

0.7.1 (12-5-24)
---
- set gloo-gateway/gateway-api/1.18/ai-gateway and /portal-only envs to use `1.18.0-rc3` release
- reconfigure ollama to own namespace in gloo-gateway/gateway-api/1.18/ai-gateway/lb-failover-demo
- add demo-script.sh in gloo-gateway/gateway-api/1.18/ai-gateway/lb-failover-demo
- set gloo-gateway/gateway-api/1.17 environments to `1.17.4`
- set gloo-gateway/gateway-api/1.17 environments using istio to `1.24.0-solo` images and `1-24` revision tag and update Gloo Platform to `2.6.6`
    - note that ambient environments are still configured to use `1.23.3` until a fix in `1.24.2`
- set gloo-mesh-core environments to `2.6.6` and istio `1.24.0-solo` with `1-24` revision tag
- set gloo-mesh-gateway environments to `2.6.6` and istio `1.24.0-solo` with `1-24` revision tag
- set gloo-platform environments to `2.6.6` and istio `1.24.0-solo` with `1-24` revision tag


0.7.0 (11-19-24)
---
- set 1.18/ai-gateway and /portal-only envs to use `1.18.0-rc1` release
- rename 1.18/ai-gateway environment to 1.18/ai-gateway/chatbots
- add 1.18/ai-gateway/lb-failover-demo environment to demonstrate traffic shifting and resiliency capabilities (see manual instructions [here](https://github.com/ably77/aig-lb-failover-demo))
- update 1.18/oss env to use OSS `1.18.0-beta33` release
- configure postgres database backend for gloo-portal-backend-server in 1.18/portal-only environment

0.6.12 (10-30-24)
---
- reset 1.18/ai-gateway env to use helm chart from `http://storage.googleapis.com/gloo-ee-helm` and `1.18.0-beta1` build

0.6.11 (10-24-24)
---
- Update `aoa-tools/render-manifests.sh`. Non-manifest details (environment details, kustomization file locations, etc.) are now prefixed with # to make the output directly usable with kubectl apply.

0.6.10 (10-24-24)
---
- Update `dynamic-rl-script.sh` and `dynamic-rl-script-example-output.txt` in `gateway-api/1.18/portal-only`

0.6.9 (10-24-24)
---
- Update gloo-gateway to `1.18.0-rc1-bmain-1203aed ` in `gateway-api/1.18/portal-only` and `gateway-api/1.18/ai-gateway` environment

0.6.8 (10-23-24)
---
- Update gloo-gateway to `1.18.0-rc1-bmain-d7eacd4` in `gateway-api/1.18/portal-only` and `gateway-api/1.18/ai-gateway` environment
- Update gloo-gateway to `1.18.0-rc18` in gateway-api/1.18/oss environment

0.6.7 (10-23-24)
---
- Update homer portal to use `ably77/homer:0.1.4` 
- Refresh homer dashboard theme with Solo colors and logos
- Update homepage title and slogan
- Fix links pointing at Gloo Gateway

0.6.6 (10-17-24)
---
- add `/aoa-tools/render-manifests.sh` script - generate and view all Kubernetes manifests for a given environment or wave by providing a path
- add `Render environment manifests` section to README.md on how to use this new tool

0.6.5 (10-16-24)
---
- add ability to the to configure sync override for wave in catalog.yaml
- configure `parent_app_sync=true` in `vars.env` as default in all rollouts demo environments
- configure `sync: false` override in rollouts-demo overlay in all rollouts demo environments
- update readme with details and an example for catalog.yaml sync override
- add `--dry-run` feature to installer
- update readme with details and an example for `--dry-run` flag

0.6.4 (10-15-24)
---
- Add gateway-api/1.17/argo-rollouts environment

0.6.3 (10-2-24)
---
- Update readme with hostname entries section describing all of the hostnames used in this repo and how to configure them locally

0.6.2 (10-1-24)
---
- Use targetRef style route option for openai `HTTPRoute` in `gateway-api/1.18/ai-gateway environment`
- Configure `ai.promptGuard` and `ai.promptEnrichment` options for openai route
- Provide `prompt-guard-test-script.sh` in  `ai-gateway/ai-gateway/base/openai` to demo prompt guards and prompt enrichment
- Provide `prompt-guard-test-script-output.txt` in  `gateway-api/1.18/ai-gateway/ai-gateway/base/openai` to demo prompt guards and prompt enrichment
- add locust loadgen example in `gateway-api/1.18/ai-gateway`
- add ai-gateway access log listeneroption
- configure `replicas: 1` in ai-gateway GatewayParameters
- added chatbot/base/betterchatgpt
- added chatbot/base/llama-gpt (not enabled by default)

0.6.1 (9-25-24)
---
- Update gloo-gateway/gateway-api/portal-only to latest test builds to enable dynamic rate limiting functionality
- Configured portal OPA auth setup in `gateway-api/portal-only/gateway-api-config`
- Configured `tracks-dynamic-rlc` RateLimitConfig for the tracks-api. This contains "global" 100 req/second limit for the RLC by default, which can be overridden using the portal server REST API
- Create `dynamic-rl-script.sh` and `dynamic-rl-script-example-output.md` in `gateway-api/portal-only/gloo-portal/demo/base/tracks-api` to walk through dynamic rate limiting functionality for the tracks API Product
- Update portal frontend build to `gcr.io/solo-public/docs/portal-frontend:gg-teams-apps-demo-v1`
- Split environments/gloo-gateway into 1.17 and 1.18
- Add `gloo-gateway/gateway-api/1.18/ai-gateway` environment

- (WIP) experimenting with oidc/pkce auth for portal frontend in gateway-api/portal-only environment

0.6.0 (9-13-24)
---
Reorganization of environments:
- rename `gloo-gateway` environment to `gloo-mesh-gateway`
- rename `gloo-edge` environment to `gloo-gateway`
- segment `gloo-gateway` environments between v1 (gloo-edge) and v2 (gateway api)
- move `gloo-portal/solo-dev-portal` to `gloo-gateway/gloo-edge` directory

0.5.9 (9-12-24)
---
- improvements to gateway-api/portal-only environment
    - petstore-api demonstrates automatic `APIDoc` creation using service annotations
    - openlibrary-api demonstrates automatic `APIDoc` creation using `ApiSchemaDiscovery`
    - gloo-portal-server-api demonstrates manual `APIDoc` creation using `inlineString`
    - add portal backend server link to homer dashboard

0.5.8 (9-9-24)
---
- update environments using Gloo Platform chart to 2.6.3
- update gloo-platform/gwapi-mgmt-gm-workers/mgmt to use Gloo Gateway 1.17.1

0.5.7 (9-9-24)
---
- remove reference to gloo portal in homer dashboard for gateway-api/standalone environment - moved to gateway-api/portal-only
- fix duplicate `-solo` istio image tag reference in gloo-gateway/core environment

0.5.6 (9-5-24)
---
- add `tracks-route-policies` to disable JWT validation at the route level in the `gateway-api/portal-only` environment
- add `petstore-api` example to `gateway-api/portal-only` environment. this is not configured by default, but is numbered so that a user can walk through the steps of onboarding an API product manually by applying the manifests in ordered stages 1 > 2 > 3 > 4 while describing the workflow

0.5.5 (9-4-24)
---
- set `gloo-fed.enabled=false` and `gloo-fed.glooFedApiserver.enable=false` in gateway-api environments since they are unused
- add `gloo-edge/gateway-api/portal-only` environment
- update readme files of `gateway-api` environments to reflect the description of environment more accurately

0.5.4 (8-30-24)
---
- set `featureGates.insightsConfiguration=true` helm values and configure an `InsightsConfig` to disable to supress `HLT0001` insight when using Gloo Gateway Istio integration feature in `gateway-api/with-gm-istio` and `gloo-platform/gwapi-mgmt-gm-workers` environments

0.5.3 (8-29-24)
---
- update gloo-edge/gateway-api environments to 1.17.1
- update customEnv var for portal. previously was `GG_EXPERIMENTAL_PORTAL_PLUGIN` and now is `GG_PORTAL_PLUGIN`
- update bookinfo image to latest upstream in 1.23 for performance improvements
- fix issue with bookinfo parent route matcher in gloo-edge/gateway-api environments

0.5.2 (8-26-24)
---
- archive gloo-edge/flagger-podinfo
- archive gloo-gateway/int-ext-portal
- archive gloo-gateway/solowallet
- archive gloo-platform/multicluster-podinfo-weighted-subset-failover

0.5.1 (8-19-24)
---
- update istio helm chart version to `1.23.0-solo` and revision label `1-23` across all environments

0.5.0 (8-15-24)
---
- update gloo-platform-helm chart across all environments to use 2.6.0
    - set `glooInsightsEngine.enabled: true` in helm values
    - configure gloo analyzer in helm values
- rename gloo-edge/gateway-api/with-istio environment to gloo-edge/gateway-api/with-istio-sidecar
- add gloo-edge/gateway-api/with-istio-ambient environment
- update gateway-api/oss to 1.18.0-beta14
    - validated that merging multiple ExtensionRef options in a HTTPRoute works
- cleanup unnecessary annotations and revision labels being applied on istio ingress gateways across all environments

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
- update gloo-platform-helm chart across all environments to use 2.5.9
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
- add config for multiple route policies to gloo-edge/gateway-api environments (commented out - fix coming in 1.17.1 or later)

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
