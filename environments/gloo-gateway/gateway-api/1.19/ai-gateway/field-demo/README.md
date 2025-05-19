# Environment Description
The `gateway-api/ai-gateway/lb-failover-demo` environment deploys Gloo Gateway EE along with AI Gateway enabled to demonstrate traffic shifting and resiliency use cases

To deploy this environment:
```
./aoa-tools/deploy.sh deploy -f <environment directory>
```

Once the installation is complete navigate to the `/demos` directory to the demo you want to test and run the `demo-script.sh`
```
cd demo
./demo-script.sh
```