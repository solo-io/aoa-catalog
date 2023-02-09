# aoa-catalog
This repo serves as a collection of Solo.io demo environments driven by GitOps using the ArgoCD app-of-apps pattern.

### Demo



https://user-images.githubusercontent.com/5981604/217685510-e4410308-eafd-47a4-a67c-ab48c679244f.mp4




### Prerequisites
- `yq` - `brew install yq` or see here (https://mikefarah.gitbook.io/yq/v/v3.x/)
- `k3d` - `brew install k3d` or see here (https://k3d.io/v5.4.7/#installation)
- `kubectl` - `brew install kubectl` or see here (https://kubernetes.io/docs/tasks/tools/#kubectl)

#### Exporting your license key
For environments that require an Enterprise product license, export your license key with the commands below
```
export GLOO_LICENSE_KEY="<INSERT_LICENSE_KEY_HERE>"
export GLOO_MESH_LICENSE_KEY="<INSERT_LICENSE_KEY_HERE>"
```

## To deploy
```
./aoa-tools/deploy.sh -f <environment directory>
```

### Installer options
```
Syntax: installer [-f|-o|-i|-h]
options:
-f     path to AoA files
-o     overlay
-i     install infra
-h     print help
```

Notes on defaults: 
- If `-i` is used, the installer will check for a folder named `.infra` in the environment directory and will install the infra before running the script. This currently only supports `k3d` for local deployments
- If the overlay is not specified by passing the `-o` flag, the installer will default to `base`. This flag is useful for example to pass in the `-o m1` to use the `m1` overlays containing ARM based images

### vars.env
The `vars.env` exists in each demo environment directory and the specified variables are treated as the source of truth for the installation. The installer will use any passed in flags and attempt to discover all of the necessary variables in the pre-check. Please verify the output before continuing.

Note: All variables present in the `vars.env` will be exported and available everywhere for continued use

#### vars.env overrides
Below are a few override example variables that can be useful when forking this repo or specifying an `environment_overlay` directly

to specify different cluster contexts and environment overlays as well as github username, repo name, and branch when using a fork of this repo.
```
# git vars
github_username="<a git username>"
repo_name="<another repo>"
target_branch="HEAD"

# define overlay
environment_overlay="m1"
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

then in the `vars.env` point at your private repo before running the install script:
```
repo_name="aoa-lib-private"
```
