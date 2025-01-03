# aoa-catalog
This repo serves as a collection of Solo.io demo environments driven by GitOps using the ArgoCD app-of-apps pattern.

### Prerequisites
- `yq` - `brew install yq` or see here (https://mikefarah.gitbook.io/yq/v/v3.x/)
- `k3d` - `brew install k3d` or see here (https://k3d.io/v5.4.7/#installation)
- `kubectl` - `brew install kubectl` or see here (https://kubernetes.io/docs/tasks/tools/#kubectl)

### Deployment Demonstration

An `asciinema` demonstration showcasing the installation of the Gateway API (v1.18) with Istio Helm in an Ambient Mesh environment.

[![asciicast](https://asciinema.org/a/euuMmsac6L3QaG58Yd3X6gDSN.svg)](https://asciinema.org/a/euuMmsac6L3QaG58Yd3X6gDSN)

#### Exporting your license key
For environments that require an Enterprise product license, export your license key with the commands below
```
export GLOO_LICENSE_KEY="<INSERT_LICENSE_KEY_HERE>"
export GLOO_PLATFORM_LICENSE_KEY="<INSERT_LICENSE_KEY_HERE>"
export LICENSE_KEY="<INSERT_LICENSE_KEY_HERE>"
```

#### Renaming Cluster Context
If your local clusters have a different context name, you will want to have it match the expected context name(s) (mgmt,cluster1,cluster2).
IE for the mgmt cluster
```
kubectl config rename-context k3d-your_mgmt_cluster_name mgmt
```

## To deploy
```
./aoa-tools/deploy.sh deploy -f <environment directory>
```

### Installer options
```
aoa-catalog installer.

Syntax: installer [-f|-i|-h|--colima|--dry-run]

commands:
deploy     deploys an environment with the specified path
destroy    destroys an environment with the specified path

options:
-f     path to environment files
-i     install infra
-h     print help

additional flags:
--skip-argo  skip argo installation
--colima   execute colima-install.sh script instead of k3d-install.sh
--dry-run   simulate the actions without making changes
```

### install local dev infra with flags

If `-i` is used, the installer will check for a folder named `.infra` in the environment directory and will install the infra before running the script. This currently only supports `k3d` for local deployments

Example to deploy k3d before installing
```
./aoa-tools/deploy.sh deploy -if <environment directory>
```

If `-i` and `--colima` is used, the installer will bootstrap a local colima install
```
./aoa-tools/deploy.sh deploy -if <environment directory> --colima
```

### review using dry-run
If `--dry-run` is used, the installer will simulate the steps and provide a readout without actually configuring anything

Here's an example output:
```
% aoa deploy -if environments/gloo-gateway/gateway-api/1.17/standalone --dry-run
Dry-run: Would install K3D infrastructure.
Dry-run: Would install ArgoCD.

Starting gloo-enterprise-app with sync=true
Dry-run: Would execute pre_deploy script at environments/gloo-gateway/gateway-api/1.17/standalone/gloo-enterprise-app/init.sh.
Dry-run: The following ArgoCD Application would be created:

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wave-gloo-enterprise-app-aoa
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io/solo-io
spec:
  project: app-of-apps
  source:
    repoURL: https://github.com/solo-io/aoa-catalog/
    targetRevision: 0.6.5
    path: environments/gloo-gateway/gateway-api/1.17/standalone/gloo-enterprise-app/base
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    retry:
      limit: 2
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m0s

Dry-run: Would execute post_deploy script at environments/gloo-gateway/gateway-api/1.17/standalone/gloo-enterprise-app/test.sh.
<...>
END.
```

### Render environment manifests
The `render-manifests.sh` script located in `/aoa-tools` allows you to generate and view all Kubernetes manifests for a given environment or wave. It automatically detects all kustomization.yaml files within the specified environment and renders the manifests that will be applied. The output can also be saved to a text file.

Usage:
```
./aoa-tools/render-manifests.sh <environment-path>
```

### catalog.yaml
The `catalog.yaml` exists in each demo environment directory which provides a list of app-of-apps "waves" to be deployed in order by the installer. A wave consists of the `location` (relative to the root path of the selected environment) as well as `pre_deploy` and `post_deploy` scripts which can be optionally run which can be useful for tasks such as health checks, or waiting for pods to be ready or printing output.

Example sequence of events:
```
(Wave 1)
pre_deploy scripts > deploy app-of-app > post_deploy scripts
(Wave 2)
pre_deploy scripts > deploy app-of-app > post_deploy scripts
<...>
```

## Hostname entries

Across the repo, the environments may be configured to use non-wildcard hostnames. Typically this should be `*.glootest.com` mapped to your Cloud LoadBalancer IP and configured with your DNS provider (i.e. Cloudflare, Route53, etc.)

If running locally, these entries need to be added to `/etc/hosts` and unfortunately `/etc/hosts` does not support wildcard entries, therefore each required hostname needs to be mapped

A tool I have found useful to manage `/etc/hosts` entries when running locally is [hostctl](https://github.com/guumaster/hostctl?tab=readme-ov-file). The following instructions can help you set get quickly set up on a Mac OSX environment

#### Install hostctl on Mac OSX

To install `hostctl` via Homebrew, run:
```
brew install guumaster/tap/hostctl
```

#### Adding entries using hostctl (updated 10-2-24)
The following list contains all of the hostnames being used across all environments in this repo.

This command will create a profile named `aoa-catalog` and map the following hostnames to `localhost`
```
sudo hostctl add domains aoa-catalog argocd.glootest.com mgmt-argocd.glootest.com cluster1-argocd.glootest.com cluster2-argocd.glootest.com gmui.glootest.com grafana.glootest.com bookinfo.glootest.com httpbin.glootest.com httpbin.int.glootest.com solowallet.glootest.com podinfo.glootest.com shop.glootest.com petstore.glootest.com petstore.int.glootest.com tracks.glootest.com solo-dev-portal.glootest.com backstage.glootest.com petstore-portal.glootest.com petstore-portal.int.glootest.com httpbin-portal.int.glootest.com httpbin-portal.glootest.com kubeinvaders.io external-portal.glootest.com jaeger.glootest.com portal.glootest.com api.glootest.com devapi.glootest.com tracks.int.glootest.com helloworld.glootest.com echo.glootest.com rollouts-demo.glootest.com admin.glootest.com homer.glootest.com ai-gateway.glootest.com general-chatbot.glootest.com language-chatbot.glootest.com client.glootest.com gloo-mesh-ui.glootest.com cluster1-bookinfo.example.com cluster1-httpbin.example.com cluster2-bookinfo.example.com passthrough.glootest.com kiali.glootest.com tiered-app.glootest.com idp.glootest.com openlibrary.glootest.com yahoo-finance.glootest.com chat.glootest.com llamagpt.glootest.com llm.glootest.com
```

For cloud based deployments without available DNS, we can use `hostctl` to map the hostnames to an IP using the `--ip` flag. The following example creates a new profile named `aoa-catalog-cloud`
```
sudo hostctl add domains aoa-catalog-cloud <hostnames_here> --ip 35.190.150.239
```

To list available profiles:
```
sudo hostctl list
```

To enable a profile:
```
sudo hostctl enable aoa-catalog
```

To disable a profile:
```
sudo hostctl disable aoa-catalog
```

To remove a profile completely
```
sudo hostctl remove aoa-catalog
```

#### Cloud Loadbalancer Discovery (alpha)
*Note:* This is only available on select `gloo-gateway` environments, but more will be added over time

Configuring the `catalog.yaml` to use the homer app `lb-discovery` overlay is useful in Cloud environments where wildcard hosts are used so that the homer dashboard links reflect the LB hostname or IP.
- Valid for: `core`, `onlineboutique`, `progressive-delivery-argo-rollouts`, and `solowallet`
- Environments where Ext Auth capabilities are demonstrated cannot also have homer-app `lb-discovery` due to IDP callback URLs. Use `glootest.com` overlay instead which uses a stable hostname. This applies to `gloo-gateway/bookinfo`, `gloo-gateway/httpbin`, and `gloo-gateway/int-ext-portal`.

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

### vars.env
The `vars.env` exists in each demo environment directory with a few variables used in the installation such as inputting license keys, defining cluster contexts, and configuring app sync behavior. The installer will use any passed in flags and attempt to discover all of the necessary variables in the pre-check. Please verify the output before continuing.
```
license_key="$GLOO_PLATFORM_LICENSE_KEY"
cluster_context="mgmt"
parent_app_sync="true"
```

When `parent_app_sync="false"` the installer will disable ArgoCD `autosync` and `prune` features. This is particularly useful for development so manual changes using `kubectl` are not re-synced by ArgoCD.

### sync override a wave in catalog.yaml
For cases where you want to control sync behavior of individual waves in the catalog.yaml, it is possible to do so. Configuring a sync override takes priority over the `parent_app_sync` value configured in the `vars.env`. If undefined, the deploy script will use the `parent_app_sync` value as the default

An example `catalog.yaml` entry with sync set to false:
```
- name: rollouts-demo
    location: $env_path/rollouts-demo/strategies
    scripts:
      pre_deploy: 
      -  $env_path/rollouts-demo/init.sh
      post_deploy:
      -  $env_path/rollouts-demo/test.sh
    sync: false
```

#### k3d loadbalancer port mapping
K3d allows for exposing ports via docker and servicelb in local deployments. This provides local access to services with `type: LoadBalancer` in the browser at `localhost:<port>`. The k3d cluster config examples provided in the `.infra` folder are configured with the following mappings

* mgmt cluster port 80:80 and 443:443
* cluster1 cluster port 8080:80 and 8443:443
* cluster2 cluster port 8081:80 and 8444:443

#### using a private repo
ArgoCD makes it pretty easy to connect to a private repo. Prior to running the installer, provide the private repo and your github access token as a Kubernetes secret in the `argocd` namespace
```
apiVersion: v1
kind: Secret
metadata:
  name: first-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/solo-io/aoa-lib-private
---
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repo-creds
stringData:
  type: git
  url: https://github.com/solo-io
  # personal access token
  password: <access_token>
  username: solo-io
```