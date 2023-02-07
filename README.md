# aoa-lib
This repo serves as a collection of Solo.io demo environments driven by GitOps using the ArgoCD app-of-apps pattern.

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

Note: If `-i` is used, the installer will check for a folder named `.infra` in the environment directory and will install the infra before running the script. This currently only supports `k3d` for local deployments

#### vars.env
If a `vars.env` exists in the demo environment directory then it will be treated as the source of truth for the installation. Leverage the `vars.env` to specify different cluster contexts and environment overlays as well as github username, repo name, and branch when using a fork of this repo.

If a `vars.env` is not present, the installer will use any passed in flags and attempt to discover all of the necessary variables in the pre-check. Please verify the output before continuing

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
  url: https://github.com/ably77/aoa-lib-private
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
  url: https://github.com/ably77
  # personal access token
  password: <access_token>
  username: ably77
```

then in the `vars.env` point at your private repo before running the install script:
```
repo_name="aoa-lib-private"
```