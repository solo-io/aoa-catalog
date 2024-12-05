#!/bin/bash

echo "Starting the Load Balancing and Failover Demo..."
echo

# Step 1: Review Example Upstreams
echo
read -p "Step 1: Review example upstream configurations. Press enter to proceed..."
cat traffic-shift/ollama-qwen-0.5-upstream.yaml
cat traffic-shift/ollama-qwen-1.8-upstream.yaml
echo

# Step 2: Review HTTPRoute for 50-50 Traffic Split
echo
read -p "Step 2: Review HTTPRoute for 50-50 traffic split. Press enter to proceed..."
cat traffic-shift/qwen-5050-httproute.yaml
echo

# Step 3: Configure Traffic Shift
echo
read -p "Step 3: Apply 50-50 traffic shift configuration. Press enter to proceed..."
kubectl apply -f traffic-shift
echo

# Step 4: Get AI Gateway Load Balancer Address
echo
read -p "Step 4: Retrieve the AI Gateway Load Balancer address. Press enter to proceed..."
export GATEWAY_IP=$(kubectl get svc -n gloo-system gloo-proxy-ai-gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}{.status.loadBalancer.ingress[0].hostname}')
echo "Gateway IP: $GATEWAY_IP"
echo

# Step 5: Test Traffic Distribution
echo
echo "Step 5: Test the traffic distribution."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting traffic distribution test."
    break
  fi

  echo "Sending request to AI Gateway..."
  curl http://$GATEWAY_IP:8080/qwen -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should show a 50-50 distribution between qwen-0.5b and qwen-1.8b models."
  echo
done

# Step 6: Configure Local-to-Local Failover
echo
read -p "Step 6: Configure local-to-local failover example. Press enter to proceed..."
cat failover/local-to-local/failover-upstream.yaml
cat failover/local-to-local/failover-route.yaml
kubectl apply -f failover/local-to-local
echo "Local-to-local failover configuration applied."
echo

# Step 7: Test Failover
echo
echo "Testing /failover endpoint."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    break
  fi

  echo "Sending request to failover endpoint..."
  curl http://$GATEWAY_IP:8080/failover -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should come from qwen-1.8b unless it's unhealthy, in which case it will fail over to qwen-0.5b."
  echo
done

# Step 8: Simulate Failover Errors
echo
read -p "Step 8: Simulate failover errors. Press enter to proceed..."
cat failover/local-to-local/simulate-error/failover-upstream.yaml
kubectl apply -f failover/local-to-local/simulate-error
echo "Failover configuration with simulated errors applied."
echo
echo "Testing /failover endpoint."


while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting failover error simulation test."
    break
  fi

  echo "Sending request to failover endpoint..."
  curl http://$GATEWAY_IP:8080/failover -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should now fail over to qwen-0.5b due to simulated errors on qwen-1.8b."
  echo
done

# Step 9: Configure OpenAI to Local Failover
echo
read -p "Step 9: Configure OpenAI to local failover. Press enter to proceed..."
kubectl create secret generic openai-secret -n gloo-system \
--from-literal="Authorization=Bearer $OPENAI_API_KEY" \
--dry-run=client -oyaml | kubectl apply -f -
cat failover/openai-to-local/openai-to-local-upstream.yaml
kubectl apply -f failover/openai-to-local
echo "OpenAI to local failover configuration applied."
echo

# Step 10: Test OpenAI Failover
echo
echo "Testing OpenAI failover endpoint."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting OpenAI failover test."
    break
  fi

  echo "Sending request to OpenAI endpoint..."
  curl http://$GATEWAY_IP:8080/openai -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo "Responses should initially come from OpenAI unless the upstream is unhealthy, in which case it will fail over to qwen-0.5b."
  echo
done

# Step 11: Simulate Error for OpenAI Failover
echo
read -p "Step 11: Simulate error for OpenAI failover. Press enter to proceed..."
cat failover/openai-to-local/simulate-error/openai-to-local-upstream.yaml
kubectl apply -f failover/openai-to-local/simulate-error
echo "Simulated error configuration applied to OpenAI failover upstream."
echo

echo "Testing failover with simulated error."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting simulated error test."
    break
  fi

  echo "Sending request to OpenAI endpoint with simulated error..."
  curl http://$GATEWAY_IP:8080/openai -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should now fail over to qwen-0.5b since the OpenAI upstream is unhealthy."
  echo
done


# Step 12: Cleanup Resources
echo
read -p "Step 11: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f failover/openai-to-local
kubectl delete -f failover/local-to-local
kubectl delete -f traffic-shift
echo "Demo resources cleaned up."
echo

echo "END OF DEMO"
