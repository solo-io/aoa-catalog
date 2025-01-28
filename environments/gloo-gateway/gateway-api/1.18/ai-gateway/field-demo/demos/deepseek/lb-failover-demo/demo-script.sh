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
cat traffic-shift/ollama-deepseek-1.5-upstream.yaml
echo

# Step 2: Review HTTPRoute for 50-50 Traffic Split
echo
read -p "Step 2: Review HTTPRoute for 50-50 traffic split. Press enter to proceed..."
echo
cat traffic-shift/deepseek-httproute.yaml
echo

# Step 3: Configure Traffic Shift
read -p "Step 3: Apply traffic shift configuration. Press enter to proceed..."
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
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/deepseek -H "Content-Type: application/json" -d '{
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
  echo "Responses should show a successful interaction with the deepseek-1.5b model."
  echo
done


# Step 12: Cleanup Resources
echo
read -p "Step 11: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f traffic-shift
echo "Demo resources cleaned up."
echo

echo "END OF DEMO"
