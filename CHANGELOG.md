# Changelog

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