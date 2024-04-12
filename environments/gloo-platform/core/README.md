### Pre-reqs
- Ensure GME [licenses](https://github.com/solo-io/gloo-mesh-enterprise?tab=readme-ov-file#generate-license-keys) are set in env.
- Ensure AWS vars are set in the env to interact with demo clusters.

### Deploy Demo site to EKS
- Now deploy test bed with 2 remote clusters (this'll take ~15 mins)
https://github.com/solo-io/gloo-eng-test-beds/actions/workflows/build-eng-cicd-env.yaml
https://github.com/solo-io/gloo-eng-test-beds/actions/runs/8254412573

- Clone [aoa-catalog](https://github.com/solo-io/aoa-catalog) repo & checkout branch **gp-release-demo**
- TODO: Run below cmds to update docker repo and tag version
```

```
- Now checkout a new branch off of **gp-release-demo** for the release, e.g. gp-release-demo-v2.5.x
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