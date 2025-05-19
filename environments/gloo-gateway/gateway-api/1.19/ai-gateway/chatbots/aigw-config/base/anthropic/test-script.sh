#/bin/bash

export INGRESS_GW_ADDRESS=$(kubectl get svc -n gloo-system --selector=gateway.networking.k8s.io/gateway-name=ai-gateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')
echo $INGRESS_GW_ADDRESS

curl -v "$INGRESS_GW_ADDRESS:8080/anthropic" -H content-type:application/json -H "anthropic-version: 2023-06-01"  -d '{
    "model": "claude-3-5-sonnet-20240620",
    "max_tokens": 1024,
    "messages": [
        {"role": "user", "content": "Hello, world"}
    ]
}' | jq