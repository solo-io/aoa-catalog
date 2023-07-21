## Setup

Add the following lines to your `/etc/hosts`

```
127.0.0.1 httpbin.glootest.com
127.0.0.1 httpbin-portal.glootest.com
```

## To deploy
Run the following commands in separate terminals.

```
./aoa-tools/deploy.sh  deploy -i -f environments/gloo-platform/multicluster-portal/mgmt

./aoa-tools/deploy.sh  deploy -i -f environments/gloo-platform/multicluster-portal/cluster1

./aoa-tools/deploy.sh  deploy -i -f environments/gloo-platform/multicluster-portal/cluster2
```

## To test

