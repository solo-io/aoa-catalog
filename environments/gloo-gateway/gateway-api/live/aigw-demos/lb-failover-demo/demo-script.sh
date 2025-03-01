#!/bin/bash

# Prompt the user for protocol with predefined options
echo "Select the protocol:"
echo "1) http"
echo "2) https"
read -p "Enter your choice: " PROTOCOL_CHOICE

case $PROTOCOL_CHOICE in
  1|"")
    PROTOCOL="http"
    ;;
  2)
    PROTOCOL="https"
    ;;
  *)
    echo "Invalid choice. Defaulting to http."
    PROTOCOL="http"
    ;;
esac

# Prompt the user for port with predefined options
echo
echo "Select the port:"
if [ "$PROTOCOL" == "http" ]; then
  echo "1) 8080 (default)"
elif [ "$PROTOCOL" == "https" ]; then
  echo "1) 443 (default)"
fi
echo "2) Custom"

read -p "Enter your choice: " PORT_CHOICE

case $PORT_CHOICE in
  1|"")
    if [ "$PROTOCOL" == "http" ]; then
      AIGW_PORT="8080"
    elif [ "$PROTOCOL" == "https" ]; then
      AIGW_PORT="443"
    fi
    ;;
  2)
    read -p "Enter your custom port: " CUSTOM_PORT
    AIGW_PORT=$CUSTOM_PORT
    ;;
  *)
    echo "Invalid choice. Defaulting to the protocol's default port."
    if [ "$PROTOCOL" == "http" ]; then
      AIGW_PORT="8080"
    elif [ "$PROTOCOL" == "https" ]; then
      AIGW_PORT="443"
    fi
    ;;
esac

echo
echo "Using protocol: $PROTOCOL"
echo "Using port: $AIGW_PORT"
echo

echo "Starting the Load Balancing and Failover Demo..."

# Step 1: Review Example Upstreams
echo
read -p "Step 1: Review example upstream configurations. Press enter to proceed..."
echo
cat traffic-shift/ollama-qwen-0.5-upstream.yaml
echo
echo "---"
cat traffic-shift/ollama-qwen-1.8-upstream.yaml
echo

# Step 2: Review HTTPRoute for 50-50 Traffic Split
echo
read -p "Step 2: Review HTTPRoute for 50-50 traffic split. Press enter to proceed..."
echo
cat traffic-shift/qwen-5050-httproute.yaml
echo

# Step 3: Configure Traffic Shift
read -p "Step 3: Apply 50-50 traffic shift configuration. Press enter to proceed..."
kubectl apply -f traffic-shift
echo

# Step 4: Get AI Gateway Load Balancer Address
read -p "Step 4: Retrieve the AI Gateway Load Balancer address. Press enter to proceed..."
export GATEWAY_IP=$(kubectl get svc -n gloo-system --selector=gateway.networking.k8s.io/gateway-name=ai-gateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')
echo "Gateway IP: $GATEWAY_IP"
echo

# Step 5: Test Traffic Distribution
echo "Step 5: Test the traffic distribution."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting traffic distribution test."
    echo
    break
  fi

  echo "Sending request to AI Gateway..."
  echo
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should show a 50-50 distribution between qwen-0.5b and qwen-1.8b models."
  echo
done

# Step 6: Configure Local-to-Local Failover
read -p "Step 6: Configure local-to-local failover example. Press enter to proceed..."
echo
cat failover/local-to-local/failover-upstream.yaml
echo
echo "---"
cat failover/local-to-local/failover-route.yaml
echo
echo
kubectl apply -f failover/local-to-local
echo
echo "Local-to-local failover configuration applied."
echo

# Step 7: Test Failover
echo "Testing /failover endpoint."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  echo
  if [[ "$user_input" == "next" ]]; then
    break
  fi

  echo "Sending request to failover endpoint..."
  echo
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/failover -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should come from qwen-1.8b unless it's unhealthy, in which case it will fail over to qwen-0.5b."
  echo
done

# Step 8: Simulate Failover Errors
read -p "Step 8: Simulate failover errors. Press enter to proceed..."
echo
cat failover/local-to-local/simulate-error/failover-upstream.yaml
echo
echo
kubectl apply -f failover/local-to-local/simulate-error
echo
echo "Failover configuration with simulated errors applied."
echo
echo "Testing /failover endpoint."


while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  echo
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting failover error simulation test."
    break
  fi

  echo "Sending request to failover endpoint..."
  echo
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/failover -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
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
echo
kubectl create secret generic openai-secret -n gloo-system \
--from-literal="Authorization=Bearer $OPENAI_API_KEY" \
--dry-run=client -oyaml | kubectl apply -f -
echo
cat failover/openai-to-local/openai-to-local-upstream.yaml
echo
echo
kubectl apply -f failover/openai-to-local
echo
echo "OpenAI to local failover configuration applied."
echo

# Step 10: Test OpenAI Failover
echo
echo "Testing OpenAI failover endpoint."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  echo
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting OpenAI failover test."
    break
  fi

  echo "Sending request to OpenAI endpoint..."
  echo
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/openai -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
        }
      ]
    }'
  echo
  echo
  echo "Responses should initially come from OpenAI unless the upstream is unhealthy, in which case it will fail over to qwen-0.5b."
  echo
done

# Step 11: Simulate Error for OpenAI Failover
echo
read -p "Step 11: Simulate error for OpenAI failover. Press enter to proceed..."
echo
cat failover/openai-to-local/simulate-error/openai-to-local-upstream.yaml
echo
kubectl apply -f failover/openai-to-local/simulate-error
echo
echo
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
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/openai -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
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
