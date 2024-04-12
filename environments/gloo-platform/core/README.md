### Pre-reqs
- Ensure GME [licenses](https://github.com/solo-io/gloo-mesh-enterprise?tab=readme-ov-file#generate-license-keys) are set in env.
- Ensure AWS vars are set in the env to interact with demo clusters.

### Deploy Demo site to EKS
- Setup [test env](https://github.com/solo-io/gloo-eng-test-beds/actions/workflows/build-eng-cicd-env.yaml) with 2 remote clusters (this'll take ~15 mins).

- Clone [aoa-catalog](https://github.com/solo-io/aoa-catalog) repo & checkout branch **gp-release-demo**
- Now checkout a new branch off of **gp-release-demo** for the release, e.g. gp-release-demo-v2.5.x
- Run below cmds to update docker repo and tag version
```
export TAGGED_VERSION=2.4.14-2024-04-11-v2.4.x-86a42ac5f4

export REPO_URL=https://storage.googleapis.com/gloo-platform-dev/platform-charts/helm-charts
export TARGET_REVISION=$TAGGED_VERSION

grep -rl REPO_URL ./environments | xargs sed -i '' "s|REPO_URL|$REPO_URL|g"
grep -rl TARGET_REVISION ./environments | xargs sed -i '' "s/TARGET_REVISION/$TARGET_REVISION/g"

```
> NOTE: where TARGET_REVISION is the GME dev build version without the 'v', e.g. 2.4.14-2024-04-11-v2.4.x-86a42ac5f4

- Commit changes and push new branch

- Now grab Kubeconfig for the test bed clusters from step 1 GHA workflow & run below cmds to setup (mgmt, cluster1, cluster2)
```
export KUBECONFIG=~/Downloads/kubeconfig.XYZ

kubectl config get-contexts

kubectl config rename-context mgmt-cluster mgmt
kubectl config rename-context cluster-1 cluster1
kubectl config rename-context cluster-2 cluster2

kubectl config use-context mgmt
./aoa-tools/deploy.sh deploy -f environments/gloo-platform/core/mgmt

kubectl config use-context cluster1
./aoa-tools/deploy.sh deploy -f environments/gloo-platform/core/cluster1

kubectl config use-context cluster2
./aoa-tools/deploy.sh deploy -f environments/gloo-platform/core/cluster2
```
- Once test bed clusters are setup, you can visualize demo site UI
```
kubectl --context mgmt-cluster port-forward --namespace gloo-mesh svc/gloo-mesh-ui 8090:8090
```