# Changelog

0.1 (11-10-23)
---
- add clickhouse portal analytics to `gloo-gateway/int-ext-portal`
- migrate from istio samples grafana to grafana helm chart for gloo-gateway and gloo-platform environments
- add gloo platform ops dashboard to gloo-gateway and gloo-platform environments
- set istio before gloo-platform in catalog.yaml for gloo-gateway environments so that gloo-mesh-addons start up with istio-proxy sidecars
- set istio before gloo-platform in catalog.yaml for gloo-platform environments so that gloo-mesh-addons start up with istio-proxy sidecars
- update onlineboutique images to `us-central1-docker.pkg.dev/field-engineering-us/online-boutique` builds in `environments/gloo-gateway`
- validate all `gloo-gateway` environments (localhost / hostname / ILM overlays) working locally with k3d on x86 and M1 Macbook Pro